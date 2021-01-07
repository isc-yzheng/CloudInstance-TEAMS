Include HS.IHE.XDSb

/// Operation used to convert / send direct messages<br>
/// The operation will accept a XMLMessage with the metadata or an inbound Metadata object <class>HS.Message.IHE.XDSb.Metadata</class> and convert to an <class>HS.Message.XMLMessage</class>
/// and send to the XDR recipient<br>
/// ServiceName holds the Service registry entry with the XDR recipient endpoint<br>
Class HS.IHE.XDR.Source.Operations Extends (HS.HC.Util.Trace.Helper, HS.Util.BaseHost, HS.Util.XSLTTransformer, HS.Util.SOAPClient.Operations) [ Inheritance = right, ProcedureBlock ]
{

Parameter INVOCATION = "Queue";

Parameter DOMAIN = "HS";

Parameter SETTINGS = "CustomProcessor:Basic,-TargetName,DocumentsInline,DocumentTransform";

/// Send documents inline instead of as attachments (when processing a Metadata Object)
/// This will move the documents from inline to attachments but will not move attachments into inline
Property DocumentsInline As %Boolean [ InitialExpression = 0 ];

/// XSLT to tranform inbound object to stream
Property DocumentTransform As %String(MAXLEN = 255) [ InitialExpression = "IHE/XDSb/Version1/MetadataObject-to-Message.xsl" ];

Property Errors As HS.Types.IHE.Errors;

Method OnMessage(pRequest As %Persistent, Output pResponse As HS.Message.XMLMessage) As %Status
{
	#dim eException As %Exception.AbstractException
	
	Set tSC = $$$OK
	
	Try {
		Set ..Errors = ##class(HS.Types.IHE.Errors).%New()
		Set pResponse = ##class(HS.Message.XMLMessage).%New()
		Set tSendRequest = pRequest.%ConstructClone(1)
		#; if provided with a Metadata request convert to outbound request
		If tSendRequest.%ClassName(0)="Metadata" {
			#; convert the Metadata to XMLMessage
			Set tSC=..ConvertRequest(tSendRequest,.tUpdatedRequest)
			$$$HSTRACE("updated request","tUpdatedRequest",tUpdatedRequest)
			Quit:$$$ISERR(tSC)
			Set tSendRequest=tUpdatedRequest
		}
		If tSendRequest.%ClassName(0)="XMLMessage" {
			Set tSC = ..SendRequest(tSendRequest,.pResponse)
			Quit
		} Else {
			$$$ThrowStatus($$$ERROR($$$GeneralError,$$$Text("Unhandled message type")))
		}
			
	}
	Catch eException {
		Set pResponse = $$$NULLOREF
		Set tSC = eException.AsStatus()
		Do ..Errors.logError("XDSbRepository","Error",$system.Status.GetErrorText(tSC))
	}
	If ..Errors.Errors.Count() {
		$$$HSTRACE("Errors","Errors",..Errors)
		Set tErrorText="",tWarningText=""
		For tIdx=1:1:..Errors.Errors.Count() {
			Set tError = ..Errors.Errors.GetAt(tIdx)
			If tError.Severity="Error" {
				Set tErrorText = tErrorText _ "["_tError.Description_ "]"
			} Else {
				Set tWarningText = tWarningText _ "["_tError.Description_ "]"
			}
		}
		If tErrorText]"" $$$LOGERROR(tErrorText)
		If tWarningText]"" $$$LOGWARNING(tWarningText)
	}
	If $$$ISERR(tSC) {
		Do ##class(HS.IHE.XDSb.Util).ErrorResponse(tSC,$$$XDSbProvideAndRegisterResponse,.pResponse)
		Set tSC=$$$OK
	}
	Quit tSC
}

