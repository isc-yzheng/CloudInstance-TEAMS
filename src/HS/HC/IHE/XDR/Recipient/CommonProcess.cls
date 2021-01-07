Include (HS.IHE.ATNA, HS.IHE.XDSb)

/// XDR recipient process to handle inbound XDR and process as XDS, or custom processing<br>
/// Define the appropriate TransactionType to determine the code flow<br>
/// <li>Custom - completely custom handling of the inbound request</li>
/// <li>XDRProvide - Add patient to the registry and submit document as a XDSb Provide and Register</li>
/// <li>ClinicalMessage - Add patient to the registry and create clinical message to intended recipients</li>
/// Optionally define the Setting CustomProcessor with a class which contains the OnPre / OnPost methods (see individual methods for more information.<br>
Class HS.HC.IHE.XDR.Recipient.CommonProcess Extends (Ens.BusinessProcess, HS.Util.BaseHost, HS.HC.Util.Trace.Helper, HS.IHE.Common.Actor.Base, HS.Util.XSLTTransformer) [ ClassType = persistent, Inheritance = right ]
{

Parameter SETTINGS = "CustomProcessor:Basic,TransactionType:Basic,HUB:XDRProvide,MessageTarget:Basic,MetadataTransform,FromMetadataTransform,RegisterResponseTransform";

/// Config Item where the updated Message will be delivered
/// <br>TransactionType XDRProvide - HS.IHE.XDSb.Repository.Process
/// <br>TransactionType Custom - MessageTarget can be used in the custom code Set tSC = pHost.SendRequestSync(pHost.MessageTarget,Request,.Response)
Property MessageTarget As Ens.DataType.ConfigName;

/* ***  XDRProvide Settings *** */
/// <b>Used for TransactionType = XDRProvide</b><br>
/// The inbound request can be filed and sent to an XDSb Repository (XDRProvide) or sent to create a Clinical Message (Clinical Message) or Custom Processing can be done (Custom)
Property TransactionType As %Integer(DISPLAYLIST = ",XDRProvide,Custom", VALUELIST = ",0,2") [ InitialExpression = 0 ];

/// <b>Used for TransactionType = XDRProvide</b><br>
/// Config Item where the Add/Update Operations will be sent.  Send Patient updates to the Hub prior to registering the document
Property HUB As Ens.DataType.ConfigName [ InitialExpression = "HUB" ];

/* ***  Common Properties (Internal)  *** */
Property Errors As HS.Types.IHE.Errors [ Internal ];

Property MetadataTransform As %String(MAXLEN = 250) [ InitialExpression = "IHE/XDSb/Version1/Message-to-MetadataObject.xsl" ];

/// update to meta data need to transform it back from an object to the metadata
Property FromMetadataTransform As %String(MAXLEN = 250) [ InitialExpression = "IHE/XDSb/Version1/MetadataObject-to-Message.xsl" ];

Property RegisterResponseTransform As %String(MAXLEN = 250) [ InitialExpression = "IHE/XDSb/Version1/RegisterResponse.xsl" ];

/// Main processing of the request 
Method OnRequest(pRequest As %Library.Persistent, Output pResponse As %Library.Persistent) As %Status
{
	Set tSC=$$$OK
	try {
		Set ..Errors = ##class(HS.Types.IHE.Errors).%New()
		If pRequest.Name = $$$XDRProvideAndRegisterRequest {
			Set tSC = ..ProcessProvideAndRegister(pRequest,.pResponse)
		} Else {
			$$$LOGERROR("Unknown Request")
			Set tSC=$$$ERROR($$$GeneralError,"Unknown request")
		} 
	} Catch eException {
		Set tSC = eException.AsStatus()
		$$$LOGERROR(eException.DisplayString())
		Do ..Errors.logError("XDRError","Error","Internal Error:"_$system.Status.GetErrorText(tSC))
	}
	If ..Errors.Errors.Count() {
		$$$HSTRACE("Errors","Errors",..Errors)
		If '$IsObject(pResponse) || ('pResponse.ContentStream.Size) {
			Do ..CreateXDSbResponse(.pResponse,$$$QueryFailure)
		}
	}
	Quit tSC
}

