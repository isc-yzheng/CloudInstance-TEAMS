Include (HS.HC, HS.IHE.XCAI)

Class HS.IHE.XCAI.Common Extends (%RegisteredObject, HS.HC.Util.Trace.Helper) [ Inheritance = right ]
{

Parameter SETTINGS = "HomeCommunity:Dev,XCAIRetrieveRequestImportTransform:Transform,XCAIRetrieveRequestExportTransform:Transform,XCAIRetrieveResponseImportTransform:Transform,XCAIRetrieveResponseExportTransform:Transform,XCAIRetrieveRequestImportTransform:Transform,XCAIRetrieveRequestExportTransform:Transform,XCAIRetrieveResponseImportTransform:Transform,XCAIRetrieveResponseExportTransform:Transform,XDSIRetrieveRequestImportTransform:Transform,XDSIRetrieveRequestExportTransform:Transform,XDSIRetrieveResponseImportTransform:Transform,XDSIRetrieveResponseExportTransform:Transform";

Parameter IHEVersion As COSEXPRESSION = "##class(HS.Registry.Config).GetKeyValue(""\General\IHEVersion"",1)";

/// Temporary storage of the HomeCommunity system setting, By default this uses the configuration registry setting \IHE\HomeCommunity but can be overridden in the dev and debugging section
Property HomeCommunity As %String;

Property HomeCommunityOID As %String(MAXLEN = 64);

Property Transformer As HS.Util.XSLTTransformer;

Property XCAIRetrieveRequestImportTransform As %String(MAXLEN = 250) [ InitialExpression = "IHE/XCAI/Version1/RetrieveRequest-Import.xsl" ];

Property XCAIRetrieveRequestExportTransform As %String(MAXLEN = 250) [ InitialExpression = "IHE/XCAI/Version1/RetrieveRequest-Export.xsl" ];

Property XCAIRetrieveResponseImportTransform As %String(MAXLEN = 250) [ InitialExpression = "IHE/XCAI/Version1/RetrieveResponse-Import.xsl" ];

Property XCAIRetrieveResponseExportTransform As %String(MAXLEN = 250) [ InitialExpression = "IHE/XCAI/Version1/RetrieveResponse-Export.xsl" ];

Property XDSIRetrieveRequestImportTransform As %String(MAXLEN = 250) [ InitialExpression = "IHE/XDSI/Version1/RetrieveRequest-Import.xsl" ];

Property XDSIRetrieveRequestExportTransform As %String(MAXLEN = 250) [ InitialExpression = "IHE/XDSI/Version1/RetrieveRequest-Export.xsl" ];

Property XDSIRetrieveResponseImportTransform As %String(MAXLEN = 250) [ InitialExpression = "IHE/XDSI/Version1/RetrieveResponse-Import.xsl" ];

Property XDSIRetrieveResponseExportTransform As %String(MAXLEN = 250) [ InitialExpression = "IHE/XDSI/Version1/RetrieveResponse-Export.xsl" ];

Property Errors As HS.Types.IHE.Errors;

/// Setup state; should be called before processing most requests
/// 
Method Initialize() As %Status
{
	$$$GetTransformer(..Transformer)
	Set:..HomeCommunity="" ..HomeCommunity = $$$HomeCommunity
	Set ..HomeCommunityOID = $$$HomeCommunityOIDGet(..HomeCommunity)
	Set ..Errors = ##class(HS.Types.IHE.Errors).%New()
	Quit $$$OK
}

Method LogEvents()
{
	#dim tError As HS.Types.IHE.Error
	
	Try {
		Quit:'..Errors.Errors.Count() 
		$$$HSTRACE("Errors", "Errors", ..Errors)
		
		Set tErrorText="", tWarningText=""
		Set i = "" For { Set tError = ..Errors.Errors.GetNext(.i) Quit:i=""
			If tError.Severity="Error" {
				Set tErrorText = tErrorText _ "["_tError.Description_ "]"
			} 
			Else {
				Set tWarningText = tWarningText _ "["_tError.Description_ "]"
			}
		}
		If tErrorText]"" $$$LOGERROR(tErrorText)
		If tWarningText]"" $$$LOGWARNING(tWarningText)
	}
	Catch ex {
		$$$LOGSTATUS(ex.AsStatus())
	}
}