/// Convert Metdata object into outbound Metadata stream<br>
/// 
/// Optionally define customization class by setting CustomProcessor to class name and define either method
/// 	Tracing in the methods with HSTRACECALLED, HSTRACECALLEDMIN, HSTRACECALLEDERROR
///   OnPreConvertRequest(Output pStopProcessing, pRequest, pUpdatedRequest) as %Status
/// 				if pStopProcessing is true processing will terminate with tSC (either ok or error)
///   OnPostConvertRequest(pRequest, pUpdatedRequest) as %Status
Method ConvertRequest(pRequest As HS.Message.IHE.XDSb.Metadata, ByRef pUpdatedRequest As HS.Message.XMLMessage) As %Status
{
	Set tSC = $$$OK
	Try {
		$$$OnPre(.tStop,.pRequest,.pUpdatedRequest) Quit:$G(tStop)||$$$ISERR(tSC)
		Set pUpdatedRequest=##class(HS.Message.XMLMessage).%New()
		Set pUpdatedRequest.AdditionalInfo = pRequest.AdditionalInfo.%ConstructClone(0)
		#; optionally move inline documents to attachments, at a minimum move BodyCharacter to Body, calculate size / hash 
		Set tSC = ##class(HS.IHE.XDSb.Util).AttachDocuments(..DocumentsInline,pRequest,.pUpdatedRequest) $$$ThrowOnError(tSC)
		Set tSC = ..UpdateMetadataAssociations(.pRequest)
		Set pRequest.Name=$$$XDSbProvideAndRegisterRequest
		Set tSC = ..TransformFromObject(pRequest,..DocumentTransform /*"IHE/XDSb/Version1/MetadataObject-to-Message.xsl"*/,.tMetadataStream)
		Quit:$$$ISERR(tSC)
		Do pUpdatedRequest.ContentStream.CopyFrom(tMetadataStream)
		If pRequest.DirectFrom]"" {
			If pRequest.AdditionalInfo.GetAt("Direct:FROM")]"" $$$ThrowStatus($$$ERROR($$$GeneralError,$$$Text("Direct from populated in both the property and additional info")))
			Do pUpdatedRequest.AdditionalInfo.SetAt(pRequest.DirectFrom,"Direct:FROM")
		}
		If pRequest.DirectTo.Count() {
			If pRequest.AdditionalInfo.GetAt("Direct:TO")]"" $$$ThrowStatus($$$ERROR($$$GeneralError,$$$Text("Direct to populated in both the property and additional info")))
			Set tTo=""
			For tIdx=1:1:pRequest.DirectTo.Count() {
				Set tTo=tTo_";"_pRequest.DirectTo.GetAt(tIdx)
			}
			Do pUpdatedRequest.AdditionalInfo.SetAt($e(tTo,2,*),"Direct:TO")
		}
		If pRequest.DirectMetadataLevel]"" {
			If pRequest.AdditionalInfo.GetAt("Direct:METADATA-LEVEL")]"" $$$ThrowStatus($$$ERROR($$$GeneralError,$$$Text("Direct metadata level populated in both the property and additional info")))
			Do pUpdatedRequest.AdditionalInfo.SetAt(pRequest.DirectMetadataLevel,"Direct:METADATA-LEVEL")
		}

		$$$OnPost(.pRequest,.pUpdatedRequest)
	}
	Catch eException {
		Set pResponse = $$$NULLOREF
		Set tSC = eException.AsStatus()
		Do ..Errors.logError("XDSbRepository","Error",$system.Status.GetErrorText(tSC))
	}
	Quit tSC
}