/// Use the transaction type to determine the code path<br><br>
///  
/// Optionally define customization class by setting CustomProcessor to class name and define either method<br><br>
/// Tracing in the methods with HSTRACECALLED, HSTRACECALLEDMIN, HSTRACECALLEDERROR<br>
///   <Method>ClassMethod OnPreProcessProvideAndRegister(pHost As Ens.Host , Output pStopProcessing as %Boolean, pInboundRequest as HS.Message.XMLMessage, pRequest As HS.Message.IHE.XDSb.Metadata,ByRef pTransactionType, Output pResponse as HS.Message.XMLMessage) as %Status</Method>
/// 	<li>if pStopProcessing is true processing will terminate with tSC (either ok or error). It would be possible to dynamically determine the transaction type by the message content by updating pTransactionType</li>
/// 	<li>Updates can be done to the metadata object prior to any additional processing, such as providing necessary missing fields</li>
///   <Method>ClassMethod OnPostProcessProvideAndRegister(pHost As Ens.Host, pRequest) as %Status</Method>
/// 	<li>Additional processing can be done to the response, or the response itself can be updated</li>
/// Code path is determined by TransactionType
Method ProcessProvideAndRegister(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status
{
	Set tSC=$$$OK
	try {
		Set tSC = ..TransformObjects(pRequest, ..MetadataTransform /*"IHE/XDSb/Version1/Message-to-Metadata.xsl"*/, .tRequest, .tParams, "HS.Message.IHE.XDSb.Metadata","Metadata",1)
		$$$ThrowOnError(tSC)
		$$$HSTRACE("Metadata","tRequest",tRequest)
		Set tTransactionType = ..TransactionType
		$$$OnPre(.tStop,pRequest,.tRequest,.tTransactionType,.pResponse) Quit:$G(tStop)||$$$ISERR(tSC)||..Errors.Errors.Count()
		If tTransactionType=0 {
			Set tRequest.Name = $$$XDSbProvideAndRegisterRequest
			Do tRequest.AdditionalInfo.SetAt($$$XDSbProvideAndRegisterAction(1),"SOAPAction")
			Set tSC = ..XDRProvide(tRequest,.pResponse)
		} ElseIf tTransactionType=1 {
			/// only available in HealthShare
			Set tSC = ..DirectDeliver(tRequest,.pResponse)
		} ElseIf tTransactionType=2 {
			Set tSC = ..Custom(tRequest,.pResponse)
		}
		Set tSCAudit= $$$ATNAEvent("XDRDocRecipient",pRequest,pResponse,tSC) IF $$$ISERR(tSCAudit) $$$LOGERROR(tSCAudit)
		$$$OnPost(pRequest,tRequest,.pResponse)
	} Catch eException {
		Set tSC = eException.AsStatus()
		$$$LOGERROR(eException.DisplayString())
		Do ..Errors.logError("XDRError","Error","Internal Error:"_$system.Status.GetErrorText(tSC))
	}
	Quit tSC
}

/// Use the Metdata object (pRequest), validate the metadata object has a good structure<br><br>
///  
/// Optionally define customization class by setting CustomProcessor to class name and define either method<br>
/// Tracing in the methods with HSTRACECALLED, HSTRACECALLEDMIN, HSTRACECALLEDERROR<br>
///   <Method>ClassMethod OnPreMetadataValidate(pHost As Ens.Host , Output pStopProcessing as %Boolean, pRequest As HS.Message.IHE.XDSb.Metadata) as %Status</Method>
/// 	<li>if pStopProcessing is true processing will terminate with tSC (either ok or error).  It would be possible to turn off validation by creating a OnPreMetadataValidate that set the pStopProcessing =1 and Quit with success</li>
/// 	<li>Updates can be done to the metadata object prior to any additional processing, such as providing necessary missing fields</li>
///   <Method>ClassMethod OnPostMetadataValidate(pHost As Ens.Host, pRequest) as %Status</Method>
/// 	<li>Additional processing can be done to the response, or the response itself can be updated</li>
Method MetadataValidate(pRequest As HS.Message.IHE.XDSb.Metadata) As %Status
{
	Set tSC=$$$OK
	try {
		$$$OnPre(.tStop,.pRequest) Quit:$G(tStop)||$$$ISERR(tSC)
		If pRequest.Submissions.Count()=0 { Do ..Errors.logError("XDRProvide","Error",$$$Text("No submission set found")) Quit }
		If pRequest.Documents.Count()=0 { Do ..Errors.logError("XDRProvide","Error",$$$Text("No documents found")) Quit }
		Set tMinimal = $zcvt(pRequest.DirectMetadataLevel,"l")="minimal"
		For tIdx=1:1:pRequest.StreamCollection.Count() {
			Set tStreams(pRequest.StreamCollection.GetAt(tIdx).ContentId)=tIdx
		}
			
		For tIdx = 1:1:pRequest.Documents.Count() {
			#dim tDoc as HS.Types.IHE.XDSb.Document = pRequest.Documents.GetAt(tIdx)
			If tDoc.XOP]"" {
				Set tXOP=$ZCVT($p(tDoc.XOP,"cid:",2),"I","URL")
				Set:tXOP="" tXOP=tDoc.XOP
				If '$d(tStreams(tXOP)) {Do ..Errors.logError("XDRProvide","Error",$$$FormatText("Missing stream attachment %1",tXOP))}
				Else { Kill tStreams(tXOP)}
			} Else {
				If tDoc.Body.Size=0,tDoc.BodyCharacter.Size=0 Do ..Errors.logError("XDRProvide","Error",$$$Text("Missing document body"))
			}
			If 'tMinimal {
				If tDoc.ClassCode.Code="" Do ..Errors.logError("XDRProvide","Error",$$$Text("Document class code not specified")) 
				If tDoc.ConfidentialityCode.Count()=0 Do ..Errors.logError("XDRProvide","Error",$$$Text("Document confidentiality code not specified")) 
				If tDoc.CreationTime="" Do ..Errors.logError("XDRProvide","Error",$$$Text("Document creation time is required")) 
				If tDoc.FormatCode.Code="" Do ..Errors.logError("XDRProvide","Error",$$$Text("Document format code is required")) 
				If tDoc.HealthCareFacilityTypeCode.Code="" Do ..Errors.logError("XDRProvide","Error",$$$Text("Document healthcare facility type code is required")) 
				If tDoc.LanguageCode="" Do ..Errors.logError("XDRProvide","Error",$$$Text("Document langugage code is required")) 
				If tDoc.PatientIdentifier.Value="" Do ..Errors.logError("XDRProvide","Error",$$$Text("Document patient identifier is required")) 
				If tDoc.PracticeSettingCode.Code="" Do ..Errors.logError("XDRProvide","Error",$$$Text("Document practice setting code is required")) 
				If tDoc.SourcePatientId="" Do ..Errors.logError("XDRProvide","Error",$$$Text("Document source patient identifier is required")) 
				If tDoc.TypeCode.Code="" Do ..Errors.logError("XDRProvide","Error",$$$Text("Document type code is required")) 
				
			}
			If tDoc.EntryUUID="" Do ..Errors.logError("XDRProvide","Error",$$$Text("Document entry UUID is required")) 
			If tDoc.MimeType="" Do ..Errors.logError("XDRProvide","Error",$$$Text("Document mime type is required")) 
			If tDoc.DocumentUniqueIdentifier.Value="" Do ..Errors.logError("XDRProvide","Error",$$$Text("Document unique identifier is required")) 
		}

		If $d(tStreams) { Do ..Errors.logError("XDRProvide","Error",$$$Text("Extra attachments found")) Quit }

		For tIdx = 1:1:pRequest.Submissions.Count() {
			#dim tSubmission as HS.Types.IHE.XDSb.Submission = pRequest.Submissions.GetAt(tIdx)
			If 'tMinimal {
				If tSubmission.ContentTypeCode.Code="" Do ..Errors.logError("XDRProvide","Error",$$$Text("Submission set content type code is required")) 
				If tSubmission.PatientIdentifier.Value="" Do ..Errors.logError("XDRProvide","Error",$$$Text("Submission set patient identifier is required")) 
			}
			If tSubmission.EntryUUID="" Do ..Errors.logError("XDRProvide","Error",$$$Text("Submission set entry UUID is required")) 
			If tSubmission.SourceIdentifier.Value="" Do ..Errors.logError("XDRProvide","Error",$$$Text("Submission source identifier is required"))
			If tSubmission.SubmissionTime="" Do ..Errors.logError("XDRProvide","Error",$$$Text("Submission time is required"))
			If tSubmission.UniqueIdentifier.Value="" Do ..Errors.logError("XDRProvide","Error",$$$Text("Submission set unique identifier is required")) 
		}

		For tIdx = 1:1:pRequest.Folders.Count() {
			#dim tFolder as HS.Types.IHE.XDSb.Folder = pRequest.Folders.GetAt(tIdx)
			If 'tMinimal {
				If tFolder.PatientIdentifier.Value="" Do ..Errors.logError("XDRProvide","Error",$$$Text("Folder patient identifier is required")) 
				If tFolder.Title.ValueText="" Do ..Errors.logError("XDRProvide","Error",$$$Text("Folder title is required")) 
			}
			If tFolder.EntryUUID="" Do ..Errors.logError("XDRProvide","Error",$$$Text("Folder entry UUID is required")) 
			If tFolder.UniqueIdentifier.Value="" Do ..Errors.logError("XDRProvide","Error",$$$Text("Folder unique identifier is required")) 
		}
		$$$OnPost(.pRequest) Quit:$G(tStop)||$$$ISERR(tSC)
	} Catch eException {
		Set tSC = eException.AsStatus()
		Do ..Errors.logError("XDRError","Error","Internal Error:"_$system.Status.GetErrorText(tSC))
	}
	$$$HSTRACE("ValidateErrorcount: "_..Errors.Errors.Count())
	Quit tSC
}