Method Log(pError As HS.Types.IHE.Error)
{
	If pError.Severity="Error" {
		Do ..LogError(pError.Code, pError.Description, pError.Location)
	}
	Else {
		Do ..LogWarning(pError.Code, pError.Description, pError.Location)
	}
}

Method LogStatus(pSC As %Status)
{
	Do ..LogError($$$XCAIError, $system.Status.GetErrorText(pSC))
}

Method LogError(pCode, pDescription, pLocation = {..HomeCommunityOID})
{
	Do ..Errors.logError(pCode, "Error", pDescription, pLocation)
}

Method LogWarning(pCode, pDescription, pLocation = {..HomeCommunityOID})
{
	Do ..Errors.logError(pCode, "Warning", pDescription, pLocation)
}

/// Convert between XMLMessage and internal message objects using XSLT and XML correlation
/// 
Method ConvertMessage(pInput As %XML.Adaptor, pOutput As %XML.Adaptor) As %Status
{
	#dim tRequest  As HS.Message.IHE.XDSI.RetrieveRequest
	#dim tResponse As HS.Message.IHE.XDSI.RetrieveResponse

	Set tSC = $$$OK
	$$$HSTRACESTARTCALL
	Try {
		If pInput.%IsA("HS.Message.XMLMessage") {
			Set tClassname = $Case(pInput.Name,
				$$$XCAIRetrieveRequest: "HS.Message.IHE.XCAI.RetrieveRequest",
				$$$XCAIRetrieveResponse:"HS.Message.IHE.XCAI.RetrieveResponse",
				$$$XDSIRetrieveRequest: "HS.Message.IHE.XDSI.RetrieveRequest",
				$$$XDSIRetrieveResponse:"HS.Message.IHE.XDSI.RetrieveResponse",
				:"")
			If tClassname="" $$$ThrowStatus($$$ERROR($$$GeneralError, "Request type not handled:  " _ pInput.Name))
			
			If pInput.ContentStream.Size=0 $$$ThrowStatus($$$ERROR($$$GeneralError,"Empty SOAP body"))
			
			#; The temp streams helps detect if the inbound XML is bad
			Set tTemp = ##class(%FileCharacterStream).%New()
			Set tTemp.TranslateTable="UTF8"
			Set tTransformName = $tr($p(tClassname,"HS.Message.IHE.",2),".")_"ImportTransform"  /// ie XCAIRetrieveRequestImportTranform
			Set tSC = ..Transformer.TransformIntoObject(pInput.ContentStream, $property($this,tTransformName), .pOutput, .tParams, tClassname, /*xmlName*/, /*Canonicalize*/, tTemp)
			If $$$ISERR(tSC) {
				If tTemp.Size=0 Set tSC = $$$ERROR($$$GeneralError,"Unexpected SOAP body")
				$$$ThrowStatus(tSC)
			}
			
			#; Copy SAML / XUA for requests
			If pOutput.%Extends("HS.Types.RequestInfo") {
				$$$ThrowOnError(##class(HS.Types.RequestInfo).XMLMessageToRequestInfo(pInput, pOutput))	
			}
		}
		Else {
			#; check XCAI first since it also %IsA XDSI
			Set tName = $Select(  
				pInput.%IsA("HS.Message.IHE.XCAI.RetrieveRequest") :$$$XCAIRetrieveRequest,
				pInput.%IsA("HS.Message.IHE.XCAI.RetrieveResponse"):$$$XCAIRetrieveResponse,
				pInput.%IsA("HS.Message.IHE.XDSI.RetrieveRequest") :$$$XDSIRetrieveRequest,
				pInput.%IsA("HS.Message.IHE.XDSI.RetrieveResponse"):$$$XDSIRetrieveResponse,
				1:"")
			If tName="" $$$ThrowStatus($$$ERROR($$$GeneralError, "Message class "_pInput.%ClassName(1)_" not supported"))

			Set pOutput = ##class(HS.Message.XMLMessage).%New()
			Set pOutput.Name = tName
			Set tTransformName = $tr($p(pInput.%ClassName(1),"HS.Message.IHE.",2),".")_"ExportTransform"  /// ie XCAIRetrieveRequestExportTranform
			$$$ThrowOnError(..Transformer.TransformFromObject(pInput, $property($this,tTransformName), .tContent, .tParams))
			$$$ThrowOnError(pOutput.ContentStream.CopyFrom(tContent))
			
			#; Copy SAML / XUA for requests
			If pInput.%Extends("HS.Types.RequestInfo") {
				$$$ThrowOnError(##class(HS.Types.RequestInfo).RequestInfoToXMLMessage(pInput, pOutput))	
			}			
		}
		
		#; Copy AdditionalInfo w/o overwriting anything the RequestInfo set
		$$$ThrowOnError(##class(HS.IHE.Util).MergeAdditionalInfo(pInput, pOutput))
		
		#; Copy attachments for responses
		If ##class(%Dictionary.CompiledProperty).%Exists($LB(pInput.%ClassName(1)_"||StreamCollection")) {
	 		Set tIdx="" 
	 		For { 
	 			Set tAttach = pInput.StreamCollection.GetNext(.tIdx) Quit:tIdx=""
	 			$$$ThrowOnError(pOutput.StreamCollection.Insert(tAttach))
	 		}
	 	}
	}
	Catch ex {
		Set tSC = ex.AsStatus()
	}
	$$$HSTRACEENDCALL
	Quit tSC
}

/// Normalize, validate and split a request by community/repository
/// ##; pDocuments = count, pDocuments(docUniqId) = $LB(homeId,repoId)
Method SplitRequests(pRequest As HS.Message.IHE.XDSI.RetrieveRequest, Output pRequests As %ListOfObjects, Output pDocuments) As %Status
{
	#; The request is either XDSI or XCAI
	#dim tStudy    As HS.Message.IHE.XDSI.StudyRequest
	#dim tSeries   As HS.Message.IHE.XDSI.SeriesRequest
	#dim tDocument As HS.Message.IHE.XDSI.DocumentRequest
	#dim tRequest  As HS.Message.IHE.XDSI.RetrieveRequest
	#dim tResponse As HS.Message.IHE.XDSI.RetrieveResponse
	
	Set tSC = $$$OK
	Try {
		Set pRequests = ##class(%ListOfObjects).%New()
		Kill pDocuments 
		Set pDocuments = 0  ##; pDocuments = count, pDocuments(docUniqId) = $LB(homeId,repoId)
		
		Set tIndex = 0
		Set tStudyIdx=""
		For { 
			Set tStudy = pRequest.Studies.GetNext(.tStudyIdx) Quit:tStudyIdx=""
		
			Set tCrumb = $LB("position="_tStudyIdx)
			If tStudy.StudyInstanceUID = "" {
				Do ..LogError($$$XCAIError, "Missing study instance UID:(position="_tStudyIdx_")")
				Continue
			}
			Set $LI(tCrumb,1) = "study="_tStudy.StudyInstanceUID
						
			Set tSeriesIdx="" 
			For { 
				Set tSeries = tStudy.Series.GetNext(.tSeriesIdx) Quit:tSeriesIdx=""
			
				Set $LI(tCrumb,2) = "position="_tSeriesIdx			
				If tSeries.SeriesInstanceUID = "" {
					Do ..LogError($$$XCAIError, "Missing series instance UID:("_$LTS(tCrumb,", ")_")")
					Continue
				}
				Set $LI(tCrumb,2) = "series="_tSeries.SeriesInstanceUID
				
				Set tDocIdx="" 
				For { 
					Set tDocument = tSeries.DocumentRequests.GetNext(.tDocIdx) Quit:tDocIdx=""
					Set $LI(tCrumb,3) = "position="_tDocIdx					
					If tDocument.DocumentUniqueId="" {
						Do ..LogError($$$XCAIErrorDocumentUniqueIdError, "Missing document unique ID:("_$LTS(tCrumb,", ")_")")
						Continue
					}
					
					#; now that we know docUniqId no longer need the breadcrumb
					
					If tDocument.RepositoryUniqueId="" {
						Do ..LogError($$$XCAIError, "Missing repository unique ID", tDocument.DocumentUniqueId)
						Continue
					}
					If tDocument.HomeCommunityId="" {
						#; no error - default to the current home-community
						Set tDocument.HomeCommunityId = ..HomeCommunityOID
					}

					#; Lookup the service
					If tDocument.HomeCommunityId = ..HomeCommunityOID {
						Set tService = ##class(HS.Registry.Service.SOAP).EndPointForOID(tDocument.RepositoryUniqueId, "Repository", "XDSI.Retrieve")
						If tService = "" {
							Do ..LogError($$$XCAIErrorUnknownRepositoryId, "XDSI.Retrieve endpoint not found for repository:("_tDocument.RepositoryUniqueId_")", tDocument.DocumentUniqueId)
							Continue
						}
						If '$D(tIndex(tService.Name)) {
							Set tIndex(tService.Name) = ##class(HS.Message.IHE.XDSI.RetrieveRequest).%New()
						}
					}
					Else {
						Set tService = ##class(HS.Registry.Service.SOAP).EndPointForOID(tDocument.HomeCommunityId, "HomeCommunity", "XCAI.Retrieve")
						If tService = "" {
							Do ..LogError($$$XCAIErrorUnknownCommunity, "XCAI.Retrieve endpoint not found for community:("_tDocument.HomeCommunityId_")", tDocument.DocumentUniqueId)
							Continue
						}

						If '$D(tIndex(tService.Name)) {
							Set tIndex(tService.Name) = ##class(HS.Message.IHE.XCAI.RetrieveRequest).%New()
						}
					}

					#; Save the community context for later when combining results
					If $D(tIndex(tService.Name))\10 {
						Do tIndex(tService.Name).AdditionalInfo.SetAt(tDocument.HomeCommunityId,"HomeCommunityOID")
						Do tIndex(tService.Name).AdditionalInfo.SetAt(tDocument.RepositoryUniqueId,"RepositoryOID")
					}

					Set tIndex(tService.Name, tStudy.StudyInstanceUID, tSeries.SeriesInstanceUID, $I(tIndex)) = tDocument
				}				
			}
		}
		If '$D(tIndex) Quit

		Set tServiceName = "" 
		For { 
			Set tServiceName = $O(tIndex(tServiceName),1,tRequest) Quit:tServiceName=""
			$$$ThrowOnError(pRequests.Insert(tRequest))		

			Set tRequest.SAMLData = pRequest.SAMLData.%ConstructClone()
			Set tRequest.AdditionalInfo = pRequest.AdditionalInfo.%ConstructClone()
			Do tRequest.AdditionalInfo.SetAt(tServiceName,"ServiceName")
			Do tRequest.AdditionalInfo.RemoveAt("RelatesTo")
			Do tRequest.AdditionalInfo.RemoveAt("ReplyAddress")
				
			Set tRequest.TransferSyntaxes = pRequest.TransferSyntaxes.%ConstructClone()
			
			Set tStudyUID = "" 
			For { 
				Set tStudyUID = $O(tIndex(tServiceName,tStudyUID)) Quit:tStudyUID=""
				Set tStudy = ##class(HS.Message.IHE.XDSI.StudyRequest).%New()
				Set tStudy.StudyInstanceUID = tStudyUID
				$$$ThrowOnError(tRequest.Studies.Insert(tStudy))
			
				Set tSeriesUID = "" 
				For { 
					Set tSeriesUID = $O(tIndex(tServiceName,tStudyUID,tSeriesUID)) Quit:tSeriesUID=""
					Set tSeries = ##class(HS.Message.IHE.XDSI.SeriesRequest).%New()
					Set tSeries.SeriesInstanceUID = tSeriesUID
					$$$ThrowOnError(tStudy.Series.Insert(tSeries))
			
					Set tDocIdx = "" 
					For { 
						Set tDocIdx = $O(tIndex(tServiceName,tStudyUID,tSeriesUID,tDocIdx),1,tDocument) Quit:tDocIdx=""
						$$$ThrowOnError(tSeries.DocumentRequests.Insert(tDocument))
						Set pDocuments = pDocuments + 1
						Set pDocuments(tServiceName, tDocument.DocumentUniqueId) = $LB(tDocument.HomeCommunityId, tDocument.RepositoryUniqueId)
					}
				}
			}
		}
	} 
	Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Validate, normalize and combine all results of the batch
/// 
Method CombineResponses(pResponses As %ListOfObjects, ByRef pResponse As HS.Message.IHE.XDSI.RetrieveResponse, ByRef pExpectedDocuments) As %Status
{
	#dim tResponse As HS.Message.IHE.XDSI.RetrieveResponse
	#dim tAttach   As HS.IHE.Common.Messages.MIMEAttachment
	#dim tDocument As HS.Message.IHE.XDSI.DocumentResponse
	#dim tError    As HS.Types.IHE.Error
	
	Set tSC = $$$OK
	Try {
		Set tResponseIdx = "" 
		For { 
			Set tResponse = pResponses.GetNext(.tResponseIdx) Quit:tResponseIdx=""
			#; Get the request context
			Set tServiceName      = tResponse.AdditionalInfo.GetAt("ServiceName")
			Set tHomeCommunityOID = tResponse.AdditionalInfo.GetAt("HomeCommunityOID")
			Set tRepositoryOID    = tResponse.AdditionalInfo.GetAt("RepositoryOID")

			#; No need to check missing docs when the service returned partial/failure
			If tResponse.Status'=$$$XCAIStatusSuccess {
				Kill pExpectedDocuments(tServiceName)
			}
			
			#; Copy and validate errors
			#; - Missing location set to the responding homeCommunity
			Set tLocationIdx="" 
			For { 
				Set tError = tResponse.Errors.Errors.GetNext(.tLocationIdx) Quit:tLocationIdx=""
				If tError.Location = "" {
					Set tError.Location = tHomeCommunityOID
				}
				Do pResponse.AddError(tError)
			}
			
			#; Copy and validate documents
			#; - Missing docId, mimeType, or body is unrecoverable and will be removed (along with attachment)
			#; - Missing repo/community will default to request context
			#; - Inline documents moved to attachments (though that should already have happed in the operation)
			Set tIdx="" 
			For { 
				Set tDocument = tResponse.DocumentResponses.GetNext(.tIdx) Quit:tIdx=""
				If tDocument.DocumentUniqueId="" {
					Do ..LogError($$$XCAIErrorDocumentUniqueIdError, "Missing document unique ID in response:(repository="_tRepositoryOID_")", tHomeCommunityOID)
					If tDocument.XOP'="" Set tSkipAttach(tDocument.XOP)=""
					Continue
				}
				
				Kill pExpectedDocuments(tServiceName, tDocument.DocumentUniqueId)
				
				If tDocument.MimeType="" {
					Do ..LogError($$$XCAIError, "Missing mime-type in response:(document="_tDocument.DocumentUniqueId_"; repository="_tRepositoryOID_")", tHomeCommunityOID)
					If tDocument.XOP'="" Set tSkipAttach(tDocument.XOP)=""
				}
				ElseIf tDocument.XOP="",tDocument.Body.Size=0 {
					Do ..LogError($$$XCAIError, "Missing document body in response:(document="_tDocument.DocumentUniqueId_"; repository="_tRepositoryOID_")", tHomeCommunityOID)
					If tDocument.XOP'="" Set tSkipAttach(tDocument.XOP)=""
				}				
				Else {
					If tDocument.RepositoryUniqueId="" Set tDocument.RepositoryUniqueId = tRespositoryOID
					If tDocument.HomeCommunityId="" Set tDocument.HomeCommunityId = tHomeCommunityOID
					If tDocument.XOP'="" Set tExpect($zcvt(tDocument.XOP,"I","URL")) = tDocument.DocumentUniqueId
					$$$ThrowOnError(pResponse.AddDocument(tDocument))
				}
			}
			
			#; Copy and validate attachments
			#; - Missing contentId removes attachment and temp file
			#; - Unexpected attachments removed along with temp file
			Set tIdx="" 
			For { 
				Set tAttach = tResponse.StreamCollection.GetNext(.tIdx) Quit:tIdx=""
				If tAttach.ContentId = "" {
					Do ..LogError($$$XCAIError,"Missing attachment content-id in response:(repository="_tRepositoryOID_")", tHomeCommunityOID)
					Do:tAttach.FilePath'="" ##class(%File).Delete(tAttach.FilePath)
				}
				ElseIf '$D(tSkipAttach(tAttach.ContentId)) {
					If '$D(tExpect(tAttach.ContentId)) {
						Do ..LogError($$$XCAIError,"Unexpected attachment in response:(contentId="_tAttach.ContentId_")", tHomeCommunityOID)
						Do:tAttach.FilePath'="" ##class(%File).Delete(tAttach.FilePath)
					}
					Else {
						$$$ThrowOnError(pResponse.AddAttachment(tAttach))					
						Kill tExpect(tAttach.ContentId)
					}
				}
			}
			
			#; Remove documents missing an attachment (if XOP is not null)
			Set tXOP="" 
			For { 
				Set tXOP=$O(tExpect(tXOP),1,tDocumentUniqueId) Quit:tXOP=""
				Kill tExpect(tXOP)
				Do ..LogError($$$XCAIError, "Missing attachment in response:(document="_tDocumentUniqueId_"; repository="_tRepositoryOID_")", tHomeCommunityOID)
				Set tIdx="" 
				For { 
					Set tDocument = pResponse.DocumentResponses.GetNext(.tIdx) Quit:tIdx=""
					If tDocument.XOP = tXOP {
						Do pResponse.DocumentResponses.RemoveAt(tIdx)
						Kill pExpectedDocuments(tServiceName, tDocumentUniqueId)
						Quit
					}
				}
			}

			#; The spec allows Responding Gatways to ignore failures (see RAD TF-3 4.75.4.1.3)
			#; However, HealthShare will *always* report a failure. Thus, all missing documents 
			#; will be logged as an error when the responder for that doc indicated success
			Set tDocId="" 
			For { 
				Set tDocId=$O(pExpectedDocuments(tServiceName,tDocId)) Quit:tDocId=""
				Do ..LogError($$$XCAIError, "Document not returned in response:(document="_tDocId_"; repository="_tRepositoryOID_")", tHomeCommunityOID)
			}
		}

	}
	Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Move list of requests into an Ensemble call-structure array
