Include Ensemble

/// IHE Utility Functions
Class HS.IHE.XDSb.Util [ Abstract ]
{

/// Process a registry response, throwing an error if response is a failure
ClassMethod ProcessResponse(pResponse As HS.Message.XMLMessage) As %Status
{
	Set tSC=$$$OK
	Try {
		If '$IsObject($G(pResponse)) $$$ThrowStatus($$$ERROR($$$GeneralError,"XDSb registry did not return a response"))
		
		#; Check for success
		Set tXPathNamespaces=##class(HS.IHE.Util).XPathNamespaces()
		Set tSC=##class(%XML.XPATH.Document).CreateFromStream(pResponse.ContentStream, .tResponseDocument,,,,,tXPathNamespaces) Quit:$$$ISERR(tSC)
		
		/* Success and PartialSuccess should still log warnings and errors
		#; try various responses...
		Set tSC=tResponseDocument.EvaluateExpression("/query:AdhocQueryResponse", "@status", .tResults) Quit:$$$ISERR(tSC) 
		If tResults.Count()=1,tResults.GetAt(1).Value["Success" Quit
		Set tSC=tResponseDocument.EvaluateExpression("/xdsb:RetrieveDocumentSetResponse/rs:RegistryResponse", "@status", .tResults) Quit:$$$ISERR(tSC) 
		If tResults.Count()=1,tResults.GetAt(1).Value["Success" Quit
		Set tSC=tResponseDocument.EvaluateExpression("/rs:RegistryResponse", "@status", .tResults) Quit:$$$ISERR(tSC) 
		If tResults.Count()=1,tResults.GetAt(1).Value["Success" Quit
		*/
		
		#; On failure log each error/warning to the event log - updated to include rs:RegistryResponse iti-tf 2b 2011-08-19 line 3615 (3.43.5)
		Set tSC=tResponseDocument.EvaluateExpression("//rs:RegistryResponse/rs:RegistryErrorList/rs:RegistryError", ".", .tResults) Quit:$$$ISERR(tSC) 
		Set i="" For { Set tResult=tResults.GetNext(.i) Quit:i=""
			Do tResult.Read()	
			If tResult.HasAttributes {
				Set (tErrorCode,tSeverity,tContext)=""
				Do tResult.MoveToAttributeName("errorCode") Set tErrorCode=tResult.Value
				Do tResult.MoveToAttributeName("severity") Set tSeverity=tResult.Value
				Do tResult.MoveToAttributeName("codeContext") Set tContext=tResult.Value
				Set tErrorMsg=$S(tErrorCode]"":tErrorCode,1:"XDSb")_$S(tContext]"":" - "_tContext,1:"Unknown error context")
				If tSeverity["Warning" {
					$$$LOGWARNING(tErrorMsg)
				} Else {
					$$$LOGERROR(tErrorMsg)
					Set:$$$ISOK(tSC) tSC=$$$ERROR($$$GeneralError,tErrorMsg) // return the first error
				}
			}
		}
	} Catch ex { Set tSC=ex.AsStatus() }
	Quit tSC
}

/// Process a XDSb metadata container, returning an error if response is a failure
/// This is an optimization to ProcessResponse when the caller needs the metadata and to log errors/warnings by skipping the XPath evaluation
ClassMethod ProcessMetadata(pMetadata As HS.IHE.XDSb.Types.Metadata, Output pConsented As %Boolean = 0) As %Status
{
	Set tSC=$$$OK
	Try {
		If '$IsObject($G(pMetadata)) $$$ThrowStatus($$$ERROR($$$GeneralError,"Metadata is null"))

		#dim tError As HS.Types.IHE.Error		
		If $IsObject(pMetadata.Errors) {
			Set i="" For { Set tError = pMetadata.Errors.Errors.GetNext(.i) Quit:i=""
				If tError.Description = "Consent Filter Applied" Set pConsented = 1
				Set tErrorMsg=$S(tError.Code]"":tError.Code,1:"XDSb")_$S(tError.Description]"":" - "_tError.Description,1:"Unknown error context")
				If tError.Severity["Warning" {
					$$$LOGWARNING(tErrorMsg)
				} Else {
					$$$LOGERROR(tErrorMsg)
					Set:$$$ISOK(tSC) tSC=$$$ERROR($$$GeneralError,tErrorMsg) // return the first error
				}
			}
		}
	} Catch ex { 
		Set tSC=ex.AsStatus() 
		$$$LOGSTATUS(tSC)
	}
	Quit tSC
}