/// <b>Called for TransactionType = XDRProvide</b><br>
/// Uses the Metdata object (pRequest) and calls
/// <li>GetDemographics - Uses metadata to build AddUpdateHubRequest</li>
/// <li>UpdatePatient - Uses built AddUpdateHubRequest (from above) and submits to the registry </li>
/// <li>BuildProvideAndRegister - tranform the metadta object and submit to the repository</li>
///  <br>
/// Optionally define customization class by setting CustomProcessor to class name and define either method<br>
/// Tracing in the methods with HSTRACECALLED, HSTRACECALLEDMIN, HSTRACECALLEDERROR
///   <Method>ClassMethod OnPreXDRProvide(pHost As Ens.Host , Output pStopProcessing as %Boolean, pRequest As HS.Message.IHE.XDSb.Metadata, pResponse as HS.Message.XMLMessage) as %Status</Method>
/// 	<li>if pStopProcessing is true processing will terminate with tSC (either ok or error)</li>
/// 	<li>Updates can be done to the metadata object prior to any additional processing, such as providing necessary missing fields</li>
///   <Method>ClassMethod OnPostXDRProvide(pHost As Ens.Host, pRequest As HS.Message.IHE.XDSb.Metadata, pResponse as HS.Message.XMLMessage) as %Status</Method>
/// 	<li>Additional processing can be done to the response, or the response itself can be updated</li>
Method XDRProvide(pRequest As HS.Message.IHE.XDSb.Metadata, Output pResponse As %Library.Persistent) As %Status
{
	Set tSC=$$$OK
	try {
		$$$OnPre(.tStop,.pRequest,.pResponse) Quit:$G(tStop)||$$$ISERR(tSC)

		Set pRequest.Name = $$$XDSbProvideAndRegisterRequest
		Do pRequest.AdditionalInfo.SetAt($$$XDSbProvideAndRegisterAction(1),"SOAPAction")

		#; build AddUpdateHubRequest
		Set tSC = ..GetDemographics(pRequest,.tAddUpdateHubRequest) Quit:$$$ISERR(tSC)||..Errors.Errors.Count()

		#; Send AddUpdateHubRequest and update pRequest patient id's(submission, docs, folders)
		Set tSC = ..UpdatePatient(pRequest,.tAddUpdateHubRequest) Quit:$$$ISERR(tSC)||..Errors.Errors.Count()

		#; create outbound Provide and Register request 
		Set tSC = ..BuildProvideAndRegister(pRequest,.tOutboundRequest) Quit:$$$ISERR(tSC)||..Errors.Errors.Count()

		#; validate the metadata
		Set tSC = ..MetadataValidate(pRequest) Quit:$$$ISERR(tSC)||..Errors.Errors.Count()

		#; Send outbound Provide and Register request to local repository process
		Set tSC = ..SendRequestSync(..MessageTarget,tOutboundRequest,.pResponse) Quit:$$$ISERR(tSC)||..Errors.Errors.Count()
		Set pResponse.Name=$$$XDRProvideAndRegisterResponse

		$$$OnPost(.pRequest,.pResponse) Quit:$G(tStop)||$$$ISERR(tSC)
	} Catch eException {
		Set tSC = eException.AsStatus()
		$$$LOGERROR(eException.DisplayString())
		Do ..Errors.logError("XDRError","Error","Internal Error:"_$system.Status.GetErrorText(tSC))
	}
	If ..Errors.Errors.Count() {
		Do ..CreateXDSbResponse(.pResponse,$$$QueryFailure)
	}
	Quit tSC
}