/// 
Method BatchRequests(pRequests As %ListOfObjects, pTarget As Ens.DataType.ConfigName, ByRef pBatch) As %Status
{
	#dim tCall As Ens.CallStructure

	Kill pBatch
	Set tIdx="" 
	For { 
		Set tRequest = pRequests.GetNext(.tIdx) Quit:tIdx=""
		Set tCall = ##class(Ens.CallStructure).%New()
		Set tCall.Request = tRequest
		Set tCall.TargetDispatchName = pTarget
		Set pBatch($i(pBatch)) = tCall
	}
	If '$D(pBatch) {
		Do ..LogError($$$XCAIError, "No valid document requests found")
	}
	Quit $$$OK
}

/// Move results from call structure array into a responses list; logs any errors found
/// 
Method BatchResponses(ByRef pBatch, Output pResponses As %ListOfObjects) As %Status
{
	#dim tCall      As Ens.CallStructure
	#dim tResponse  As HS.Message.IHE.XDSI.RetrieveResponse
	#dim tRequest   As HS.Message.IHE.XDSI.RetrieveRequest
	
	Set tSC = $$$OK
	Try {
		Set pResponses = ##class(%ListOfObjects).%New()
		
		For tIdx=1:1:pBatch {
			Set tCall = pBatch(tIdx)
			Set tRequest = tCall.Request
			Set tResponse = tCall.Response
			
			Set tServiceName      = tRequest.AdditionalInfo.GetAt("ServiceName")
			Set tHomeCommunityOID = tRequest.AdditionalInfo.GetAt("HomeCommunityOID")
			Set tRepositoryOID    = tRequest.AdditionalInfo.GetAt("RepositoryOID")
			
			If $$$ISERR(tCall.ResponseCode) {
				Do ..LogStatus(tCall.ResponseCode)
			}
			ElseIf '$IsObject(tResponse) {
				If tHomeCommunityOID=..HomeCommunityOID {
					Do ..LogError($$$XCAIError,"No response from service "_tServiceName_" (repository="_tRepositoryOID_")",tHomeCommunityOID)
				}
				Else {
					Do ..LogError($$$XCAIErrorUnavailableCommunity,"No response from service "_tServiceName,tHomeCommunityOID)
				}
			}
			Else {
				#; copy request context into responses for combine processing
				Do tResponse.AdditionalInfo.SetAt(tServiceName,"ServiceName")
				Do tResponse.AdditionalInfo.SetAt(tHomeCommunityOID,"HomeCommunityOID")
				Do tResponse.AdditionalInfo.SetAt(tRepositoryOID,"RepositoryOID")

				$$$ThrowOnError(pResponses.Insert(tResponse))				
			}
		}
	}
	Catch ex { 
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Ensure the response has errors, documents or both and a valid status
/// 
Method FinalizeResponse(pResponse As HS.Message.IHE.XDSI.RetrieveResponse)
{
	Try {
		Set tIdx="" 
		For { 
			Set tError = ..Errors.Errors.GetNext(.tIdx) Quit:tIdx=""
			Do pResponse.AddError(tError)
		}
		Do pResponse.FinalizeStatus()
	}
	Catch ex {
		#; ignore all errors
		$$$LOGSTATUS(ex.AsStatus())
	}
}

/// Create generic error response for a fatal error
/// 
Method ErrorResponse(pName As %String, pSC As %Status, Output pResponse As HS.Message.XMLMessage) As %Status
{
	Set tDesc = $SYSTEM.Status.GetErrorText(pSC)
	If tDesc[" [" {
		Set tDesc = $P(tDesc," [",1)                ##; foo [tag+1^rou]
	}
	If $E(tDesc,1,6)="ERROR " {
		Set tDesc = $P(tDesc,": ",2,*)  ##; ERROR 5001: foo
	}

	Set pResponse = ##class(HS.Message.XMLMessage).%New()
	Set pResponse.Name = pName
	Do pResponse.ContentStream.WriteLine("<xdsb:RetrieveDocumentSetResponse xmlns:xdsb=""urn:ihe:iti:xds-b:2007"" xmlns:rs=""urn:oasis:names:tc:ebxml-regrep:xsd:rs:3.0"">")
	Do pResponse.ContentStream.WriteLine(" <rs:RegistryResponse status=""urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Failure"">")
	Do pResponse.ContentStream.WriteLine("  <rs:RegistryErrorList highestSeverity=""urn:oasis:names:tc:ebxml-regrep:ErrorSeverityType:Error"">")
	Do pResponse.ContentStream.WriteLine("   <rs:RegistryError codeContext="""_tDesc_""" errorCode=""XDSRepositoryError"" location="""_..HomeCommunityOID_""" severity=""urn:oasis:names:tc:ebxml-regrep:ErrorSeverityType:Error""/>")
	Do pResponse.ContentStream.WriteLine("  </rs:RegistryErrorList>")
	Do pResponse.ContentStream.WriteLine(" </rs:RegistryResponse>")
	Do pResponse.ContentStream.WriteLine("</xdsb:RetrieveDocumentSetResponse>")
	Quit $$$OK
}

}
