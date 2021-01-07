Include (HS.IHE.XDSb, HS.IHE.ATNA, HS.HC)

Class HS.IHE.XDSb.Repository.Process Extends (Ens.BusinessProcess, HS.HC.Util.Trace.Helper) [ ClassType = persistent, Inheritance = left ]
{

Parameter HSDEPLOY = 1;

Parameter SETTINGS = "RepositoryOperations,RegistryOperations,ProvidePostProcessor,XDSbRetrieveConsentTarget,ProvidePreProcessor,ValidateSizeAndHash,ProvideAndRegisterToRegisterTransform,RegisterResponseTransform,TextToRetrieveDocumentResponseTransform,RemoveDocumentsTransform,RemoveDocumentsTarget";

Property RepositoryOperations As Ens.DataType.ConfigName [ InitialExpression = "HS.IHE.XDSb.Repository.Operations" ];

Property RegistryOperations As Ens.DataType.ConfigName [ InitialExpression = "HS.IHE.XDSb.Repository.Operations" ];

Property RemoveDocumentsTarget As Ens.DataType.ConfigName [ InitialExpression = "HS.IHE.XDSb.Repository.Operations" ];

Property IHEVersion As %Integer [ InitialExpression = 1 ];

Property Transformer As HS.Util.XSLTTransformer;

/// Checks the size and hash values provided against calculated values 
/// and alerts the user to discrepancies. Disabling this option silences 
/// the alert. Whether this option is enabled or disabled, the calculated 
/// values are used for registration.
Property ValidateSizeAndHash As %Boolean [ InitialExpression = 1 ];

Property Errors As HS.Types.IHE.Errors;

Property RepositoryOID As %String(MAXLEN = 64);

/// Pre Processor for XDSb_ProvideAndRegisterDocumentSet
Property ProvidePreProcessor As Ens.DataType.ConfigName;

/// Additional processing for documents with a given format code after document registration/store.
/// Will not execute if registration or store failed. Failure of the post processor will not
/// rollback document store.
/// <p>The value is a delimeted list: formatCode^^formatScheme^^targetHost||formatCode^^formatScheme^^targetHost...
/// <p>For example: urn:nhin:names:acp:XACML^^1.3.6.1.4.1.19376.1.2.3^^HS.Consent.XACML.Importer
Property ProvidePostProcessor As %String(MAXLEN = "");

/// ConfigName of the business host for consent evaluation for retrieve responses.
/// By default, consent is not evaluated for retrieve.
Property XDSbRetrieveConsentTarget As Ens.DataType.ConfigName;

Property ProvideAndRegisterToRegisterTransform As %String(MAXLEN = 250) [ InitialExpression = "IHE/XDSb/Version1/ProvideAndRegisterToRegister.xsl" ];

Property RegisterResponseTransform As %String(MAXLEN = 250) [ InitialExpression = "IHE/XDSb/Version1/RegisterResponse.xsl" ];

Property TextToRetrieveDocumentResponseTransform As %String(MAXLEN = 250) [ InitialExpression = "IHE/XDSb/Version1/TextToRetrieveDocumentResponse.xsl" ];

Property RemoveDocumentsTransform As %String(MAXLEN = 250) [ InitialExpression = "IHE/XDSb/Version1/RMDRequestToRequest.xsl" ];

Method OnRequest(pRequest As %Persistent, Output pResponse As %Persistent) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set ..Errors = ##class(HS.Types.IHE.Errors).%New()
		$$$GetTransformer(..Transformer)
		Set ..RepositoryOID = ##class(HS.Data.OIDMap).GetOIDForCode($namespace,"")

		Set pResponse = ##class(HS.Message.XMLMessage).%New()

		If pRequest.%IsA("HS.Message.XMLMessage") {
			Set tAction = pRequest.AdditionalInfo.GetAt("SOAPAction")
			
			If (tAction = $$$XDSbProvideAndRegisterAction(..IHEVersion)) {
				Set pResponse.Name=$$$XDSbProvideAndRegisterResponse
				If ..RepositoryOID="" $$$ThrowOnError($$$ERROR($$$GeneralError,"Repository OID is not defined. Define an oid for code:"_$namespace))
				#; XDSb_ProvideAndRegisterDocumentSet Transaction *
				If ..ProvidePreProcessor'="" {
					Set tRequest=pRequest.%ConstructClone(1)
					Set tSC = ..SendRequestSync(..ProvidePreProcessor,tRequest,.tPreProcessorResponse)
					Quit:$$$ISERR(tSC)
					Set pRequest=tPreProcessorResponse,(tPreProcessorResponse,tRequest)=""
				}
				Set tSC = ..ProvideAndRegisterDocumentSetb(pRequest, .pResponse) 
				Do $$$ATNAEvent("XDSbRepository",pRequest,pResponse,tSC)
				$$$ThrowOnError(tSC)
				//If the provide and register was successful, check whether to delete attachments
				Set tResponseStatus = ##class(HS.IHE.XDSb.Util).ProcessResponse(pResponse)
				If ($$$ISOK(tResponseStatus)&&pRequest.AdditionalInfo.GetAt("DeleteAttachments")){
					Do ##class(HS.IHE.XDSb.Util).DeleteAttachments(.pRequest)
				}
				If (##class(HS.IHE.Util).IsAsync(pRequest)) {
					Set pResponse.Name=$$$XDSbRegisterResponse
					Set tSC = ..PrepareAndSendAsync(pRequest,.pResponse) $$$ThrowOnError(tSC)
				}
				$$$ThrowOnError(tSC)
			}
			ElseIf (tAction = $$$XDSbRetrieveAction(..IHEVersion)) {
				Set pResponse.Name=$$$XDSbRetrieveResponse
				#; XDSb_RetrieveDocumentSet Transaction *
				#; if repositoryOID is null we need to route the transaction (typically on the bus)
				If ..RepositoryOID="" {
					Set tSC = ##class(HS.IHE.Util).GetXPathValue(pRequest.ContentStream,"/xdsb:RetrieveDocumentSetRequest/xdsb:DocumentRequest/xdsb:RepositoryUniqueId","text()",.tValue)
					Set tService = ##class(HS.Registry.Service.Abstract).EndPointForOID(tValue,"Repository","XDSb.Retrieve")
					If '$IsObject(tService) $$$ThrowOnError($$$ERROR($$$GeneralError,"Repository ID not defined for namespace and a service cannot be located for OID: "_tValue))
					Do pRequest.AdditionalInfo.SetAt(tService.Name,"ServiceName")
					Set tSC = ..SendRequestSync(..RepositoryOperations,pRequest,.pResponse) $$$ThrowOnError(tSC)
				} Else {
					Set tSC = ..RetrieveDocumentSet(pRequest, .pResponse) 
					//%HS_NotifyAndQueryOperations is only used for an internal HS message - don't audit
					Do:pRequest.SAMLData.HSRoles'="%HS_NotifyAndQueryOperations" $$$ATNAEvent("XDSbRepository",pRequest,pResponse,tSC)
					$$$ThrowOnError(tSC)
				}
				If (##class(HS.IHE.Util).IsAsync(pRequest)) {
					Set tSC = ..PrepareAndSendAsync(pRequest,.pResponse)
					$$$ThrowOnError(tSC)
					//If the retrieve request was successful, check whether to delete attachments
					Set tResponseStatus = ##class(HS.IHE.XDSb.Util).ProcessResponse(pResponse)
					If ($$$ISOK(tResponseStatus)&&(pResponse.AdditionalInfo.GetAt("DeleteAttachments"))){
						Do ##class(HS.IHE.XDSb.Util).DeleteAttachments(.pResponse)
					}
				}

			}
			ElseIf (pRequest.%IsA("HS.Message.IHE.XDSb.DeleteDocumentSetRequest")) {
				Set tSC = ..DeleteDocuments(pRequest,.pResponse)
			}
			ElseIf (tAction = $$$RMDAction(..IHEVersion)) {
				Set tSC = ..RemoveDocuments(pRequest,.pResponse)
			}
			Else {
				Set tSC = $$$ERROR($$$GeneralError, "Unknown SOAP Action:  " _ tAction) $$$ThrowOnError(tSC)
			}
		}
		Else {
			Set tSC = $$$ERROR($$$GeneralError, "Unknown Message Type:  " _ pRequest.%ClassName(1)) $$$ThrowOnError(tSC)
		}
	}
	Catch eException {
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
	#; if the message is an erorr, and we have not reported the problem (contentstream is empty) report the problem
	If $$$ISERR(tSC) && (pResponse.ContentStream.Size=0) {
		Do ##class(HS.IHE.XDSb.Util).ErrorResponse(tSC,pResponse.Name,.pResponse,..Transformer)
		Set tSC=$$$OK
	}
	Quit tSC
}