/// <b>Called for TransactionType = Custom</b><br>
/// Creates an XDSbResponse by calling Set tSC = ..CreateXDSbResponse(.pResponse)
///  <br>
/// Optionally define customization class by setting CustomProcessor to class name and define either method<br>
/// Tracing in the methods with HSTRACECALLED, HSTRACECALLEDMIN, HSTRACECALLEDERROR
///   <Method>ClassMethod OnPreCustom(pHost As Ens.Host , Output pStopProcessing as %Boolean, pRequest As HS.Message.IHE.XDSb.Metadata, pResponse as HS.Message.XMLMessage) as %Status</Method>
/// 	<li>if pStopProcessing is true processing will terminate with tSC (either ok or error)</li>
///   <Method>ClassMethod OnPostCustom(pHost As Ens.Host, pRequest as HS.Message.IHE.XDSb.Metadata, pResponse as HS.Message.XMLMessage) as %Status</Method>
/// 	<li>Additional processing can be done to the response, or the response itself can be updated</li>
Method Custom(pRequest As HS.Message.IHE.XDSb.Metadata, Output pResponse As HS.Message.XMLMessage) As %Status
{
	Set tSC=$$$OK
	try {
		$$$OnPre(.tStop,.pRequest,.pResponse) Quit:$G(tStop)||$$$ISERR(tSC)
		Set tSC = ..CreateXDSbResponse(.pResponse)
		$$$OnPost(.pRequest,.pResponse) Quit:$G(tStop)||$$$ISERR(tSC)
		Set tSC=$$$ATNAEvent("XDSbRepository",pRequest,pResponse,tSC) $$$ThrowOnError(tSC)
	} Catch eException {
		Set tSC = eException.AsStatus()
		$$$LOGERROR(eException.DisplayString())
		Do ..Errors.logError("XDRError","Error","Internal Error:"_$system.Status.GetErrorText(tSC))
	}
	Quit tSC
}