/// Create an error response for various XDSb transactions
/// pSC = the error
/// pResponseName = the response name (ie. XDSb_RegistryResponse)
/// pResponse = the resulting XMLMessage
/// pTransformer = if the caller is a transformer, can send this to avoid reloading the XSLT used by this function
ClassMethod ErrorResponse(pSC As %Status, pResponseName As %String, Output pResponse As HS.Message.XMLMessage, pTransformer As HS.Util.XSLTTransformer = "") As %Status
{
	Set tMsg = $SYSTEM.Status.GetErrorText(pSC)
	If tMsg[" [" Set tMsg = $P(tMsg," [",1)
	If tMsg[": " Set tMsg = $P(tMsg,": ",2)
	
	If $IsObject(pTransformer),pTransformer.%Extends("HS.Util.XSLTTransformer") {
		Set tTransformer = pTransformer
	} Else {
		Set tTransformer = ##class(HS.Util.XSLTTransformer).%New()
	}
	
	Set tParams("responseName") = pResponseName
	Set tParams("errorMessage") = tMsg
	Quit tTransformer.TransformIntoObject("<error/>", "IHE/XDSb/Version1/ErrorResponse.xsl", .pResponse, .tParams, "HS.Message.XMLMessage")
}

/// Calculate the hash value for a document
ClassMethod StreamHash(tStream As %Stream.GlobalBinary) As %String
{
	try {
		Set tHashValue = "",tHashStream = ##class(%SYSTEM.Encryption).SHA1HashStream(tStream)
		For tCharacterPosition = 1:1:$Length(tHashStream) {
			Set tCharacter = $Ascii($Extract(tHashStream, tCharacterPosition))
			Set tHashValue = tHashValue _ $Select(tCharacter < 16:"0" _ $ZHex(tCharacter), 1:$ZHex(tCharacter))
		}
		Set tHashValue = $ZConvert(tHashValue, "l")
	} catch ex {
		Set tHashValue=""
	} 
	Quit tHashValue
}

/// Move inline documents to attachments (pInline=0), calculate size and hash
ClassMethod AttachDocuments(pInline = 0, pSource As HS.Message.IHE.XDSb.Metadata, pTarget As HS.Message.XMLMessage) As %Status
{
	try {
		Set tSC=$$$OK
		#; stream might be inline or an attachment already
		For tIdx = 1:1:pSource.StreamCollection.Count() {
			Set tDocID = pSource.StreamCollection.GetAt(tIdx).ContentId
			If tDocID]"" Set tArray(tDocID)=pSource.StreamCollection.GetAt(tIdx)
		}
		For tIdx=1:1:pSource.Documents.Count() {
			Set tDoc = pSource.Documents.GetAt(tIdx)
			If 'pInline {
				Set tAttach = ##class(HS.IHE.Common.Messages.MIMEAttachment).%New()
				Set tContentID= ..XOPToContentID(tDoc.XOP)
				Set:tContentID="" tContentID=tDoc.EntryUUID
				Set tAttach.ContentId=tContentID
				If $D(tArray(tContentID)) {
					Set tAttach = tArray(tContentID)
				} ElseIf tDoc.Body.Size {
					Do tAttach.Body.CopyFrom(tDoc.Body)
					Set tDoc.Body=""
				} Else {
					Do tAttach.Body.CopyFrom(tDoc.BodyCharacter)
					Set tDoc.BodyCharacter=""
				}
				Do pTarget.StreamCollection.Insert(tAttach)

				// enforce that tDoc.XOP has cid: prefix, even if it did not originally.
				Set tDoc.XOP= ..ContentIDToXOP(tContentID)
				Set tDocStream = tAttach.Body
			} Else {
				#; inline documents
				If tDoc.BodyCharacter.Size {
					Do tDoc.Body.CopyFrom(tDoc.BodyCharacter) Set tDoc.BodyCharacter=""
					Set tDocStream = tDoc.Body
				}
			}
			Set tDoc.Size=tDocStream.Size
			Set tDoc.Hash=##class(HS.IHE.XDSb.Util).StreamHash(tDocStream)
		}
	} catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

ClassMethod XOPToContentID(pXOP As %String) As %String
{
	return $S($e(pXOP,1,4)="cid:":$p(pXOP,"cid:",2),1:pXOP)
}

ClassMethod ContentIDToXOP(pClientId As %String) As %String
{
	return "cid:" _ pClientId
}

ClassMethod DeleteAttachments(ByRef pMessage As HS.Message.XMLMessage) As %Status
{
	Set tSC=$$$OK
	Set tIdx=""
	For{
		Set tMIMEAttachment=pMessage.StreamCollection.GetNext(.tIdx)
		Quit:tIdx=""
		Set tStream=tMIMEAttachment.Body
		Set tMIMEAttachment.Body=$$$NULLOREF
		Set tSC = tMIMEAttachment.%Save()
	}
	Quit tSC
}

}