/// OnResponse must be overridden here to avoid error upon response from async request.
Method OnResponse(pRequest As Ens.Request, ByRef pResponse As Ens.Response, pCallrequest As Ens.Request, pCallresponse As Ens.Response, pCompletionKey As %String) As %Status
{
	Quit $$$OK
}

Method ProvideAndRegisterDocumentSetb(pRequest As HS.Message.XMLMessage, pResponse As HS.Message.XMLMessage) As %Status
{
	#dim eException As %Exception.AbstractException

	/// used for debugging simultaneous transactions
	If ..TraceOperations=100 Lock +^HS.Repository.Document.Testing#"S"
	Try {
		Set tStoredDocument=0
		Set tRegistryResponse = ""
		Set tXPathNamespaces = ##class(HS.IHE.Util).XPathNamespaces()
		Set tSC = ##class(%XML.XPATH.Document).CreateFromStream(pRequest.ContentStream, .tDocument, , , , , tXPathNamespaces) $$$ThrowOnError(tSC)
		Set tSC = ..ParseRegistrationHeader(tDocument, .tDocumentArray)
		If $$$ISERR(tSC) Do ..Errors.logError("XDSRepository","Error","Unable to parse registration header "_$system.Status.GetErrorText(tSC)) Quit
		Quit:..Errors.Errors.Count()
		#; move any inline documents to attachments and build tDocumentArray
		Set tSC = ..BuildAttachments(pRequest,tDocument,.tDocumentArray)
		Quit:..Errors.Errors.Count()

		Set tSC = tDocument.EvaluateExpression("/xdsb:ProvideAndRegisterDocumentSetRequest/lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:RegistryPackage/rim:ExternalIdentifier[@identificationScheme='urn:uuid:6b5aea1a-874d-4603-a4bc-96a0a7b38446']", "@value", .tResults) 
		If $$$ISOK(tSC) {
			Set tLockPatientID = $S('$IsObject(tResults):"",tResults.Count():tResults.GetAt(1).Value)
			$$$HSTRACE("patient id "_tLockPatientID)
			/// lock for single patient processing
			If tLockPatientID]"" {
				Lock +^HS.Repository.Document.Patient(tLockPatientID)
			}
		} Else {
			Set tLockPatientID = ""
		}
		#; Now store and register all documents
		Set tInputStream = ##class(%Stream.GlobalCharacter).%New()
		Do tInputStream.Write("<root>")
		For tStreamIndex = 1:1:pRequest.StreamCollection.Count() {
			Set tDocumentStream = pRequest.StreamCollection.GetAt(tStreamIndex)
			Set tDocumentStream.ContentId=$zcvt(tDocumentStream.ContentId,"I","URL")
			
			Set tDocumentIndex = $g(tDocumentArray("Reference", tDocumentStream.ContentId))
			If tDocumentIndex = "" {
				Do ..Errors.logError("XDSbRepository","Error","Content id:"_tDocumentStream.ContentId_" referenced but not found")
				Continue
			}
			If '$Data(tDocumentArray(tDocumentIndex, "documentID")) {
				Do ..Errors.logError("XDSbRepository","Warning","Un-referenced attachment found in mime collection:  " _ tDocumentIndex)
				$$$LOGINFO("Un-referenced attachment found in mime collection:  " _ tDocumentIndex) Continue
			}

			#; Calculate hash
			Set tHashValue = ##class(HS.IHE.XDSb.Util).StreamHash(tDocumentStream.Body)
			#; adding setting check because this is something not checked previously
			if ..ValidateSizeAndHash {
				Set tValue=$G(tDocumentArray(tDocumentIndex,"hash"),tHashValue)
				If tValue]"" && ($zcvt(tValue,"l")'=tHashValue) Do ..Errors.logError("XDSRepositoryMetadataError","Error","Incorrect hash value Document:"_tDocumentIndex_" hash: "_tHashValue_"'="_tValue) Quit
				Set tValue= $G(tDocumentArray(tDocumentIndex,"size"),tDocumentStream.Body.Size)
				If tValue]"" && (tValue'=tDocumentStream.Body.Size) Do ..Errors.logError("XDSRepositoryMetadataError","Error","Incorrect size value Document:"_tDocumentIndex_" size "_tDocumentStream.Body.Size) Quit
			}
			#; Store document
			Set tDocumentRequest = ##class(HS.Message.XMLMessage).%New()
			Set tDocumentRequest.Name = "XDSb_StoreRequest"
			Set tDocumentRequest.AdditionalInfo = pRequest.AdditionalInfo.%ConstructClone()  ///SAML/User Auth
			Set tDocumentRequest.SAMLData = pRequest.SAMLData.%ConstructClone()  ///SAML/User Auth

			Do tDocumentRequest.AdditionalInfo.SetAt(tDocumentArray(tDocumentIndex, "documentID"), "documentID")
			Do tDocumentRequest.AdditionalInfo.SetAt(tDocumentArray(tDocumentIndex, "documentName"), "documentName")
			Do tDocumentRequest.AdditionalInfo.SetAt(tDocumentArray(tDocumentIndex, "documentDescription"), "documentDescription")
			Do tDocumentRequest.AdditionalInfo.SetAt(tDocumentArray(tDocumentIndex, "documentContentType"), "documentContentType")
			Do tDocumentRequest.AdditionalInfo.SetAt(tDocumentArray(tDocumentIndex, "documentCreationTime"), "documentCreationTime")
			Do tDocumentRequest.AdditionalInfo.SetAt(tDocumentArray(tDocumentIndex, "documentFormatCode"), "documentFormatCode")
			Do tDocumentRequest.AdditionalInfo.SetAt(tDocumentArray(tDocumentIndex, "documentFormatScheme"), "documentFormatScheme")
			Do tDocumentRequest.AdditionalInfo.SetAt(tDocumentArray(tDocumentIndex, "serviceStartTime"), "serviceStartTime")
			Do tDocumentRequest.AdditionalInfo.SetAt(tDocumentArray(tDocumentIndex, "serviceStopTime"), "serviceStopTime")
			Do tDocumentRequest.AdditionalInfo.SetAt(tDocumentArray(tDocumentIndex, "patientSourceID"), "patientSourceID")
			Do tDocumentRequest.AdditionalInfo.SetAt(tDocumentArray(tDocumentIndex, "patientSourceAssigningAuthority"), "patientSourceAssigningAuthority")
			Do tDocumentRequest.AdditionalInfo.SetAt(tDocumentArray(tDocumentIndex, "patientSourceFirstName"), "patientSourceFirstName")
			Do tDocumentRequest.AdditionalInfo.SetAt(tDocumentArray(tDocumentIndex, "patientSourceLastName"), "patientSourceLastName")
			Do tDocumentRequest.AdditionalInfo.SetAt(tDocumentArray(tDocumentIndex, "patientSourceDOB"), "patientSourceDOB")
			Do tDocumentRequest.AdditionalInfo.SetAt(tDocumentArray(tDocumentIndex, "patientSourceSex"), "patientSourceSex")
			Do tDocumentRequest.AdditionalInfo.SetAt(tDocumentArray(tDocumentIndex, "patientSourceAddressStreetLine1"), "patientSourceAddressStreetLine1")
			Do tDocumentRequest.AdditionalInfo.SetAt(tDocumentArray(tDocumentIndex, "patientSourceAddressStreetLine2"), "patientSourceAddressStreetLine2")
			Do tDocumentRequest.AdditionalInfo.SetAt(tDocumentArray(tDocumentIndex, "patientSourceAddressCity"), "patientSourceAddressCity")
			Do tDocumentRequest.AdditionalInfo.SetAt(tDocumentArray(tDocumentIndex, "patientSourceAddressState"), "patientSourceAddressState")
			Do tDocumentRequest.AdditionalInfo.SetAt(tDocumentArray(tDocumentIndex, "patientSourceAddressZip"), "patientSourceAddressZip")
			Do tDocumentRequest.AdditionalInfo.SetAt(tDocumentArray(tDocumentIndex, "patientSourceAddressCountry"), "patientSourceAddressCountry")
			Do tDocumentRequest.AdditionalInfo.SetAt(tDocumentArray(tDocumentIndex, "patientGlobalID"), "patientGlobalID")
			Do tDocumentRequest.AdditionalInfo.SetAt(tDocumentArray(tDocumentIndex, "patientGlobalAssigningAuthority"), "patientGlobalAssigningAuthority")
			Do tDocumentRequest.AdditionalInfo.SetAt(..RepositoryOID, "repositoryOID")
			Do tDocumentRequest.AdditionalInfo.SetAt(tDocumentStream.Body.Size, "documentSize")
			Do tDocumentRequest.AdditionalInfo.SetAt(tHashValue, "documentHash")
			Do tDocumentRequest.AdditionalInfo.SetAt(tDocumentArray(tDocumentIndex, "documentFormatCode"), "documentFormatCode")
			Do tDocumentRequest.AdditionalInfo.SetAt(tDocumentArray(tDocumentIndex, "documentFormatScheme"), "documentFormatScheme")
			Do tDocumentRequest.StreamCollection.Insert(tDocumentStream)
			
			Do tInputStream.Write("<DocInfo id=""" _ tDocumentArray(tDocumentIndex, "documentID") _ """ hash=""" _ tHashValue _ """ size=""" _ tDocumentStream.Body.Size _ """/>")

			Set tSC = ..SendRequestSync(..RepositoryOperations, tDocumentRequest, .tRepositoryResponse) $$$ThrowOnError(tSC)
			If '$IsObject(tRepositoryResponse){
				Throw ##class(%Exception.StatusException).CreateFromStatus($$$ERROR($$$GeneralError,"No response from repository operations"))
			}
			Set tErrorcount = tRepositoryResponse.AdditionalInfo.GetAt("Errors")
			For tErrorIdx=1:1:tErrorcount {
				$$$HSTRACE("Error "_tErrorIdx)
				Set tItem = tRepositoryResponse.AdditionalInfo.GetAt("Error#"_tErrorIdx)
				Do ..Errors.logError($li(tItem),$li(tItem,2),$li(tItem,3),$li(tItem,4))
			}
			If 'tStoredDocument && 'tErrorcount {
				Set tStoredDocument=1
			}
			Set tDocumentArray(tDocumentIndex,"repositoryDocumentID")= tRepositoryResponse.AdditionalInfo.GetAt("repositoryDocumentID")
			// Set new flag to indicate this document already existed on the Repository
			Set tDocumentArray(tDocumentIndex,"ExistingDocument")= tRepositoryResponse.AdditionalInfo.GetAt("ExistingDocument")
			Quit:tErrorcount  /// problem storing document don't store the rest to just rollback
		}

		#; Register documents
		Do pRequest.ContentStream.Rewind(), tInputStream.CopyFrom(pRequest.ContentStream)
		Do tInputStream.Write("</root>"), tInputStream.Rewind()
	
		Set tXSLArguments("repositoryOID") = ..RepositoryOID

		$$$HSTRACESTARTCALL
		Set tSC = ..Transformer.Transform(tInputStream, ..ProvideAndRegisterToRegisterTransform /*"IHE/XDSb/Version1/ProvideAndRegisterToRegister.xsl"*/, .tOutputStream, .tXSLArguments)
		$$$HSTRACEENDCALL
		If $$$ISERR(tSC) Do ..Errors.logError("XDSbRepository","Error","unable to transform to registry request"_$system.Status.GetErrorText(tSC))
		$$$HSTRACE("Registry Request","tOutputStream,tInputStream",tOutputStream,tInputStream)
		Set tRegistration = ##class(HS.Message.XMLMessage).%New()
		Set tRegistration.Name = $$$XDSbRegisterRequest
		Set tRegistration.ContentStream = tOutputStream
		Do tRegistration.ContentStream.Rewind()
		Set tRegistration.AdditionalInfo = pRequest.AdditionalInfo.%ConstructClone()  ///SAML/User Auth
		Set tRegistration.SAMLData = pRequest.SAMLData.%ConstructClone()  ///SAML/User Auth
		Do tRegistration.AdditionalInfo.SetAt($$$XDSbRegisterAction(..IHEVersion), "SOAPAction")
		#; only send registration if no errors
		If '..Errors.Errors.Count() || (..Errors.HighestError'="Error") { 
			Set tSC = ..SendRequestSync(..RegistryOperations, tRegistration, .pResponse) 
			If $$$ISERR(tSC) { Do ..Errors.logError("XDSRegistryNotAvailable","Error","") Quit }
			// log ATNA export event
			Do $$$ATNAEvent("XDSbRepository",tRegistration,pResponse,tSC)
			#; Check for invalid response
			If '$IsObject(pResponse) || ($IsObject(pResponse) && (pResponse.ContentStream.Size = 0 )) { Do ..Errors.logError("XDSRegistryNotAvailable","Error","") Quit }
			Set tRegistryResponse=pResponse.ContentStream
			#; Check for registry error
			Set tSC = ##class(%XML.XPATH.Document).CreateFromStream(pResponse.ContentStream, .tDocument, , , , , "xdsb urn:oasis:names:tc:ebxml-regrep:xsd:rs:3.0") $$$ThrowOnError(tSC)
			Set tSC = tDocument.EvaluateExpression("/xdsb:RegistryResponse", "@status", .tResults) $$$ThrowOnError(tSC)
			If 'tResults.Count() {
				Set tSC = $$$ERROR($$$GeneralError, "Unable to locate status in registry response")
			} Else {
				Set tRegistryStatus = $Piece(tResults.GetAt(1).Value, ":", $Length(tResults.GetAt(1).Value, ":"))

				$$$HSTRACE("Registry Status","Status",tRegistryStatus)
				If ($ZConvert(tRegistryStatus, "U") '= "SUCCESS") {
					; document structure based on CSP/xslt/IHE/XDSb/Version1/RegistryAddResponse.xsl
					set tSC = tDocument.EvaluateExpression("/xdsb:RegistryResponse/xdsb:RegistryErrorList/xdsb:RegistryError", "@codeContext", .tResults)
					Do:(tResults.Size=0) ..Errors.logError("XDSbRepository","Error","Registry error response") ; log something even if we can't pull an error message out
					set tI=""
					for{
						set tError = tResults.GetNext(.tI)
						quit:((tI="")||(tError=""))
						set tErrorMsg = tError.Value
						Do ..Errors.logError("XDSbRepository","Error","Registry error response: "_tErrorMsg)
					}
				}
			}	
			#; Post process documents
			#; Intentionally does not propegate error up through tSC
			If $$$ISOK(tSC) && ($ZConvert(tRegistryStatus, "U") = "SUCCESS") {
				Set tPostProcessStatus=..ExecuteProvidePostProcessor(pRequest,.tDocumentArray)
				If $$$ISERR(tPostProcessStatus) $$$LOGSTATUS(tPostProcessStatus)
			}

		}
	
	}
	Catch eException {
		Set tSC = eException.AsStatus()
		Do ..Errors.logError("XDSbRepository","Error","Internal error "_$system.Status.GetErrorText(tSC)) 
	}
	
	if ..Errors.Errors.Count() && (..Errors.HighestError="Error") {
		try {
			#; Rollback submitted entries to repository due to error
			If tStoredDocument {
				Set tSCRB = ..RollbackProvideAndRegisterDocumentSetb(.tDocumentArray, pRequest) $$$ThrowOnError(tSCRB)
			}
			Set pResponse = ##class(HS.Message.XMLMessage).%New()
			Set pResponse.Name = $$$XDSbRegisterResponse

			If $IsObject($g(tRegistryResponse)) {
				#; if the registry gave us a response use that
				Set tResponse = tRegistryResponse
			} Else {
				#; produce some sort of error message if we have a hard error, otherwise return what came from registry
				Set tXSLArguments("status")	= "Failure"
				Set tStream = ##class(%Stream.GlobalCharacter).%New()
				Do ..Errors.XMLExportToString(.tErrorString)
				Do tStream.Write("<Submission>"_tErrorString_"</Submission>")
				$$$HSTRACE("Response stream","tStream,Status",tStream,tXSLArguments("status"))
				Do tStream.Rewind()
			
				$$$HSTRACESTARTCALL
				Set tSC = ..Transformer.Transform(tStream, ..RegisterResponseTransform /*"IHE/XDSb/Version1/RegisterResponse.xsl"*/, .tResponse, .tXSLArguments)
				$$$HSTRACEENDCALL
				If $$$ISERR(tSC) $$$LOGSTATUS(tSC)
			}
			If $IsObject(tResponse) {
				Do tResponse.Rewind(), pResponse.ContentStream.CopyFrom(tResponse)
			}
			If $$$ISERR(tSC) $$$LOGSTATUS(tSC)
			Set tSC=$$$OK
		} Catch eException {
			Set tSC = eException.AsStatus()
		}	
	}
	/// unlock for single patient processing
	If $G(tLockPatientID)]"" {
		Lock -^HS.Repository.Document.Patient(tLockPatientID)
	}
	/// used for debugging simultaneous transactions
	If ..TraceOperations=100 Lock -^HS.Repository.Document.Testing
	Quit tSC
}

/// Move any inline documents to attachments and build DocumentArray 
Method BuildAttachments(pRequest As HS.Message.XMLMessage, pDocument, Output pDocumentArray) As %Status
{
	try {
		Set tSC=$$$OK
		#; Pre-process inline, non-MTOM documents
		Set tXPathRoot = "/xdsb:ProvideAndRegisterDocumentSetRequest/xdsb:Document"
		If 'pRequest.StreamCollection.Count() {
			#; Get inline documents
			Set tSC = pDocument.EvaluateExpression(tXPathRoot, "text()", .tInlineDocuments) $$$ThrowOnError(tSC)
			$$$HSTRACE("Inline Document Count","Count",tInlineDocuments.Count())
			For tDocumentIndex = 1:1:tInlineDocuments.Count() {
				Set tStream = ##class(%Stream.GlobalBinary).%New()
				Set tInlineDocument = tInlineDocuments.GetAt(tDocumentIndex).Value
				Set tSC = ##class(HS.Util.StreamUtils).Base64Decode(tInlineDocument,.tStream)
				If $$$ISERR(tSC) {
					Do ..Errors.logError("XDSRepository","Error","Unable to base 64 decode document "_tInlineDocument) Quit
				}

				Set tReference = ##class(%SYSTEM.Util).CreateGUID()

				Set tCollectionObject = ##class(HS.IHE.Common.Messages.MIMEAttachment).%New()
				Set tCollectionObject.Body = tStream
				Set tCollectionObject.ContentId = tReference

				
				Set tObject = tXPathRoot _ "[" _ tDocumentIndex _ "]"
				Set tSC = pDocument.EvaluateExpression(tObject, "@id", .tResults) $$$ThrowOnError(tSC)
				Throw:(tResults.Count()=0) ##class(%Exception.StatusException).CreateFromStatus($$$ERROR($$$GeneralError,"Missing document identifier: "_tXPathRoot_"[@id]"))
				Kill tDocId
				Set tDocId = tResults.GetAt(1).Value
				If tDocId = "" {
					Do ..Errors.logError("XDSRepository","Error","Document @id at "_tDocumentIndex_" is empty")
					continue
				}
				If '$D(pDocumentArray(tDocId)) {
					Do ..Errors.logError("XDSRepository","Error","Document id "_tDocId_" does not have inline document")
					continue
				}
				Set pDocumentArray = tDocumentIndex
				Set pDocumentArray(tDocId, "Reference") = tReference
				Set pDocumentArray("Reference", tReference) = tDocId
				If $zstrip(pDocumentArray(tDocId, "patientGlobalID"),"*WC")'=pDocumentArray(tDocId, "patientGlobalID") Do ..Errors.logError("XDSRepository","Error","Patient Identifier contains invalid characters:"_tDocId)
				
				Do pRequest.StreamCollection.Insert(tCollectionObject)
			}
			#; check to make sure that there are no missing attachments (if we find any there is a problem because there are no attachments)
			Set tSC = pDocument.EvaluateExpression("/xdsb:ProvideAndRegisterDocumentSetRequest/xdsb:Document/xop:Include", "@href", .tDocumentReferences) $$$ThrowOnError(tSC)
			For tDocumentIndex = 1:1:tDocumentReferences.Count() {
				Set tReference = tDocumentReferences.GetAt(tDocumentIndex).Value
				Do ..Errors.logError("XDSbRepository","Error","Content id:"_tDocumentReferences.GetAt(tDocumentIndex).Value_" referenced but not found")
			}

			
		}
		#; Instead pre-process documents attached with MTOM
		Else {
			#; track all content id's in tStreamIndex to ensure they exist when getting the xop references
			For tStreamIndex = 1:1:pRequest.StreamCollection.Count() {
				Set tDocumentStream = pRequest.StreamCollection.GetAt(tStreamIndex)
				Set tDocumentStream.ContentId=$zcvt(tDocumentStream.ContentId,"I","URL")
				Set tStreamIndex(tDocumentStream.ContentId)=""
			}
			
			Set tSC = pDocument.EvaluateExpression(tXPathRoot_"/xop:Include" /*"/xdsb:ProvideAndRegisterDocumentSetRequest/xdsb:Document/xop:Include"*/, "@href", .tDocumentReferences) $$$ThrowOnError(tSC)
		
			For tDocumentIndex = 1:1:tDocumentReferences.Count() {
				Set tReference = tDocumentReferences.GetAt(tDocumentIndex).Value
				If $ZConvert($Extract(tReference, 1, 4), "l") = "cid:" {
					Set tReference = $ZConvert($Extract(tReference, 5, *), "I", "URL")
					$$$HSTRACE("Adding doc to array "_tReference)
				}
				Else {
					Do ..Errors.logError("XDSbRepository","Warning","Document reference does not start with cid:  " _ tReference)
					$$$LOGWARNING("Document reference does not start with cid:  " _ tReference)
				}
				If '$d(tStreamIndex(tReference)) {
					Do ..Errors.logError("XDSbRepository","Error","Content id:"_tReference_" referenced but not found")
					Continue
				}

				Set tObject = tXPathRoot _ "[" _ tDocumentIndex _ "]"
				Set tSC = pDocument.EvaluateExpression(tObject, "@id", .tResults) $$$ThrowOnError(tSC)
				Throw:(tResults.Count()=0) ##class(%Exception.StatusException).CreateFromStatus($$$ERROR($$$GeneralError,"Missing document identifier: "_tXPathRoot_"[@id]"))
				Kill tDocId
				Set tDocId = tResults.GetAt(1).Value

				Set pDocumentArray = tDocumentIndex
				Set pDocumentArray(tDocId, "Reference") = tReference
				Set pDocumentArray("Reference", tReference) = tDocId
			}
		}
		Set tSC = pDocument.EvaluateExpression("/xdsb:ProvideAndRegisterDocumentSetRequest/lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:ExtrinsicObject", "@id", .tDocumentList) $$$ThrowOnError(tSC)
		If tDocumentList.Count()>pRequest.StreamCollection.Count() {
			Do ..Errors.logError("XDSMissingDocument","Error","Expected "_tDocumentList.Count()_" but found "_pRequest.StreamCollection.Count()_" document(s)")
		} ElseIf tDocumentList.Count()'=pRequest.StreamCollection.Count() {
			Do ..Errors.logError("XDSMissingDocumentMetadata","Error","Expected "_tDocumentList.Count()_" but found "_pRequest.StreamCollection.Count()_" document(s)")
		}
	} catch eException {
		Set tSC = eException.AsStatus()
		Do ..Errors.logError("XDSbRepository","InternalError",$system.Status.GetErrorText(tSC))
	}
	Quit tSC
}

Method RetrieveDocumentSet(pRequest As HS.Message.XMLMessage, pResponse As HS.Message.XMLMessage) As %Status
{
	#dim eException As %Exception.AbstractException

	Set tSC = $$$OK

	Try {
		Set tSC = ..SendRequestSync(..RepositoryOperations, pRequest, .pResponse) 
		
		//%HS_NotifyAndQueryOperations is only used for an internal message - no consent
		If ..XDSbRetrieveConsentTarget ] "", pRequest.SAMLData.HSRoles'="%HS_NotifyAndQueryOperations" {
			Set pResponse.AdditionalInfo = pRequest.AdditionalInfo
			Set pResponse.SAMLData = pRequest.SAMLData.%ConstructClone()
			Set tSC = ..SendRequestSync(..XDSbRetrieveConsentTarget, pResponse, .tConsentedResponse) $$$ThrowOnError(tSC)
			SEt pResponse = tConsentedResponse
		}
	}
	Catch eException {
		Set tSC = eException.AsStatus()

		Do ..Errors.logError("XDSbRepository","Error","Internal Error:"_eException.DisplayString()) 
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

Method ParseRegistrationHeader(pDocument As %XML.XPATH.Document, ByRef pResults As %String) As %Status
{
	#dim eException As %Exception.AbstractException

	Try {
		Set tSC = $$$OK
		
		Kill pResults
		
		Set tXPathRoot = "/xdsb:ProvideAndRegisterDocumentSetRequest/lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:ExtrinsicObject"
		
		#; Iterate over document collection
		Set tSC = pDocument.EvaluateExpression(tXPathRoot, "name()", .tDocumentList) $$$ThrowOnError(tSC)
		For tDocumentIndex = 1:1:tDocumentList.Count() {
			Set tObject = tXPathRoot _ "[" _ tDocumentIndex _ "]"
			Set tSC = pDocument.EvaluateExpression(tObject, "@id", .tResults) $$$ThrowOnError(tSC)
			Throw:(tResults.Count()=0) ##class(%Exception.StatusException).CreateFromStatus($$$ERROR($$$GeneralError,"Missing document identifier: "_tXPathRoot_"[@id]"))
			Kill tDocId
			Set tDocId = tResults.GetAt(1).Value
						
			#; Get document ID
			Set tSC = pDocument.EvaluateExpression(tObject _ "/rim:ExternalIdentifier[@identificationScheme='urn:uuid:2e82c1f6-a085-4c72-9da3-8640a32e42ab']", "@value", .tResults) $$$ThrowOnError(tSC)
			Set (pResults(tDocId, "documentID"),tUniqueId) = $Case(tResults.Count(), 0:"", :tResults.GetAt(1).Value)
			If tUniqueId="" Do ..Errors.logError("XDSRegistryMetadataError","Error","UniqueId.id required for ExtrinsicObject["_tDocumentIndex_"]",tObject)

			#; Get document name
			Set tSC = pDocument.EvaluateExpression(tObject _ "/rim:Name/rim:LocalizedString", "@value", .tResults) $$$ThrowOnError(tSC)
			Set pResults(tDocId, "documentName") = $Case(tResults.Count(), 0:"", :tResults.GetAt(1).Value)

			#; Get document Description
			Set tSC = pDocument.EvaluateExpression(tObject _ "/rim:Description/rim:LocalizedString", "@value", .tResults) $$$ThrowOnError(tSC)
			Set pResults(tDocId, "documentDescription") = $Case(tResults.Count(), 0:"", :tResults.GetAt(1).Value)

			#; Get document mime type
			Set tSC = pDocument.EvaluateExpression(tObject, "@mimeType", .tResults) $$$ThrowOnError(tSC)
			Set pResults(tDocId, "documentContentType") = $Case(tResults.Count(), 0:"", :tResults.GetAt(1).Value)

			#; Get document format code
			Set tSC = pDocument.EvaluateExpression(tObject _ "/rim:Classification[@classificationScheme='urn:uuid:a09d5840-386c-46f2-b5ad-9c3699a4309d']", "@nodeRepresentation", .tResults) $$$ThrowOnError(tSC)
			Set pResults(tDocId, "documentFormatCode") = $Case(tResults.Count(), 0:"", :tResults.GetAt(1).Value)

			#; Get document format scheme
			Set tSC = pDocument.EvaluateExpression(tObject _ "/rim:Classification[@classificationScheme='urn:uuid:a09d5840-386c-46f2-b5ad-9c3699a4309d']/rim:Slot/rim:ValueList/rim:Value", "text()", .tResults) $$$ThrowOnError(tSC)
			Set pResults(tDocId, "documentFormatScheme") = $Case(tResults.Count(), 0:"", :tResults.GetAt(1).Value)

			#; Get document creation time
			Set tSC = pDocument.EvaluateExpression(tObject _ "/rim:Slot[@name='creationTime']/rim:ValueList/rim:Value", "text()", .tResults) $$$ThrowOnError(tSC)
			Set pResults(tDocId, "documentCreationTime") = $Case(tResults.Count(), 0:"", :##class(HS.Util.XSLTHelper).xmltimestamp(tResults.GetAt(1).Value))

			#; Get service start time
			Set tSC = pDocument.EvaluateExpression(tObject _ "/rim:Slot[@name='serviceStartTime']/rim:ValueList/rim:Value", "text()", .tResults) $$$ThrowOnError(tSC)
			Set pResults(tDocId, "serviceStartTime") = $Case(tResults.Count(), 0:"", :##class(HS.Util.XSLTHelper).xmltimestamp(tResults.GetAt(1).Value))

			#; Get service stop time
			Set tSC = pDocument.EvaluateExpression(tObject _ "/rim:Slot[@name='serviceStopTime']/rim:ValueList/rim:Value", "text()", .tResults) $$$ThrowOnError(tSC)
			Set pResults(tDocId, "serviceStopTime") = $Case(tResults.Count(), 0:"", :##class(HS.Util.XSLTHelper).xmltimestamp(tResults.GetAt(1).Value))

			#; Get global patient identifier
			Set tSC = pDocument.EvaluateExpression(tObject _ "/rim:ExternalIdentifier[@identificationScheme='urn:uuid:58a6f841-87b3-4a3e-92fd-a8ffeff98427']", "@value", .tResults) $$$ThrowOnError(tSC)
			Set pResults(tDocId, "patientGlobalID") = $Case(tResults.Count(), 0:"", :$Piece(tResults.GetAt(1).Value, "^", 1))
			Set pResults(tDocId, "patientGlobalAssigningAuthority") = $Case(tResults.Count(), 0:"", :$Piece($Piece(tResults.GetAt(1).Value, "&", 2), "&", 1))
			//Set pResults(tDocId, "patientGlobalAssigningAuthorityOID") = $Case(tResults.Count(), 0:"", :$Piece($Piece(tResults.GetAt(1).Value, "&", 2), "&", 1))
			//Set pResults(tDocId, "patientGlobalAssigningAuthority") = ##class(HS.Data.OIDMap).GetCodeForOID(pResults(tDocumentIndex, "patientGlobalAssigningAuthorityOID"))

			#; Get local patient identifier
			Set tSC = pDocument.EvaluateExpression(tObject _ "/rim:Slot[@name='sourcePatientId']/rim:ValueList/rim:Value", "text()", .tResults) $$$ThrowOnError(tSC)
			Set pResults(tDocId, "patientSourceID") = $Case(tResults.Count(), 0:"", :$Piece(tResults.GetAt(1).Value, "^", 1))
			Set pResults(tDocId, "patientSourceAssigningAuthority") = $Case(tResults.Count(), 0:"", :$Piece($Piece(tResults.GetAt(1).Value, "&", 2), "&", 1))

			#; Get local patient name
			Set tSC = pDocument.EvaluateExpression(tObject _ "/rim:Slot[@name='sourcePatientInfo']/rim:ValueList/rim:Value[contains(text(), 'PID-5')]", "text()", .tResults) $$$ThrowOnError(tSC)
			Set pResults(tDocId, "patientSourceFirstName") = $Case(tResults.Count(), 0:"", :$Piece($Piece(tResults.GetAt(1).Value, "^", 2), "^", 1))
			Set pResults(tDocId, "patientSourceLastName") = $Case(tResults.Count(), 0:"", :$Piece($Piece(tResults.GetAt(1).Value, "|", 2), "^", 1))

			#; Get local patient DOB
			Set tSC = pDocument.EvaluateExpression(tObject _ "/rim:Slot[@name='sourcePatientInfo']/rim:ValueList/rim:Value[contains(text(), 'PID-7')]", "text()", .tResults) $$$ThrowOnError(tSC)
			Set pResults(tDocId, "patientSourceDOB") = $Case(tResults.Count(), 0:"", :##class(HS.Util.XSLTHelper).xmltimestamp($Piece(tResults.GetAt(1).Value, "|", 2)))

			#; Get local patient sex
			Set tSC = pDocument.EvaluateExpression(tObject _ "/rim:Slot[@name='sourcePatientInfo']/rim:ValueList/rim:Value[contains(text(), 'PID-8')]", "text()", .tResults) $$$ThrowOnError(tSC)
			Set pResults(tDocId, "patientSourceSex") = $Case(tResults.Count(), 0:"", :$Piece(tResults.GetAt(1).Value, "|", 2))

			#; Get local patient address
			Set tSC = pDocument.EvaluateExpression(tObject _ "/rim:Slot[@name='sourcePatientInfo']/rim:ValueList/rim:Value[contains(text(), 'PID-11')]", "text()", .tResults) $$$ThrowOnError(tSC)
			Set pResults(tDocId, "patientSourceAddressStreetLine1") = $Case(tResults.Count(), 0:"", :$Piece($Piece(tResults.GetAt(1).Value, "|", 2), "^", 1))
			Set pResults(tDocId, "patientSourceAddressStreetLine2") = $Case(tResults.Count(), 0:"", :$Piece($Piece(tResults.GetAt(1).Value, "^", 2), "^", 1))
			Set pResults(tDocId, "patientSourceAddressCity") = $Case(tResults.Count(), 0:"", :$Piece($Piece(tResults.GetAt(1).Value, "^", 3), "^", 1))
			Set pResults(tDocId, "patientSourceAddressState") = $Case(tResults.Count(), 0:"", :$Piece($Piece(tResults.GetAt(1).Value, "^", 4), "^", 1))
			Set pResults(tDocId, "patientSourceAddressZip") = $Case(tResults.Count(), 0:"", :$Piece($Piece(tResults.GetAt(1).Value, "^", 5), "^", 1))
			Set pResults(tDocId, "patientSourceAddressCountry") = $Case(tResults.Count(), 0:"", :$Piece($Piece(tResults.GetAt(1).Value, "^", 6), "^", 1))

			#; Get document format code and scheme
			Set tSC = pDocument.EvaluateExpression(tObject _ "/rim:Classification[@classificationScheme='urn:uuid:a09d5840-386c-46f2-b5ad-9c3699a4309d']", "@nodeRepresentation", .tResults) $$$ThrowOnError(tSC)
			Set pResults(tDocId, "documentFormatCode") = $Case(tResults.Count(), 0:"", :tResults.GetAt(1).Value)
			Set tSC = pDocument.EvaluateExpression(tObject _ "/rim:Classification[@classificationScheme='urn:uuid:a09d5840-386c-46f2-b5ad-9c3699a4309d']/rim:Slot[@name='codingScheme']/rim:ValueList/rim:Value", "text()", .tResults) $$$ThrowOnError(tSC)
			Set pResults(tDocId, "documentFormatScheme") = $Case(tResults.Count(), 0:"", :tResults.GetAt(1).Value)

			Set tSC = pDocument.EvaluateExpression(tObject _ "/rim:Slot[@name='size']/rim:ValueList/rim:Value", "text()", .tResults) $$$ThrowOnError(tSC)
			Set pResults(tDocId, "size") = $Case(tResults.Count(), 0:"", :tResults.GetAt(1).Value)
			Set tSC = pDocument.EvaluateExpression(tObject _ "/rim:Slot[@name='hash']/rim:ValueList/rim:Value", "text()", .tResults) $$$ThrowOnError(tSC)
			Set pResults(tDocId, "hash") = $Case(tResults.Count(), 0:"", :tResults.GetAt(1).Value)
		}
	}
	Catch eException {
		Set tSC = eException.AsStatus()
		$$$LOGSTATUS(tSC)
	}	

	Quit tSC
}

Method RollbackProvideAndRegisterDocumentSetb(ByRef pDocumentArray As %String = "", pRequest As HS.Message.XMLMessage) As %Status
{
	#dim eException As %Exception.AbstractException

	Try {
		Set tSC = $$$OK
		
		If ($O(pDocumentArray("Reference",""))="") Quit

		#; Create rollback request
		Set tRollbackRequest = ##class(HS.Message.XMLMessage).%New()
		Set tRollbackRequest.Name = "XDSb_RollbackRequest"
		Set tRollbackRequest.AdditionalInfo = pRequest.AdditionalInfo.%ConstructClone()  ///SAML/User Auth
		Set tRollbackRequest.SAMLData = pRequest.SAMLData.%ConstructClone()  ///SAML/User Auth
		
		#; put the document list into a message to be deleted
		Set tReference = ""
		Set tCount = 0
		For{
			Set tReference = $O(pDocumentArray("Reference",tReference),1,tDocumentIndex )
			Quit:tReference=""
			Set tDocumentID=$g(pDocumentArray(tDocumentIndex, "repositoryDocumentID"))
			If $G(pDocumentArray(tDocumentIndex,"ExistingDocument")) Continue // Skip rollback for existing documents
			If tDocumentID ="" Continue  /// document must not have been filed - an error must have occurred
			Do tRollbackRequest.AdditionalInfo.SetAt(tDocumentID, "repositoryDocumentID:" _ tDocumentID)
			Set tCount = tCount + 1
		}
		If tCount {
			/// if there was a single document or all documents failed to store, or an existing document, then no sense issuing the rollback, there is nothing in the message
			Set tSC = ..SendRequestSync(..RepositoryOperations, tRollbackRequest, .tRollbackResponse)
		} Else {
			$$$HSTRACEMIN("Nothing to rollback")
		}

	}
	Catch eException {
		Set tSC = eException.AsStatus()
		$$$LOGSTATUS(tSC)		
	}	

	Quit tSC
}

/// Returns array(code^^scheme)=host from given string: code^^scheme^^host||code^^scheme^^host...
Method ParseProcessor(pValues As %String) As %ArrayOfDataTypes
{
	Set tMap = ##class(%ArrayOfDataTypes).%New()
	Try {
		#; Get the production config for validing hosts
		#; Skip host validation if there is an error looking up the production
		Do ##class(Ens.Director).ParseConfigItemName("",.tProductionName)
		If tProductionName {
			Set tProduction=##class(Ens.Config.Production).%OpenId(tProductionName,0,.tSC)  
			If $$$ISERR(tSC) $$$LOGSTATUS(tSC) Kill tProduction
			If '$IsObject(tProduction) $$$LOGERROR("Unable to access production settings") Kill tProduction
		}
		
		For i=1:1:$L(pValues,"||") {
			#; Get the item
			Set tItem=$P(pValues,"||",i)
			Set tCode=$P(tItem,"^^",1)
			Set tScheme=$P(tItem,"^^",2)
			Set tHost=$P(tItem,"^^",3)
			
			#; Validate formatCode
			If '##class(HS.IHE.CodedEntry).UniqueIndexExists("formatCode",tScheme,tCode) {
				$$$LOGWARNING("Format code not found, skipping this processor: "_tItem)
				Continue
			}
			
			#; Validate target host
			If $G(tProduction),tProduction.FindItemByConfigName(tHost)=$$$NULLOREF {
				$$$LOGWARNING("Host not found, skipping this processor: "_tItem)
				Continue
			}

			#; Add to array
			Do tMap.SetAt(tHost,tCode_"^^"_tScheme)
		}
	} Catch ex {
		$$$LOGSTATUS(ex.AsStatus())
	}
	Quit tMap
}

/// Execute post-processing on a document set submission
Method ExecuteProvidePostProcessor(pRequest As HS.Message.XMLMessage, ByRef pDocArray As %String) As %Status
{
	Set tSC=$$$OK
	Try {
		If ..ProvidePostProcessor="" Quit
					
		For tStreamIndex = 1:1:pRequest.StreamCollection.Count() {
			#; Skip unreferenced documents			
			Set tAttachment = pRequest.StreamCollection.GetAt(tStreamIndex)
			Continue:tAttachment.ContentId=""
			Set tAttachment.ContentId=$zcvt(tAttachment.ContentId,"I","URL")
			$$$HSTRACE("Have attachment")
			Set tDocIndex=$G(pDocArray("Reference",tAttachment.ContentId))
			Continue:tDocIndex=""
			$$$HSTRACE("Have reference")

			#; Skip if not configured for processing
			Set tCode=$G(pDocArray(tDocIndex,"documentFormatCode"))
			Set tScheme=$G(pDocArray(tDocIndex,"documentFormatScheme"))
			Set tKey=tCode_"^^"_tScheme
			Set tHost=$ZSTRIP($P($P(..ProvidePostProcessor,tKey,2),"||",1),"<>W","^")
			$$$HSTRACE(tCode_tScheme_tHost)
			Continue:tHost=""
						
			#; Create a generic message
			Set tRequest=##class(HS.Message.XMLMessage).%New()
			Set tRequest.Name="Document"
			Set tRequest.DocType=tCode_"^^"_tScheme
			Set tRequest.AdditionalInfo = pRequest.AdditionalInfo.%ConstructClone()  ///SAML/User Auth
			Set tRequest.SAMLData = pRequest.SAMLData.%ConstructClone()  ///SAML/User Auth
			
			#; Copy attributes into additional items
			Set tProp="" For { Set tProp=$O(pDocArray(tDocIndex,tProp),1,tValue) Quit:tProp=""
				Continue:tProp="Reference"
				Do tRequest.AdditionalInfo.SetAt(tValue,tProp)
			}
				
			#; Copy document into content and ship it
			Do tRequest.ContentStream.CopyFrom(tAttachment.Body)
			Do tRequest.ContentStream.Rewind()
			Set tSC=..SendRequestAsync(tHost,tRequest,0) $$$ThrowOnError(tSC)
		}
	} Catch ex { Set tSC=ex.AsStatus() }
	Quit tSC
}

/// take external IHE message and turn it into internal DeleteDocumentSetRequest 
Method RemoveDocuments(pRequest As HS.Message.XMLMessage, pResponse As HS.Message.XMLMessage) As %Status
{
	Set tSC = $$$OK
	Try {
		/// if we are on a bus, we'll want to forward this message
		If ..RepositoryOID="" {
			Set tSC = ##class(HS.IHE.Util).GetXPathValue(pRequest.ContentStream,"/rmd:RemoveDocumentsRequest/xdsb:DocumentRequest/xdsb:RepositoryUniqueId","text()",.tRepositoryId)
			Set tService = ##class(HS.Registry.Service.Abstract).EndPointForOID(tRepositoryId,"Repository","RMD")
			If $IsObject(tService) {
				Do pRequest.AdditionalInfo.SetAt(tService.Name,"ServiceName")
				Set tSC = ..SendRequestSync(..RepositoryOperations,pRequest,.pResponse) $$$ThrowOnError(tSC)
				Quit
			} 
			Do ..Errors.logError("XDSUnknownRepositoryId","Error","Repository OID does not match this repository ["_tIdx_"] "_tRepositoryId)
			Quit
		}
		Set pResponse = ##class(HS.Message.XMLMessage).%New()
		Set pResponse.Name = $$$RMDResponse
		Set tSC = ..Transformer.TransformIntoObject(pRequest.ContentStream,..RemoveDocumentsTransform,.tRequest,,"HS.Message.IHE.XDSb.DeleteDocumentSetRequest","DeleteDocumentSetRequest")
		If $$$ISERR(tSC) {
			Do ..Errors.logError("XDSbRepository","Error","Failed to transform message "_$system.Status.GetErrorText(tSC))
			Quit
		}
		Set tRequest.AdditionalInfo = pRequest.AdditionalInfo.%ConstructClone()  ///SAML/User Auth
		If 'pRequest.AdditionalInfo.IsDefined("SOAPAction") {Do pResponse.AdditionalInfo.SetAt($$$RMDAction(1),"SOAPAction")}
		If 'pRequest.AdditionalInfo.IsDefined("WSA:From") {Do pResponse.AdditionalInfo.SetAt("http://"_$$$HSNetworkHostName_"/Internal","WSA:From")}
		If 'pRequest.AdditionalInfo.IsDefined("WSA:To") {Do pResponse.AdditionalInfo.SetAt("http://"_$$$HSNetworkHostName_"/Internal","WSA:To")}
		Set tSC = ..DeleteDocuments(tRequest,.tResponse)
		If $$$ISERR(tSC) {
			Do ..Errors.logError("XDSbRepository","Error","Failed to transform message "_$system.Status.GetErrorText(tSC))
			Quit
		}
		If $$$ISERR(tResponse.ErrStatus) {
			Do ..Errors.logError("XDSbRepository","Error",$system.Status.GetErrorText(tResponse.ErrStatus))
		}
		If tResponse.ContentStream.Size {
			Set pResponse.ContentStream=tResponse.ContentStream
		}

	}
    Catch ex { 
		Set tSC = ex.AsStatus() 
		Do ..Errors.logError("Internal Error","Error",$system.Status.GetErrorText(tSC))
	}
	If $$$ISERR(tSC) {
		If 'pResponse.ContentStream.Size {
			Do ..BuildResponse(pResponse,"Failure",.tStream)
			Set pResponse.ContentStream=tStream
		}
	}
	Quit tSC
}

Method DeleteDocuments(pRequest As HS.Message.IHE.XDSb.DeleteDocumentSetRequest, pResponse As HS.Message.IHE.XDSb.DeleteDocumentSetResponse) As %Status
{
	Set tSC = $$$OK
	Try {
		Set tSC = pRequest.NewResponse(.pResponse)
		Quit:$$$ISERR(tSC)
		Set pRequest.Name = $$$RMDRequest
		Set tSC = ..SendRequestSync(..RepositoryOperations,pRequest,.pResponse)
		If $$$ISERR(tSC) {
			Do ..Errors.logError("XDSbRepository","Error","Unexpected failure processing message "_$system.Status.GetErrorText(tSC))
			Quit
		}
		If pResponse.ErrStatus'=$$$OK {
			Do pResponse.Errors.logError("XDSbRepository","Error",$system.Status.GetErrorText(pResponse.ErrStatus))
		}
	}
    Catch ex { 
		Set tSC = ex.AsStatus() 
		Do ..Errors.logError("Internal Error","Error",$system.Status.GetErrorText(tSC))
	}
	$$$HSTRACE("Status","tSC,pRequest,pResponse",tSC,$g(pRequest),$g(pResponse))
	Do ..BuildResponse(pResponse,pResponse.Status,.tStream)
	Set pResponse.ContentStream=tStream
	Do $$$ATNAEvent("XDSbRepository",pRequest,pResponse,tSC)
	Quit tSC
}

Method BuildResponse(pResponse As HS.Message.XMLMessage, pStatusString, ByRef pStream) As %Status
{
	Set tXSLArguments("status")=pStatusString
	For tIdx = 1:1:..Errors.Errors.Count() {
		Set tError = ..Errors.Errors.GetAt(tIdx)
		Do pResponse.Errors.Errors.Insert(tError)
	}
	/// ensure highest error level is set
	For tIdx = 1:1:pResponse.Errors.Errors.Count() {
		Do pResponse.Errors.setHighest(pResponse.Errors.Errors.GetAt(tIdx))
	}
	Do pResponse.XMLExportToStream(.tStream)
	
	Quit ..Transformer.Transform(tStream,..RegisterResponseTransform,.pStream,.tXSLArguments)
}

ClassMethod OnGetConnections(Output pArray As %String, item As Ens.Config.Item)
{
	Do ##super(.pArray,item)
	#; Parse the post-processor value
	Set tValue=""
	Set tFound=item.GetModifiedSetting("ProvidePostProcessor",.tValue)
	If 'tFound Set tValue=$$$comMemberKeyGet("HS.IHE.XDSb.Repository.Process",$$$cCLASSproperty,"ProvidePostProcessor",$$$cPROPinitialexpression)
	If tValue]"" {
		For i=1:1:$l(tValue,"||") {
			Set tHost=$ZSTRIP($P($P(tValue,"||",i),"^^",3),"<>W")
			If tHost]"" Set pArray(tHost)=""
		}
	}
}

Method PrepareAndSendAsync(pRequest As HS.Message.XMLMessage, ByRef pResponse As HS.Message.XMLMessage, Output pWebServiceResponse) As %Status
{
	Set tSC=$$$OK
	Try{
		If '$IsObject($G(pResponse)) $$$ThrowStatus($$$ERROR($$$GeneralError,"XDSb repository did not return a response"))
		Set tReplyTo = pRequest.AdditionalInfo.GetAt("ReplyAddress")
		$$$HSTRACE("reply to","tReplyTo",tReplyTo)
		Do pResponse.AdditionalInfo.SetAt(tReplyTo,"ReplyAddress")
		Do pResponse.AdditionalInfo.SetAt(pRequest.AdditionalInfo.GetAt("RelatesTo"),"RelatesTo")
		Set tSC = ..SendRequestSync(..RepositoryOperations,pResponse)
	}
	Catch ex{
		Set tSC = ex.AsStatus
	}
	Quit tSC
}

Storage Default
{
<Data name="ProcessDefaultData">
<Subscript>"Process"</Subscript>
<Value name="1">
<Value>MPIOperations</Value>
</Value>
<Value name="2">
<Value>TraceOperations</Value>
</Value>
<Value name="3">
<Value>IHEVersion</Value>
</Value>
<Value name="4">
<Value>IHEExtension</Value>
</Value>
<Value name="5">
<Value>Transformer</Value>
</Value>
<Value name="6">
<Value>ECRTarget</Value>
</Value>
<Value name="7">
<Value>RegistryOperations</Value>
</Value>
<Value name="8">
<Value>XSLForCreatingSDA</Value>
</Value>
<Value name="9">
<Value>RepositoryOID</Value>
</Value>
<Value name="10">
<Value>RepositoryOperations</Value>
</Value>
<Value name="11">
<Value>ProvidePreProcessor</Value>
</Value>
<Value name="12">
<Value>ProvidePostProcessor</Value>
</Value>
<Value name="13">
<Value>XDSbRetrieveConsentTarget</Value>
</Value>
<Value name="14">
<Value>Errors</Value>
</Value>
<Value name="15">
<Value>Pipeline</Value>
</Value>
<Value name="16">
<Value>PipelineMode</Value>
</Value>
<Value name="17">
<Value>PnRPreProcessor</Value>
</Value>
<Value name="18">
<Value>ValidateSizeAndHash</Value>
</Value>
<Value name="19">
<Value>ProvideAndRegisterToRegisterTransform</Value>
</Value>
<Value name="20">
<Value>RegisterResponseTransform</Value>
</Value>
<Value name="21">
<Value>TextToRetrieveDocumentResponseTransform</Value>
</Value>
<Value name="22">
<Value>RemoveDocumentsTarget</Value>
</Value>
<Value name="23">
<Value>RemoveDocumentsTransform</Value>
</Value>
</Data>
<DefaultData>ProcessDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