/// Extract demographics from the message metadata (uses the first submission set and first document) and place into AddUpdateHubRequest message and return<br><br>
/// Optionally define customization class by setting CustomProcessor to class name and define either method<br>
/// Tracing in the methods with HSTRACECALLED, HSTRACECALLEDMIN, HSTRACECALLEDERROR
///   <Method>ClassMethod OnPreGetDemographics(pHost As Ens.Host , Output pStopProcessing as %Boolean, pRequest As HS.Message.IHE.XDSb.Metadata, pAddUpdateHubRequest As HS.Message.AddUpdateHubRequest) as %Status</Method>
/// 	<li>if pStopProcessing is true processing will terminate with tSC (either ok or error)</li>
/// 	<li>Updates can be done to the metadata object prior to any additional processing, such as providing necessary missing fields</li>
///   <Method>ClassMethod OnPostGetDemographics(pHost As Ens.Host, As HS.Message.IHE.XDSb.Metadata, Output pAddUpdateHubRequest As HS.Message.AddUpdateHubRequest) as %Status</Method>
/// 	<li>Additional processing can be done to the response, or the response itself can be updated</li>
Method GetDemographics(pRequest As HS.Message.IHE.XDSb.Metadata, Output pAddUpdateHubRequest As HS.Message.AddUpdateHubRequest) As %Status
{
	try {
		Set tSC = $$$OK
		$$$OnPre(.tStop,.pRequest,.pAddUpdateHubRequest) Quit:$G(tStop)||$$$ISERR(tSC)
		Set pAddUpdateHubRequest = ##class(HS.Message.AddUpdateHubRequest).%New()
		#dim tSubmissionSet as HS.Types.IHE.XDSb.Submission = pRequest.Submissions.GetAt(1)
		#dim tDocument as HS.Types.IHE.XDSb.Document = pRequest.Documents.GetAt(1)
		Set tSourceId = tSubmissionSet.SourceIdentifier.Value

		Set pAddUpdateHubRequest.MRN = $P(tDocument.SourcePatientId,"^",1)
		Set tAA = $P(tDocument.SourcePatientId,"&",2)
		Set pAddUpdateHubRequest.AssigningAuthority = ##class(HS.Data.OIDMap).GetCodeForOID(tAA,tAA)
		Set:(tAA=$$$AffinityDomainOID) pAddUpdateHubRequest.MPIID = $P(tDocument.PatientIdentifier.Value,"^",1)
		Set tFacility = ##class(HS.Data.OIDMap).GetCodeForOID(tAA,"")
		Set:tFacility="" tFacility=##class(HS.Data.OIDMap).GetCodeForOID(tSourceId)
		Set pAddUpdateHubRequest.Facility = tFacility
		If ##class(HS.Facility.Config).%ExistsId(tFacility) Set:'$$$IsHub pAddUpdateHubRequest.GatewayName=##Class(HS.Util.Installer.ConfigItem).GetThisComponentName()
		For i=1:1:tDocument.SourcePatientInfo.Count() {
			Set tValue = tDocument.SourcePatientInfo.GetAt(i).Value
			Set tData = $P(tValue,"|",2)
			Set tType = $p(tValue,"|",1)
			If tType="PID-5" {
				Set pAddUpdateHubRequest.LastName = $P(tData,"^",1)
				Set pAddUpdateHubRequest.FirstName= $P(tData,"^",2)
				Set pAddUpdateHubRequest.MiddleName = $P(tData,"^",3)
				Set pAddUpdateHubRequest.Suffix = $p(tData,"^",4)
			} ElseIf tType="PID-7" {
				Set:$l(tData)>=8 pAddUpdateHubRequest.DOB=$zdh($E(tData,1,4)_"-"_$E(tData,5,6)_"-"_$E(tData,7,8),3)
			} ElseIf tType="PID-8" {
				Set pAddUpdateHubRequest.Sex=tData
			} ElseIf tType="PID-11" {
				Set tAddress = ##class(HS.Types.Address).%New()
				Set tAddress.StreetLine=$p(tData,"^")
				Set tAddress.UnitNumber = $p(tData,"^",2)
				Set tAddress.City=$p(tData,"^",3)
				Set tAddress.State=$p(tData,"^",4)
				Set tAddress.PostalCode=$p(tData,"^",5)
				Set tAddress.Country=$p(tData,"^",6)
				Do pAddUpdateHubRequest.Addresses.Insert(tAddress)
			}
		}
		Set pAddUpdateHubRequest.EventType = "DOC"
		$$$OnPost(.pRequest,.pAddUpdateHubRequest) Quit:$$$ISERR(tSC)
	} Catch eException {
		Set tSC = eException.AsStatus()
		$$$LOGSTATUS(tSC)
		Do ..Errors.logError("XDRError","Error","Internal Error:"_$system.Status.GetErrorText(tSC))
	}
	Quit tSC
}