/// Send Metadata message to target and accept response
/// 		Uses the ..XDSbRepositoryServiceName for the target endpoint
/// 		Creates the direct header in the soap message in the AddDirectHeader method
/// 		Adds any attachments to the message and invokes the web service
/// 
/// Optionally define customization class by setting CustomProcessor to class name and define either method
/// 		Do not update pRequest in either method
/// 		Tracing in the methods with HSTRACECALLED, HSTRACECALLEDMIN, HSTRACECALLEDERROR
///   OnPreSendRequest(Output pStopProcessing, pRequest, pResponse) as %Status
/// 		if pStopProcessing is true processing will terminate with tSC (either ok or error)
///   OnPostSendRequest(pRequest, pResponse) as %Status
Method SendRequest(pRequest As HS.Message.XMLMessage, ByRef pResponse As HS.Message.XMLMessage) As %Status
{
	try {
		$$$OnPre(.tStop,.pRequest,.pResponse) Quit:$G(tStop)||$$$ISERR(tSC)
		Set tSC=$$$OK
		Set tAction = $$$XDSbProvideAndRegisterAction(1)
		
		Set tSOAPClient = ##class(%SOAP.WebRequest).%New()
		Set tSC = ..AddDirectHeader(tSOAPClient,pRequest) Quit:$$$ISERR(tSC)
		#; if there are streams, send over MTOM  (catch HS and EnsLib versions)
		If pRequest.StreamCollection.Count()>0 {
			Set tSOAPClient.MTOMRequired=1
			Set i="" For { Set tDocument=pRequest.StreamCollection.GetNext(.i) Quit:i=""
				Set tDocument.Body.Headers=""   //otherwise setting the body will corrupt the content-id
				Set tMTOMAttachment = ##class(%Net.MIMEPart).%New()
				Set tMTOMAttachment.ContentId	= tDocument.ContentId
				Set tMTOMAttachment.ContentType	= tDocument.ContentType
				Set tMTOMAttachment.ContentTransferEncoding	= tDocument.ContentTransferEncoding
				Set tMTOMAttachment.Body=tDocument.Body
				Do tSOAPClient.Attachments.Insert(tMTOMAttachment)
			}
		}
		Set tSC = ..InvokeWebService(tSOAPClient,, tAction, pRequest, .pResponse) $$$ThrowOnError(tSC)
		$$$OnPost(.pRequest,.pResponse)
	} catch ex {
		Set tSC = ex.AsStatus()
		Do ..Errors.logError("XDSbRepository","Error",$system.Status.GetErrorText(tSC))
	}
	Quit tSC
}

