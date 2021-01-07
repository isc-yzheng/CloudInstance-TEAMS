Include HS.IHE.XDSb

Class HS.IHE.XDSb.Repository.Operations Extends (HS.HC.Util.Trace.Helper, HS.Util.SOAPClient.Operations, HS.Util.BaseHost) [ Inheritance = right, ProcedureBlock ]
{

Parameter HSDEPLOY = 1;

Parameter INVOCATION = "Queue";

Parameter SETTINGS = "CustomProcessor:Basic,-ServiceName,XDSbRepositoryServiceName:Basic:selector?Select=1&context={HS.Util.ContextSearch/ServiceNameItems},XDSbRegistryServiceName:Basic:selector?Select=1&context={HS.Util.ContextSearch/ServiceNameItems},ContentConsumerTarget,-ECRTarget,TextToRetrieveDocumentResponseTransform,-TargetName";

/// Only used when deployed on the bus, the Service Registry entry to use for the XDSb Repository actor
Property XDSbRepositoryServiceName As %String(MAXLEN = 512);

Property XDSbRegistryServiceName As %String(MAXLEN = 512) [ InitialExpression = "XDSb.Registry" ];

/// The business operation that converts the source format (such as CCD) to SDA HS.IHE.XDSb.ContentConsumer.Operations
Property ContentConsumerTarget As Ens.DataType.ConfigName(MAXLEN = 512);

Property ECRTarget As Ens.DataType.ConfigName [ InitialExpression = "HS.Gateway.ECR.Manager" ];

Property IHEVersion As %Integer [ InitialExpression = 1 ];

Property IHEExtension As %String;

Property Transformer As HS.Util.XSLTTransformer;

Property RepositoryOID As %String(MAXLEN = 64);

Property Errors As HS.Types.IHE.Errors;

Property TextToRetrieveDocumentResponseTransform As %String(MAXLEN = 250) [ InitialExpression = "IHE/XDSb/Version1/TextToRetrieveDocumentResponse.xsl" ];

Method OnInit() As %Status
{
	#dim tSC As %Status
	#dim eException as %Exception.AbstractException

	Set tSC = $$$OK

	Try {
		If (..Transformer = "") {
			Set ..IHEExtension = $Select(..IHEVersion = 1:"02", 1:"")
			Set ..Transformer = ##class(HS.Util.XSLTTransformer).%New()
		}
		Set ..RepositoryOID = ##class(HS.Data.OIDMap).GetOIDForCode($namespace,"")
	}
	Catch eException {
		Set tSC = eException.AsStatus()
	}

	Quit tSC
}

Method OnMessage(pRequest As %Persistent, Output pResponse As HS.Message.XMLMessage) As %Status
{
	#dim eException As %Exception.AbstractException
	
	Set tSC = $$$OK
	
	Try {
		Set ..Errors = ##class(HS.Types.IHE.Errors).%New()
		Set pResponse = ##class(HS.Message.XMLMessage).%New()

		//Handle async responses
		If pRequest.%ClassName(0)="XMLMessage" {
			If (pRequest.Name = $$$XDSbRetrieveResponse) {
				Set tSC = ..ForwardResponse(pRequest) $$$ThrowOnError(tSC)
				Quit
			}
			ElseIf (pRequest.Name = $$$XDSbRegisterResponse) {
				Set tSC = ..ForwardResponse(pRequest) $$$ThrowOnError(tSC)
				Quit
			}
		}
		#; if we are just forwarding this request (generally on the bus)
		If ..XDSbRepositoryServiceName]"" Set tSC = ..ForwardRequest(pRequest,.pResponse) Quit

		If pRequest.%IsA("HS.Message.IHE.XDSb.DeleteDocumentSetRequest") {
			Set tSC = ..RemoveDocuments(pRequest,.pResponse)
		} ElseIf pRequest.%ClassName(0)="XMLMessage" {
			If (pRequest.Name = $$$XDSbRegisterRequest) {
				Set ..TargetName = ..XDSbRegistryServiceName
				Set tAction = pRequest.AdditionalInfo.GetAt("SOAPAction")
				Set tSC = ..InvokeWebService(,, tAction, pRequest, .pResponse) $$$ThrowOnError(tSC)
			}
			ElseIf (pRequest.Name = $$$XDSbRetrieveRequest) {
				Set tSC = ..RetrieveDocument(pRequest, .pResponse) $$$ThrowOnError(tSC)
			}
			ElseIf (pRequest.Name = "XDSb_StoreRequest") {
				Set tSC = ..StoreDocument(pRequest, .pResponse) $$$ThrowOnError(tSC)
				If '(..Errors.Errors.Count()){
					Set tSC = ..ConsumeDocument(pRequest, .pResponse) $$$ThrowOnError(tSC)
				}
			}
			ElseIf (pRequest.Name = "XDSb_RollbackRequest") {
				Set tSC = ..RollbackDocuments(pRequest, .pResponse) $$$ThrowOnError(tSC)
			}
			Else {
				Set tSC = $$$ERROR($$$GeneralError, "Request type not handled:  " _ pRequest.Name) Quit
			}
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
	Quit tSC
}

Method RetrieveDocument(pRequest As HS.Message.XMLMessage, pResponse As HS.Message.XMLMessage) As %Status
{
	#dim eException As %Exception.AbstractException

	Set tSC = $$$OK

	Try {
		$$$HSTRACE("In Retrieve Document")
		Set pResponse = ##class(HS.Message.XMLMessage).%New()
		Set pResponse.Name = $$$XDSbRetrieveResponse
		If (pRequest.AdditionalInfo.GetAt("DeleteAttachments")){
			Do pResponse.AdditionalInfo.SetAt(1,"DeleteAttachments")
		}
		Set tReader=##class(%XML.Reader).%New()
		Set tReader.IgnoreSAXWarnings=1  /// added this due to NIST tools providing invalid schema location
 		Do tReader.Correlate("DocumentRequest","HS.Types.IHE.DocumentRequest")
		Set tSC=tReader.OpenStream(pRequest.ContentStream) Quit:$$$ISERR(tSC)
		#dim tDocument as HS.IHE.XDSb.Repository.Documents
	
		Set tResponseStream = ##class(%Library.GlobalCharacterStream).%New()
		Do tResponseStream.Write("<root>")
		Set tPartialSuccess=0,tIdx=0
		Set tFoundRequests=0
		While tReader.Next(.tRequest,.tSC) {
			Set tFoundRequests=1 //the request is at least more or less properly formed
			$$$ThrowOnError(tSC)
			$$$HSTRACE("In Retrieve Document","tRequest",tRequest)
			If tRequest.RepositoryUniqueId '= ..RepositoryOID Do ..Errors.logError("XDSUnknownRepositoryId","Error","Unknown repository OID "_tRequest.RepositoryUniqueId) Continue
			Set tDocumentID = tRequest.DocumentUniqueId
			If $tr(tDocumentID,$C(0))="" Do ..Errors.logError("XDSDocumentUniqueIdError","Error","document ID is empty") Continue
			Set tSC = ##class(HS.IHE.XDSb.Repository.Documents).DocumentObjectForID(tDocumentID,.tDocument)
			If $$$ISERR(tSC) || '$IsObject(tDocument) Do ..Errors.logError("XDSDocumentUniqueIdError","Error","Unable to locate document "_tDocumentID) Continue
			Set tPartialSuccess=1
			Set tIdx=tIdx+1,tText="" 
			#; following line is a testing scenario which returns every other document inline
			#;Set:tIdx#2 tText = tDocument.Document.Read(3000000)
			If 1 {
				Set tAttachment = ##class(HS.IHE.Common.Messages.MIMEAttachment).%New()
				Set tAttachment.ContentId = tDocumentID
				Set tAttachment.ContentType = tDocument.DocumentMimeType
				Set tAttachment.Body = ##class(%CSP.BinaryStream).%New()
				Do tAttachment.Body.CopyFrom(tDocument.Document)
				Do pResponse.StreamCollection.Insert(tAttachment)
				Do tResponseStream.Write("<DocInfo id=""" _ tDocumentID _ """ ContentId=""cid:" _ tDocumentID _ """ mimeType=""" _ tDocument.DocumentMimeType _ """>"_$system.Encryption.Base64Encode(tText)_"</DocInfo>")
			} Else {  /// inline
				Do tResponseStream.Write("<DocInfo id=""" _ tDocumentID _ """ ContentId=""cid:" _ tDocumentID _ """ mimeType=""" _ tDocument.DocumentMimeType _ """>")
				While 'tDocument.Document.AtEnd {
					Set tString = tDocument.Document.Read()
					Do tResponseStream.Write($System.Encryption.Base64Encode(tString))
				}
				Do tResponseStream.Write("</DocInfo>")
			}
			
		}
		Do:'tFoundRequests ..Errors.logError("XDSRepositoryError","Error","Unable to parse incoming message, or no document requests are present")
		Do ..Errors.XMLExportToString(.tErrors)
		Do tResponseStream.Write(tErrors)
		Do tResponseStream.Write("</root>")
		$$$HSTRACE("response input","tResponseStream",tResponseStream)
		Set tXSLArguments("status")=$s('tPartialSuccess:"Failure",..Errors.Errors.Count():"PartialSuccess",1:"Success")
		Set tXSLArguments("repositoryOID")=..RepositoryOID
		Do tResponseStream.Rewind()
		$$$HSTRACESTARTCALL
		Set tSC = ..Transformer.Transform(tResponseStream, ..TextToRetrieveDocumentResponseTransform /*"IHE/XDSb/Version1/TextToRetrieveDocumentResponse.xsl"*/, .tRetrieveResponse, .tXSLArguments) $$$ThrowOnError(tSC)
		$$$HSTRACEENDCALL
		Do pResponse.ContentStream.CopyFrom(tRetrieveResponse)
	}
	Catch eException {
		Set tSC = eException.AsStatus()
		Do ..Errors.logError("XDSRepositoryError","Error","Internal Error"_eException.DisplayString())
		Set tXSLArguments("status")="Failure"
		Set tXSLArguments("repositoryOID")=..RepositoryOID
		Do tResponseStream.Rewind(),tResponseStream.Write("<root>")
		Do ..Errors.XMLExportToString(.tErrors)
		Do tResponseStream.Write(tErrors)
		Do tResponseStream.Write("</root>")
		$$$HSTRACESTARTCALL
		Set tSC = ..Transformer.Transform(tResponseStream, ..TextToRetrieveDocumentResponseTransform /*"IHE/XDSb/Version1/TextToRetrieveDocumentResponse.xsl"*/, .tRetrieveResponse, .tXSLArguments) 
		$$$HSTRACEENDCALL
		Do tRetrieveResponse.Rewind()
		Do pResponse.ContentStream.CopyFrom(tRetrieveResponse)
	}
	Quit tSC
}

Method StoreDocument(pRequest As HS.Message.XMLMessage = {$$$NULLOREF}, Output pResponse As HS.Message.XMLMessage = {$$$NULLOREF}) As %Status
{
	#dim eException As %Exception.AbstractException
	
	Set tSC = $$$OK,tDocumentID="",tExisting=""
	
	Try {
		Set tDocument = ##class(HS.IHE.XDSb.Repository.Documents).%OpenId(pRequest.AdditionalInfo.GetAt("documentID"))
		If $IsObject(tDocument) {
			#; if size and hash are the same just pass the request on to the registry
			If (tDocument.DocumentHash '= pRequest.AdditionalInfo.GetAt("documentHash")) {
				Do ..Errors.logError("XDSNonIdenticalHash","Error","Existing Document hash "_tDocument.DocumentHash_" does not match "_pRequest.AdditionalInfo.GetAt("documentHash")) 
				Set tSC = $$$ERROR($$$GeneralError,"XDSNonIdenticalHash")
				Quit
			}
			If (tDocument.DocumentSize '= pRequest.AdditionalInfo.GetAt("documentSize")) {
				Do ..Errors.logError("XDSNonIdenticalSize","Error","Existing Document size "_tDocument.DocumentSize_" does not match "_pRequest.AdditionalInfo.GetAt("documentSize")) 
				Set tSC = $$$ERROR($$$GeneralError,"XDSNonIdenticalSize")
				Quit
			}
			// If document exists, and hash/size match, set flag to return and indicate this is an existing document.
			Set tExisting=1
		} Else {
			Set tDocument = ##class(HS.IHE.XDSb.Repository.Documents).%New()
			Do tDocument.Document.CopyFrom(pRequest.StreamCollection.GetAt(1).Body)
			Set tDocument.DocumentID = pRequest.AdditionalInfo.GetAt("documentID")
			Set tDocument.DocumentHash = pRequest.AdditionalInfo.GetAt("documentHash")
			Set tDocument.DocumentDescription = pRequest.AdditionalInfo.GetAt("documentDescription")
			Set tDocument.DocumentName = pRequest.AdditionalInfo.GetAt("documentName")
			Set tDocument.DocumentMimeType = pRequest.AdditionalInfo.GetAt("documentContentType")
			Set tDocument.DocumentSize = pRequest.AdditionalInfo.GetAt("documentSize")
			
			Set tSC = tDocument.%Save() $$$ThrowOnError(tSC)
		}
		Set tDocumentID=tDocument.%Id()
	}
	Catch eException {
		Set tSC = eException.AsStatus()
		Do ..Errors.logError("XDSRepositoryError","Error","Internal Error"_eException.DisplayString())
	}
	
	Set pResponse = ##class(HS.Message.XMLMessage).%New()
	Set pResponse.Name = "XDSb_StoreResponse"
	Set pResponse.DocType = "Status_Response"
	Set tErrorCount = ..Errors.Errors.Count()
	For tIdx=1:1:tErrorCount {
		Set tError = ..Errors.Errors.GetAt(tIdx)
		Do pResponse.AdditionalInfo.SetAt($lb(tError.Code,tError.Severity,tError.Description,tError.Location),"Error#"_tIdx)
	}
	If tErrorCount {
		Do pResponse.AdditionalInfo.SetAt(tErrorCount,"Errors")
	}
	Set tStatus = $System.Status.GetOneStatusText(tSC)
	If tErrorCount && (..Errors.HighestError="Error") { 
		Set tStatus = "ERROR"
	}
	Do pResponse.ContentStream.Write("<Status>" _ tStatus _ "</Status>")
	Do pResponse.AdditionalInfo.SetAt($g(tDocumentID),"repositoryDocumentID")
	Do pResponse.AdditionalInfo.SetAt(+tSC,"booleanStatus")
	// Set AdditionalInfo flag ExistingDocument 
	Do:tExisting pResponse.AdditionalInfo.SetAt(tExisting,"ExistingDocument")
	Quit $$$OK
}

Method RollbackDocuments(pRequest As HS.Message.XMLMessage, pResponse As HS.Message.XMLMessage) As %Status
{
	#dim eException As %Exception.AbstractException

	Set tSC = $$$OK

	Try {
		Set pResponse = ##class(HS.Message.XMLMessage).%New()
		Set pResponse.Name = "XDSb_RollbackResponse"
		Set pResponse.DocType = "Status_Response"

		Set tDocumentIDNode="repositoryDocumentID:"
		For  {
			Set tDocumentID = pRequest.AdditionalInfo.GetNext(.tDocumentIDNode) Quit:tDocumentIDNode=""
			Set tSC = ##class(HS.IHE.XDSb.Repository.Documents).%DeleteId(tDocumentID)
			Do pResponse.ContentStream.Write("<Status>" _ $System.Status.GetOneStatusText(tSC) _ "</Status>")
		}
		
	}
	Catch eException {
		Set tSC = eException.AsStatus()
		Do ..Errors.logError("XDSRepositoryError","Error","Internal Error"_eException.DisplayString())
	}

	Quit tSC
}

Method ConsumeDocument(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status
{
	#dim eException As %Exception.AbstractException
	
	Set tSC = $$$OK
	
	Try {
		If (..ContentConsumerTarget '= "") {
			Set tRequest = ##class(HS.Message.XMLMessage).%New()
			Set tRequest.Name = "XDSb_ConsumeAndStoreRequest"
			Set tRequest.AdditionalInfo = pRequest.AdditionalInfo
			Set tRequest.SAMLData = pRequest.SAMLData.%ConstructClone()
			Set tRequest.StreamCollection = pRequest.StreamCollection
			
			Set tSC = ##class(HS.IHE.CodedEntry).GetFormatToSDA(pRequest.AdditionalInfo.GetAt("documentFormatCode"), pRequest.AdditionalInfo.GetAt("documentFormatScheme"), .tTransform) $$$ThrowOnError(tSC)
			If (tTransform = "") {
				$$$LOGINFO("Skipping document, no SDA transform configured")
				Quit
			}
			
			Set tSC = ..SendRequestSync(..ContentConsumerTarget, tRequest, .pResponse) $$$ThrowOnError(tSC)
		}
	}
	Catch eException {
		Set pResponse = $$$NULLOREF
		Set tSC = eException.AsStatus()
		Do ..Errors.logError("XDSRepositoryError","Error","Internal Error"_eException.DisplayString())
	}
	
	Quit tSC
}

Method ForwardRequest(pRequest As HS.Message.XMLMessage, ByRef pResponse As HS.Message.XMLMessage) As %Status
{
	try {
		Set tSC=$$$OK
		Set ..TargetName = ..XDSbRepositoryServiceName
		Set tAction = pRequest.AdditionalInfo.GetAt("SOAPAction")
		#; if this is an async request and it is being forwarded, turn it into a synchronous request
		#; and do the async piece after
		Set tReplyTo = pRequest.AdditionalInfo.GetAt("ReplyAddress") 
		Set tIsAsync = (tReplyTo]"")
		Do pRequest.AdditionalInfo.SetAt("","ReplyAddress") 
		
		If pRequest.%ClassName(0)="XMLMessage",pRequest.StreamCollection.Count()>0 {
			#; if there are streams, send over MTOM  (catch HS and EnsLib versions)
			Set tSOAPClient = ##class(%SOAP.WebRequest).%New()
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
			Set tSC = ..InvokeWebService(tSOAPClient,, tAction, pRequest, .pResponse) $$$ThrowOnError(tSC)
		} Else {
			#; no streams, just send
			Set tSC = ..InvokeWebService(,, tAction, pRequest, .pResponse) $$$ThrowOnError(tSC)
		}
		#; if async send the response
		If tIsAsync {
			Do pResponse.AdditionalInfo.SetAt(tReplyTo,"ReplyAddress")
			Set tSC = ..InvokeWebService(,,tAction_"Response",pResponse,.tResponse,1)
		}
		Quit
	} catch ex {
		Set tSC = ex.AsStatus()
		Do ..Errors.logError("XDSbRepository","Error",$system.Status.GetErrorText(tSC))
	}
	Quit tSC
}

/// For cases when the request was asynchronous and provided a ReplyAddress, send the response to the appropriate web service
Method ForwardResponse(pResponse As HS.Message.XMLMessage) As %Status
{
	Set tSC=$$$OK
	Try{
		If ((pResponse.AdditionalInfo.GetAt("ReplyAddress")="")||(pResponse.AdditionalInfo.GetAt("ReplyAddress")["anonymous")){
			Set tSC = $$$ERROR($$$GeneralError,"ReplyAddress must be a valid URL")
			Quit
		}
		Set tAction = $Case(pResponse.Name, $$$XDSbRegisterResponse:$$$XDSbRegisterResponseAction(..IHEVersion), $$$XDSbRetrieveResponse:$$$XDSbRetrieveResponseAction(..IHEVersion),:"")
		If tAction="" {
			Set tSC = $$$ERROR($$$GeneralError,"Unsupported message type "_pResponse.Name)
			Quit
		}
		Do pResponse.AdditionalInfo.SetAt(tAction,"SOAPAction")
		Set tWebRequest = ##class(%SOAP.WebRequest).%New()
		Set tWebRequest.MTOMRequired=1 //MTOM is used for both provide and register responses and retrieve responses, even though the PnR response doesn't have attachments
		Set ..ServiceName=""
		Set ..TargetName=""
		Set tSC	=..InvokeWebService(tWebRequest,pResponse.AdditionalInfo.GetAt("ReplyAddress"), tAction, pResponse,,1)
	}
	Catch ex{
		Set tSC = ex.AsStatus()
		$$$HSTRACE("Caught error","tSC",tSC)
	}
	Quit tSC
}

/// RMD ITI-86
/// Optionally define customization class by setting CustomProcessor to class name and define either method<br>
/// Tracing in the methods with HSTRACECALLED, HSTRACECALLEDMIN, HSTRACECALLEDERROR<br>
/// Overriding the document delete for a particular document can be done by defining the OnPreRemoveDocuments method
///  <Method>ClassMethod OnPreRemoveDocuments(pHost As Ens.Host , Output pStopProcessing as %Boolean, pDocumentUniqueId As %String) as %Status</Method>
/// 	<li>if pStopProcessing is true processing this document (returned from the method). </li>
/// 	<li>Updates can be done to the pDocument object prior to any additional processing, such as extracting the service times from a different location in the CDA document</li>
///  <Method>ClassMethod OnPostRemoveDocuments(pHost As Ens.Host, ByRef pDocument As HS.Types.IHE.XDSb.Document, ByRef pXPathDoc) as %Status</Method>
/// 	<li>Additional processing can be done to the pDocument object, such as defaulting a value (Set pDocument.ServiceStartTime=$TR($zdt($h,8),": "),Document.ServiceStopTime=$TR($zdt($h,8),": ")) if the base code failed to locate a value</li>]]></Description>
Method RemoveDocuments(pRequest As HS.Message.IHE.XDSb.DeleteDocumentSetRequest, pResponse As HS.Message.IHE.XDSb.DeleteDocumentSetResponse) As %Status
{
	/// 
	try {
		Set tSC=$$$OK
		Set tUniqueId = ""
		Set pResponse = ##class(HS.Message.IHE.XDSb.DeleteDocumentSetResponse).%New()
		Set pResponse.Name = $$$RMDResponse
		Set tPartial = 0
		For {
			Set tRepository = pRequest.UniqueIdentifiers.GetNext(.tUniqueId)
			Quit:tUniqueId=""
			If tRepository'=..RepositoryOID {
				Do ..Errors.logError("XDSUnknownRepositoryId","Error",tRepository _ " is unknown for document "_tUniqueId)
				Continue
			} Else {
				$$$OnPre(.tStop,.tUniqueId) 
				If $G(tStop,0) || $$$ISERR(tSC) {
					If $$$ISERR(tSC) {
						Set tErrorMsg = $system.Status.GetErrorText(tSC)
					} Else {
						Set tErrorMsg = "Local policy prevents document delete"
					}
					Do ..Errors.logError("XDSRemoveDocumentsError","Error",tErrorMsg)
					Set tSC = $$$OK
					Continue
				}
				If '##class(HS.IHE.XDSb.Repository.Documents).%ExistsId(tUniqueId) {
					Do ..Errors.logError("XDSDocumentUniqueIdError","Error","Unable to locate document "_tUniqueId)
					Continue
				}
				Set tSC = ##class(HS.IHE.XDSb.Repository.Documents).%DeleteId(tUniqueId)
				If $$$ISERR(tSC) {
					Do ..Errors.logError("XDSRemoveDocumentsError","Error",$system.Status.GetErrorText(tSC))
					Set tSC = $$$OK
				} Else {
					Set tPartial=1
				}

			}
		}
	} Catch ex{
		Set tSC = ex.AsStatus()
	}
	Set pResponse = ##class(HS.Message.IHE.XDSb.DeleteDocumentSetResponse).%New()
	Set pResponse.Errors = ..Errors.%ConstructClone(1)
	If tPartial {
		IF ..Errors.Errors.Count() {
			Set pResponse.Status = "PartialSuccess"
		} Else {
			Set pResponse.Status = "Success"
		}
	} Else {
		Set pResponse.Status = "Failure"
	}		

	Set pResponse.ErrStatus = tSC
	Quit $$$OK
}

}