/// Using AddUpdateHubRequest created in GetDemographics, update the patient ID with MPI ID (submission set, documents, folders)<br><br>
/// 
/// Optionally define customization class by setting CustomProcessor to class name and define either method<br>
/// Tracing in the methods with HSTRACECALLED, HSTRACECALLEDMIN, HSTRACECALLEDERROR
///   <Method>ClassMethod OnPreUpdatePatient(pHost As Ens.Host , Output pStopProcessing as %Boolean, pRequest As HS.Message.IHE.XDSb.Metadata, pAddUpdateHubRequest) as %Status</Method>
/// 	<li>if pStopProcessing is true processing will terminate with tSC (either ok or error)</li>
/// 	<li>Updates can be done to the metadata object prior to any additional processing, such as providing necessary missing fields</li>
///   <Method>ClassMethod  OnPostUpdatePatient(pDummy As %Boolean, pHost As Ens.Host, pRequest As HS.Message.IHE.XDSb.Metadata, pAddUpdateHubRequest,pAddUpdateHubResponse) as %Status</Method>
/// 	<li>Additional processing can be done to the response, or the response itself can be updated</li>
/// 	<li>pDummy is present only for compatibility reasons and doesn't affect anything within UpdatePatient
Method UpdatePatient(pRequest As HS.Message.IHE.XDSb.Metadata, Output pAddUpdateHubRequest As HS.Message.AddUpdateHubRequest) As %Status
{
	try {
		Set tSC = $$$OK
		$$$OnPre(.tStop,.pRequest,.pAddUpdateHubRequest) Quit:$G(tStop)||$$$ISERR(tSC)
		Set pAddUpdateHubRequest.EventType = "DOC"

		#dim tAddUpdateHubResponse As HS.Message.AddUpdateHubResponse
		Set tSC = ..SendRequestSync(..HUB, pAddUpdateHubRequest, .tAddUpdateHubResponse) $$$ThrowOnError(tSC)
		If tAddUpdateHubResponse.ErrStatus]"" $$$ThrowOnError(tAddUpdateHubResponse.ErrStatus)

		Set tSubmission = pRequest.Submissions.GetAt(1)
		If (tAddUpdateHubResponse.MPIID'=$p(tSubmission.PatientIdentifier.Value,"^",1)) || ($p(tSubmission.PatientIdentifier.Value,"&",2)'=$$$AffinityDomainOID) {
			Set tNewPatientID=tAddUpdateHubResponse.MPIID_"^^^&"_$$$AffinityDomainOID_"&ISO"
			For tIdx = 1:1:pRequest.Submissions.Count() {
				Set pRequest.Submissions.GetAt(tIdx).PatientIdentifier.Value=tNewPatientID
			}
			For tIdx = 1:1:pRequest.Documents.Count() {
				Set pRequest.Documents.GetAt(tIdx).PatientIdentifier.Value=tNewPatientID
			}
			
			For tIdx = 1:1:pRequest.Folders.Count() {
				Set pRequest.Folders.GetAt(tIdx).PatientIdentifier.Value=tNewPatientID
			}
			$$$HSTRACE("Updated Metadata","pRequest",pRequest)
		}

		$$$OnPost(.tDummy, .pRequest,.pAddUpdateHubRequest,.tAddUpdateHubResponse) Quit:$$$ISERR(tSC)
	} Catch eException {
		Set tSC = eException.AsStatus()
		$$$LOGSTATUS(tSC)
		Do ..Errors.logError("XDRError","Error","Internal Error:"_$system.Status.GetErrorText(tSC))
	}
	Quit tSC
}