/// Extract data from request and add to the webrequest
/// 	Looks for data in the pRequest.AdditionalInfo property in Direct:FROM, Direct:TO and Direct:METADATA-LEVEL
/// 	Will only create a Header record if Direct:FROM and Direct:TO are defined.
/// 
/// Optionally define customization class by setting CustomProcessor to class name and define either method
/// 	Do not update pRequest in either method
/// 	Tracing in the methods with HSTRACECALLED, HSTRACECALLEDMIN, HSTRACECALLEDERROR
///   OnPreAddDirectHeader(Output pStopProcessing, pWebRequest, pRequest) as %Status
/// 		if pStopProcessing is true processing will terminate with tSC (either ok or error)
///   OnPostAddDirectHeader(pWebRequest, pRequest) as %Status
Method AddDirectHeader(pWebRequest, pRequest) As %Status
{
	Set tSC=$$$OK
	try {
		$$$OnPre(.tStop,.pWebRequest,.pRequest) Quit:$g(tStop)||$$$ISERR(tSC)
		Set tFrom=pRequest.AdditionalInfo.GetAt("Direct:FROM")
		#; list needs to be converted to / from list to string to list for passing in the additional info
		Set tTo=pRequest.AdditionalInfo.GetAt("Direct:TO")
		If tFrom]"",tTo]"" {
			Set tHeader=##class(HS.IHE.XDSb.Types.AddressBlockHeader).%New()
			Set tHeader.from=tFrom
			For tIdx=1:1:$l(tTo,";") Do tHeader.to.Insert($p(tTo,";",tIdx))
			Set tHeader.role="urn:direct:addressing:destination"
			Do pWebRequest.HeadersOut.SetAt(tHeader,"addressBlock")
			#; add metadatalevel
			Set tHeader=##class(HS.IHE.XDSb.Types.MetadataLevelHeader).%New()
			If pRequest.AdditionalInfo.GetAt("Direct:METADATA-LEVEL")]"" {
				Set tHeader.Level=pRequest.AdditionalInfo.GetAt("Direct:METADATA-LEVEL")
			} Else {
				Set tHeader.Level="XDS"
			}
			Do pWebRequest.HeadersOut.SetAt(tHeader,"metadata-level")
		}
		$$$OnPost(.pWebRequest,.pRequest)
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Update the associations related to the submission (if and only if there is just 1 submission set)<br><br>
/// Optionally define customization class by setting CustomProcessor to class name and define either method
/// 	Do not update pRequest in either method
/// 	Tracing in the methods with HSTRACECALLED, HSTRACECALLEDMIN, HSTRACECALLEDERROR
///   OnPreAddDirectHeader(Output pStopProcessing, pWebRequest, pRequest) as %Status
/// 		if pStopProcessing is true processing will terminate with tSC (either ok or error)
///   OnPostAddDirectHeader(pWebRequest, pRequest) as %Status
Method UpdateMetadataAssociations(pRequest As HS.Message.IHE.XDSb.Metadata) As %Status
{
	Set tSC=$$$OK
	try {
		$$$OnPre(.tStop,.pRequest) Quit:$G(tStop)||$$$ISERR(tSC)
		
		If pRequest.Submissions.Count()=1 {
			#dim tSubmission as HS.Types.IHE.XDSb.Submission = pRequest.Submissions.GetAt(1)
			Set tHaveSubmissionAssociation=0
			
			#; user may have already created associations track which items and don't create them again
			Set tAssociations=""
			For tIdx =1:1:pRequest.Associations.Count() {
				#dim tAssociation as HS.Types.IHE.XDSb.Association = pRequest.Associations.GetAt(tIdx)
				If tAssociation.AssociationType="HasMember",tAssociation.TargetObject]"" {
					Set tAssociations(tAssociation.TargetObject,tAssociation.SourceObject)=""
					If tAssociation.SourceObject=tSubmission.EntryUUID Set tHaveSubmissionAssociation=1
				}
				
			}
			If 'tHaveSubmissionAssociation {
				Set tAssociation = ##class(HS.Types.IHE.XDSb.Association).Create("HasMember",tSubmission.EntryUUID,"")
				Set tAssociation.TargetObject = tAssociation.EntryUUID
			}


			For tIdx=1:1:pRequest.Documents.Count() {
				#dim tDocument as HS.Types.IHE.XDSb.Document = pRequest.Documents.GetAt(tIdx)
				#; don't add the association if it is already in there
				If $D(tAssociations(tDocument.EntryUUID,tSubmission.EntryUUID)) Continue

				Set tAssociation = ##class(HS.Types.IHE.XDSb.Association).Create("HasMember",tSubmission.EntryUUID,tDocument.EntryUUID)
				If tDocument.Version]"" Set tAssociation.PreviousVersion=tDocument.Version
				Set tAssociation.SubmissionSetStatus="Original"
				Do pRequest.Associations.Insert(tAssociation)
				If tDocument.ReplaceSource]"" {
					Set tReplaceSource=tDocument.ReplaceSource
					If $E(tReplaceSource,1,3)="urn" Set tReplaceSource=$p(tReplaceSource,"urn:uuid:",2)
					Set tAssociation = ##class(HS.Types.IHE.XDSb.Association).Create("Replaces",tDocument.EntryUUID,tReplaceSource)
					Do pRequest.Associations.Insert(tAssociation)
				}
			}
			For tIdx=1:1:pRequest.Folders.Count() {
				Set tFolder=pRequest.Folders.GetAt(tIdx)
				#; don't add the association if it is already in there

				If $D(tAssociations(tFolder.EntryUUID,tSubmission.EntryUUID)) Continue
				Set tAssociation = ##class(HS.Types.IHE.XDSb.Association).Create("HasMember",tSubmission.EntryUUID,tFolder.EntryUUID)
				Do pRequest.Associations.Insert(tAssociation)
			}
		}
		$$$OnPost(.pRequest)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