/// Called by XDRProvide, take Metadata Object and build outbound message (XMLMessage)<br><br>
/// 
/// Optionally define customization class by setting CustomProcessor to class name and define either method<br>
/// Tracing in the methods with HSTRACECALLED, HSTRACECALLEDMIN, HSTRACECALLEDERROR
///   <Method>ClassMethod OnPreBuildProvideAndRegister(pHost As Ens.Host , Output pStopProcessing as %Boolean, pRequest As HS.Message.IHE.XDSb.Metadata, Output pOutboundRequest As HS.Message.XMLMessage) as %Status</Method>
/// 	<li>if pStopProcessing is true processing will terminate with tSC (either ok or error)</li>
/// 	<li>Updates can be done to the metadata object prior to any additional processing, such as providing necessary missing fields</li>
///   <Method>ClassMethod  OnPostBuildProvideAndRegister(pHost As Ens.Host, pRequest As HS.Message.IHE.XDSb.Metadata, Output pOutboundRequest As HS.Message.XMLMessage) as %Status</Method>
/// 	<li>Additional processing can be done to the response, or the response itself can be updated</li>
Method BuildProvideAndRegister(pRequest As HS.Message.IHE.XDSb.Metadata, Output pOutboundRequest As HS.Message.XMLMessage) As %Status
{
	try {
		Set tSC = $$$OK
		$$$OnPre(.tStop,.pRequest,.pOutboundRequest) Quit:$G(tStop)||$$$ISERR(tSC)
		Set pOutboundRequest = ##class(HS.Message.XMLMessage).%New()
		Set tSC = ##class(HS.IHE.XDSb.Util).AttachDocuments(0,pRequest,.pOutboundRequest) Quit:$$$ISERR(tSC)
		Set tSC = ..TransformFromObject(pRequest, ..FromMetadataTransform /*"IHE/XDSb/Version1/MetadataObject-to-Message.xsl"*/, .tStream, .tParams) $$$ThrowOnError(tSC)
		Do pOutboundRequest.ContentStream.CopyFrom(tStream)
		Set pOutboundRequest.Name=$$$XDSbProvideAndRegisterRequest
		Set tAdditional = pRequest.AdditionalInfo.%ConstructClone(0)
		Set pOutboundRequest.AdditionalInfo=tAdditional
		$$$OnPost(.pRequest,.pOutboundRequest) Quit:$G(tStop)||$$$ISERR(tSC)
	} Catch eException {
		Set tSC = eException.AsStatus()
		$$$LOGSTATUS(tSC)
		Do ..Errors.logError("XDRError","Error","Internal Error:"_$system.Status.GetErrorText(tSC))
	}
	Quit tSC
}

/// Create a XDSb response object as HS.Message.XMLMessage with a status of Success or Failure
Method CreateXDSbResponse(pResponse As HS.Message.XMLMessage = "", pStatus = {$$$QuerySuccess}) As %Status
{
	If '$isObject(pResponse) {Set pResponse = ##class(HS.Message.XMLMessage).%New(),pResponse.Name = $$$XDRProvideAndRegisterResponse}
	Set tStream=##class(%Stream.GlobalCharacter).%New()
	Do ..Errors.XMLExportToString(.tErrors)
	Do tStream.Write("<Submission>"_tErrors_"</Submission>")
	Set tParam("status")=$S(..Errors.Errors.Count()=0:"Success",1:"Failure")
	$$$HSTRACESTARTCALL
	Set tSC = ..Transform(tStream,..RegisterResponseTransform /*"IHE/XDSb/Version1/RegisterResponse.xsl"*/,.tResponseStream,.tParam)
	$$$HSTRACEENDCALL
	Do pResponse.ContentStream.CopyFrom(tResponseStream)
	Quit $$$OK
}

/// Only available in HealthShare
Method DirectDeliver(pRequest As HS.Message.IHE.XDSb.Metadata, Output pResponse As HS.Message.XMLMessage) As %Status
{
	Quit $$$OK
}

/// OnResponse must be overridden here to avoid error upon response from async request.
Method OnResponse(pRequest As Ens.Request, ByRef pResponse As Ens.Response, pCallrequest As Ens.Request, pCallresponse As Ens.Response, pCompletionKey As %String) As %Status
{
	Quit $$$OK
}

/// This user callback method is called via initConfig() from %OnNew() or in the case of SOAP Services from OnPreSOAP()
Method OnInit() As %Status
{
	Quit ..ValidateCustomProcessor()
}

Storage Default
{
<Data name="CommonProcessDefaultData">
<Subscript>"CommonProcess"</Subscript>
<Value name="1">
<Value>CustomProcessor</Value>
</Value>
<Value name="2">
<Value>CustomProcessorIsValid</Value>
</Value>
<Value name="3">
<Value>TransactionType</Value>
</Value>
<Value name="4">
<Value>HUB</Value>
</Value>
<Value name="5">
<Value>XSLTErrorHandlerClass</Value>
</Value>
<Value name="6">
<Value>Errors</Value>
</Value>
<Value name="7">
<Value>CallbackHandler</Value>
</Value>
<Value name="8">
<Value>ErrorHandler</Value>
</Value>
<Value name="9">
<Value>RegisterResponseTransform</Value>
</Value>
<Value name="10">
<Value>DoHSTrace</Value>
</Value>
<Value name="11">
<Value>ClearCallbackVariables</Value>
</Value>
<Value name="12">
<Value>FromMetadataTransform</Value>
</Value>
<Value name="13">
<Value>MessageTarget</Value>
</Value>
<Value name="14">
<Value>MetadataTransform</Value>
</Value>
<Value name="15">
<Value>TraceOperations</Value>
</Value>
<Value name="16">
<Value>UseXSLT2</Value>
</Value>
<Value name="17">
<Value>XSLTCacheMode</Value>
</Value>
<Value name="18">
<Value>XSLTCallbackHandlerClass</Value>
</Value>
<Value name="19">
<Value>XSLTDirectory</Value>
</Value>
</Data>
<DefaultData>CommonProcessDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
