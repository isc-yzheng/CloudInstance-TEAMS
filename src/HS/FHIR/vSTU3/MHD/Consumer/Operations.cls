Class HS.FHIR.vSTU3.MHD.Consumer.Operations Extends (HS.FHIR.REST.Operation, HS.HC.Util.Trace.Helper) [ Inheritance = right, ProcedureBlock ]
{

Parameter INVOCATION = "Queue";

Parameter SETTINGS = "MHDRegistryServiceName:Basic:selector?Select=1&context={HS.Util.ContextSearch/ServiceNameItemsByParam?Type=HTTP},MHDRepositoryServiceName:Basic:selector?Select=1&context={HS.Util.ContextSearch/ServiceNameItemsByParam?Type=HTTP},FHIRFormat";

/// The service name found in HS.Registry.Service.*
Property MHDRegistryServiceName As %String(MAXLEN = 512);

/// The service name found in HS.Registry.Service.*
Property MHDRepositoryServiceName As %String(MAXLEN = 512);

/// Caches Service Registry information for the currently selected service.<br>
/// Format:<br>
/// <li>$List position 1  : Service Name
/// <li>$List position 2  : Service %Id
/// <li>$List position 3  : Device OID
/// <li>$List position 4  : Assigning Authority
/// <li>$List position 5  : Receiving Application
/// <li>$List position 6  : Receiving Facility
/// <li>$List position 7  : Host
/// <li>$List position 8  : Port
/// <li>$List position 9  : StayConnected
/// <li>$List position 10 : SSL Config
/// <li>$List position 11 : URL
Property RegistryService As %String;

/// The FHIR format to specify for the FHIR query response.  This
/// setting may be overridden by adding an AdditionalInfoItem named
/// "_format" to the XDSb Query or Retrieve request message.  Valid
/// values for _format are: "xml", "json", "application/xml+fhir",
/// "application/json+fhir", "application/fhir+xml" and "application/fhir+json".
Property FHIRFormat As %String(DISPLAYLIST = ",XML,JSON", VALUELIST = ",XML,JSON") [ InitialExpression = "XML" ];

XData MessageMap
{
<MapItems>
  <MapItem MessageType="HS.Message.IHE.XDSb.QueryRequest">
    <Method>MHDQueryRequest</Method>
  </MapItem>
  <MapItem MessageType="HS.Message.IHE.XDSb.RetrieveRequest">
    <Method>MHDRetrieveRequest</Method>
  </MapItem>
</MapItems>
}

Method OnMessage(pRequest As HS.Message.FHIR.Request, Output pResponse As HS.Message.FHIR.Response) As %Status
{
	Set tSC = $$$OK
	
	Try {
		If pRequest.%IsA("HS.Message.FHIR.Request") {
			$$$HSTRACE("FHIR Request", "pRequest", pRequest)
			If (pRequest.Interaction = "search") && ((pRequest.Type="DocumentManifest") || (pRequest.Type="DocumentReference")) {
				Set tSC = ..FHIRRequest(pRequest, .pResponse)
			}
			ElseIf (pRequest.Interaction = "read") && ((pRequest.Type="DocumentManifest") || (pRequest.Type="DocumentReference") || (pRequest.Type="Binary")) {
				Set tSC = ..FHIRRequest(pRequest, .pResponse)
			}
			ElseIf pRequest.AdditionalInfo.GetAt("GetURL")'="" {
				Set tSC = ..FHIRRequest(pRequest, .pResponse)
			}
			Else {
				Set tSC = $$$ERROR($$$GeneralError, "Request "_pRequest.Interaction_" interaction on FHIR "_pRequest.Type_" type not handled")
			}
		} Else {
			Set tSC = $$$ERROR($$$GeneralError, "Message class "_pRequest.%ClassName(1)_" not handled")
		}
		If $$$ISERR(tSC) Quit
		
		// Format the FHIR Payload before logging for HSTRACE.
		If ($IsObject($Get(pResponse)))&&($$$HSTRACING) {
			Set tContentType = $ZConvert(pResponse.ContentType,"L")
			If (pResponse.Payload.Size=0)||((tContentType'["json")&&(tContentType'["xml")) {
				// Just log the response as is if there is no payload or the payload is not FHIR (e.g., text/plain).
				$$$HSTRACE("FHIR Response", "pResponse", pResponse)
			} Else {
				// Format the returned FHIR Payload for display.
				Set tResponse = pResponse.%ConstructClone(1)
				Set tTempStream = ##class(%Stream.TmpCharacter).%New()
				Set tSC = ##class(HS.FHIR.Utils).FormatFHIR(pResponse.ContentType, pResponse.Payload, .tTempStream, $Char(32,32), $Char(13,10), , 2)
				If $$$ISERR(tSC) Quit
				Do pResponse.Payload.Rewind()
				Do tResponse.Payload.Clear()
				Do tResponse.Payload.CopyFrom(tTempStream)
				$$$HSTRACE("FHIR Response", "tResponse", tResponse)
				Kill tTempStream
				Kill tTransformer
				Kill tResponse
			}
		}
		
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	Quit tSC
}

Method OnInit() As %Status
{
	Set tSC=$$$OK
	
	Try {
		Set tSC = ##super()
		If $$$ISERR(tSC) Quit
		If ..ServiceName'="" Do ..UpdateRegistryService(..ServiceName)
	} Catch eException {
		Set tSC=eException.AsStatus()
	}
	
	Quit tSC
}

/// MHDQueryRequest takes an HS XDSb QueryRequest as input, tranforms
/// it into an HS FHIR request, calls OnMessage to send it on to
/// its intended target, receives the HS FHIR response, transforms
/// it into an HS XDSb QueryResponse, and returns it.
Method MHDQueryRequest(pXDSbRequest As HS.Message.IHE.XDSb.QueryRequest, ByRef pXDSbResponse As HS.Message.IHE.XDSb.QueryResponse) As %Status
{
	Set tSC = $$$OK
	
	Try {
		#dim tMHDQueryRequest As HS.Message.FHIR.Request
		#dim tMHDQueryResponse As HS.Message.FHIR.Response
		
		Set tSC = ..XDSbQueryRequestToMHDRequest(pXDSbRequest, .tMHDQueryRequest)
		If $$$ISERR(tSC) Quit
		
		Set tSC = ..OnMessage(tMHDQueryRequest, .tMHDQueryResponse)
		If $$$ISERR(tSC) Quit
		
		Set tSC = ..MHDQueryResponseToXDSbResponse(tMHDQueryRequest, tMHDQueryResponse, .pXDSbResponse)
		If $$$ISERR(tSC) Quit
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// MHDQueryRequest takes an HS XDSb RetrieveRequest as input, tranforms
/// it into an HS FHIR request, calls OnMessage to send it on to
/// its intended target, recieves the HS FHIR response, transforms
/// it into an HS XDSb RetrieveResponse, and returns it.
Method MHDRetrieveRequest(pXDSbRequest As HS.Message.IHE.XDSb.RetrieveRequest, ByRef pXDSbResponse As HS.Message.IHE.XDSb.RetrieveResponse) As %Status
{
	Set tSC = $$$OK
	
	Try {
		#dim tMHDRetrieveRequest As HS.Message.FHIR.Request
		#dim tMHDRetrieveResponse As HS.Message.FHIR.Response
		
		Set tSC = ..XDSbRetrieveRequestToMHDRequest(pXDSbRequest, .tMHDRetrieveRequest)
		If $$$ISERR(tSC) Quit
		
		Set tSC = ..OnMessage(tMHDRetrieveRequest, .tMHDRetrieveResponse)
		If $$$ISERR(tSC) Quit
		
		Set tSC = ..RetrieveResponseToXDSbResponse(tMHDRetrieveResponse, .pXDSbResponse)
		If $$$ISERR(tSC) Quit
		
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	Quit tSC
}

Method XDSbQueryRequestToMHDRequest(pXDSbRequest As HS.Message.IHE.XDSb.QueryRequest, ByRef pMHDRequest As HS.Message.FHIR.Request) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set tServiceName = pXDSbRequest.AdditionalInfo.GetAt("ServiceName")
		Set:tServiceName="" tServiceName = ..MHDRegistryServiceName
		Set ..ServiceName = tServiceName
		Do ..UpdateRegistryService(tServiceName)
		
		Set pMHDRequest = ##class(HS.Message.FHIR.Request).%New()
		
		Do pMHDRequest.AdditionalInfo.SetAt(tServiceName, "ServiceName")
		
		#; patient -> PatientId from FHIR resource Id
		#; patient.identifier -> PatientId
		Set tStatusAdded = 0
		For i = 1:1:pXDSbRequest.Parameters.Count() {
			Set tParam = pXDSbRequest.Parameters.GetAt(i)
			If (tParam.ItemName="$XDSSubmissionSetPatientId")||(tParam.ItemName="$XDSDocumentEntryPatientId") {
				Set tValue = tParam.Values.GetAt(1)
				Set tSystem = $Piece($Piece(tValue,"^",4),"&",2)
				If ($Extract(tSystem,1,8)'="urn:oid:")&&(##class(HS.HC.Util).IsOID(tSystem)) Set tSystem = "urn:oid:"_tSystem
				Set tIdentifier = $Piece(tValue,"^",1)
				Set tSC = pMHDRequest.SetParameter("patient.identifier", tSystem_"|"_tIdentifier) Quit:$$$ISERR(tSC)
			} ElseIf (tParam.ItemName="$XDSSubmissionSetUniqueId")||(tParam.ItemName="$XDSDocumentEntryUniqueId") {
				Set tValue = tParam.Values.GetAt(1)
				Set tSC = pMHDRequest.SetParameter("identifier", tValue) Quit:$$$ISERR(tSC)
			} ElseIf (tParam.ItemName="$XDSSubmissionSetSubmissionTimeFrom") {
				Set tValue = tParam.Values.GetAt(1)
				Set tCreatedFrom = tValue
				Set tValue = "ge"_tValue
				Set tSC = pMHDRequest.SetParameter("created", tValue) Quit:$$$ISERR(tSC)
			} ElseIf (tParam.ItemName="$XDSSubmissionSetSubmissionTimeTo") {
				Set tValue = tParam.Values.GetAt(1)
				Set tCreatedTo = tValue
				Set tValue = "le"_tValue
				Set tSC = pMHDRequest.SetParameter("created", tValue) Quit:$$$ISERR(tSC)
			} ElseIf (tParam.ItemName="$XDSDocumentEntryCreationTimeFrom") {
				Set tValue = tParam.Values.GetAt(1)
				Set tCreationFrom = tValue
				Set tValue = "ge"_tValue
				Set tSC = pMHDRequest.SetParameter("indexed", tValue) Quit:$$$ISERR(tSC)
			} ElseIf (tParam.ItemName="$XDSDocumentEntryCreationTimeTo") {
				Set tValue = tParam.Values.GetAt(1)
				Set tCreationTo = tValue
				Set tValue = "le"_tValue
				Set tSC = pMHDRequest.SetParameter("indexed", tValue) Quit:$$$ISERR(tSC)
			} ElseIf (tParam.ItemName="$XDSSubmissionSetAuthorPerson")||(tParam.ItemName="$XDSDocumentEntryAuthorPerson") {
				Set tValue = tParam.Values.GetAt(1)
				Set tLastName = $Piece(tValue,"^",2)
				Set tFirstName = $Piece(tValue,"^",3)
				If tLastName'="" Set tSC = pMHDRequest.SetParameter("author.family", tLastName) Quit:$$$ISERR(tSC)
				If tFirstName'="" Set tSC = pMHDRequest.SetParameter("author.given", tFirstName) Quit:$$$ISERR(tSC)
			} ElseIf (tParam.ItemName="$XDSSubmissionSetContentType")||(tParam.ItemName="$XDSDocumentEntryTypeCode") {
				Set tSC = ..AddURLTokenParam("type", tParam.Values, .pMHDRequest) Quit:$$$ISERR(tSC)
			} ElseIf (tParam.ItemName="$XDSSubmissionSetSourceId") {
				For j = 1:1:tParam.Values.Count() {
					Set tValue = $Piece(tParam.Values.GetAt(j),"^",1)
					If tValue'="" {
						If ($Extract(tValue,1,8)'="urn:oid:")&&(##class(HS.HC.Util).IsOID(tValue)) {
							Set tValue = "urn:oid:"_tValue
						}
						Set tSC = pMHDRequest.SetParameter("source", tValue)
					}
				}
				If $$$ISERR(tSC) Quit
			} ElseIf (tParam.ItemName="$XDSSubmissionSetStatus")||(tParam.ItemName="$XDSDocumentEntryStatus") {
				For j = 1:1:tParam.Values.Count() {
					Set tValue = tParam.Values.GetAt(j)
					If $Extract(tValue,*-7,*)="Approved" Set tValue = "current"
					If $Extract(tValue,*-9,*)="Deprecated" Set tValue = "superseded"
					Set tSC = pMHDRequest.SetParameter("status", tValue) Quit:$$$ISERR(tSC)
					Set tStatusAdded = 1
				}
			} ElseIf (tParam.ItemName="$XDSDocumentEntryHealthcareFacilityTypeCode") {
				Set tSC = ..AddURLTokenParam("facility", tParam.Values, .pMHDRequest) Quit:$$$ISERR(tSC)
			} ElseIf (tParam.ItemName="$XDSDocumentEntryEventCodeList") {
				Set tSC = ..AddURLTokenParam("event", tParam.Values, .pMHDRequest) Quit:$$$ISERR(tSC)
			} ElseIf (tParam.ItemName="$XDSDocumentEntryConfidentialityCode") {
				Set tSC = ..AddURLTokenParam("securityLabel", tParam.Values, .pMHDRequest) Quit:$$$ISERR(tSC)
			} ElseIf (tParam.ItemName="$XDSDocumentEntryFormatCode") {
				Set tSC = ..AddURLTokenParam("format", tParam.Values, .pMHDRequest) Quit:$$$ISERR(tSC)
			} ElseIf (tParam.ItemName="$XDSDocumentEntryReferenceIdList") {
				For j = 1:1:tParam.Values.Count() {
					Set tValue = tParam.Values.GetAt(j)
					Set tSystem = $Piece($Piece(tValue,"^",4),"&",2)
					If ($Extract(tSystem,1,8)'="urn:oid:")&&(##class(HS.HC.Util).IsOID(tSystem)) Set tSystem = "urn:oid:"_tSystem
					Set tIdentifier = $Piece(tValue,"^",1)
					Set tSC = pMHDRequest.SetParameter("related-id", tSystem_"|"_tIdentifier) Quit:$$$ISERR(tSC)
				}
				Quit:$$$ISERR(tSC)
			} ElseIf (tParam.ItemName="$XDSDocumentEntryClassCode") {
				Set tSC = ..AddURLTokenParam("class", tParam.Values, .pMHDRequest) Quit:$$$ISERR(tSC)
			} ElseIf (tParam.ItemName="$XDSDocumentEntryPracticeSettingCode") {
				Set tSC = ..AddURLTokenParam("setting", tParam.Values, .pMHDRequest) Quit:$$$ISERR(tSC)
			}
		}
		If $$$ISERR(tSC) Quit
		
		If ($Get(tCreatedFrom)'="")&&($Get(tCreatedFrom)=$Get(tCreatedTo)) {
			Do pMHDRequest.Parameters.RemoveAt("created")
			Set tSC = pMHDRequest.SetParameter("created", tCreatedFrom) Quit:$$$ISERR(tSC)
		}
		
		If ($Get(tCreationFrom)'="")&&($Get(tCreationFrom)=$Get(tCreationTo)) {
			Do pMHDRequest.Parameters.RemoveAt("indexed")
			Set tSC = pMHDRequest.SetParameter("indexed", tCreationFrom) Quit:$$$ISERR(tSC)
		}
		
		If pXDSbRequest.AdditionalInfo.GetAt("PatientReference")'="" {
			Set tSC = pMHDRequest.SetParameter("patient", pXDSbRequest.AdditionalInfo.GetAt("PatientReference"))
			Quit:$$$ISERR(tSC)
		}
		
		Set pMHDRequest.Interaction = "search"
		
		If pXDSbRequest.QueryType = "FindSubmissionSets" {
			Set pMHDRequest.Type = "DocumentManifest"
		} Else {
			Set pMHDRequest.Type = "DocumentReference"
		}
		
		Set tFormat = $ZConvert(pXDSbRequest.AdditionalInfo.GetAt("_format"),"L")
		If tFormat'="" {
			Do ##class(HS.FHIR.Utils).GetValidFormats("Parameter", .tFormats)
			If '$Data(tFormats(tFormat)) Set tSC = $$$ERROR($$$GeneralError, "Invalid _format value "_tFormat_" specified") $$$ThrowOnError(tSC)
			Do pMHDRequest.SetParameter("_format", tFormat)
			Set pMHDRequest.ContentType = tFormats(tFormat)
		} Else {
			Do ##class(HS.FHIR.Utils).GetValidFormats("Accept", .tFormats)
			If $ZConvert(..FHIRFormat, "L")="xml" {
				Set pMHDRequest.ContentType = tFormats("application/xml+fhir")
			} Else {
				Set pMHDRequest.ContentType = tFormats("application/json+fhir")
			}
		}
		
	} Catch eException {
		$$$LOGERROR(eException.DisplayString())
		Set tSC = eException.AsStatus()	
	}
	
	Quit tSC
}

Method XDSbRetrieveRequestToMHDRequest(pXDSbRequest As HS.Message.IHE.XDSb.RetrieveRequest, ByRef pMHDRequest As HS.Message.FHIR.Request) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set tServiceName = pXDSbRequest.AdditionalInfo.GetAt("ServiceName")
		Set:tServiceName="" tServiceName = ..MHDRepositoryServiceName
		Set ..ServiceName = tServiceName
		Do ..UpdateRegistryService(tServiceName)
		
		Set pMHDRequest = ##class(HS.Message.FHIR.Request).%New()
		
		Do pMHDRequest.AdditionalInfo.SetAt(tServiceName, "ServiceName")
		
		#; Look up the Repository Unique Id OID in the OID Registry to get the URL of the
		#; MHD repository service.  Use that end point as the base URL of the Binary resource.
		Set tDocumentBaseURL = ##class(HS.Util.XSLTHelper).getServiceURLFromOID(pXDSbRequest.Documents.GetAt(i).RepositoryUniqueId,"Repository","MHD.Retrieve","HTTP")
		Set tFullURL = tDocumentBaseURL_"/Binary/"_pXDSbRequest.Documents.GetAt(i).RepositoryUniqueId_"|"_pXDSbRequest.Documents.GetAt(i).UniqueId
		
		Set pMHDRequest.Interaction = "read"
		Set pMHDRequest.Type = "Binary"
		Set pMHDRequest.Id = pXDSbRequest.Documents.GetAt(i).RepositoryUniqueId_"|"_pXDSbRequest.Documents.GetAt(i).UniqueId
		Set pMHDRequest.BaseURL = tDocumentBaseURL
		
		Set tFormat = $ZConvert(pXDSbRequest.AdditionalInfo.GetAt("_format"),"L")
		If tFormat'="" {
			Do ##class(HS.FHIR.Utils).GetValidFormats("Parameter", .tFormats)
			If '$Data(tFormats(tFormat)) Set tSC = $$$ERROR($$$GeneralError, "Invalid _format value "_tFormat_" specified") $$$ThrowOnError(tSC)
			Do pMHDRequest.SetParameter("_format", tFormat)
			Set pMHDRequest.ContentType = tFormats(tFormat)
		} Else {
			Do ##class(HS.FHIR.Utils).GetValidFormats("Accept", .tFormats)
			If $ZConvert(..FHIRFormat, "L")="xml" {
				Set pMHDRequest.ContentType = tFormats("application/xml+fhir")
			} Else {
				Set pMHDRequest.ContentType = tFormats("application/json+fhir")
			}
		}
		
	} Catch eException {
		$$$LOGERROR(eException.DisplayString())
		Set tSC = eException.AsStatus()	
	}
	
	Quit tSC
}

Method MHDQueryResponseToXDSbResponse(pMHDQueryRequest As HS.Message.FHIR.Request, pMHDQueryResponse As HS.Message.FHIR.Response, ByRef pXDSbQueryResponse As HS.Message.IHE.XDSb.QueryResponse) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set pXDSbQueryResponse = ##class(HS.Message.IHE.XDSb.QueryResponse).%New()
		
		Set tSC = ##class(HS.FHIR.Utils).FHIRToHSFHIR(pMHDQueryResponse.ContentType, pMHDQueryResponse.Payload, .tHSFHIRObj, "HS.FHIR.vSTU3.Model.Resource")
		If $$$ISERR(tSC) Quit
		
		If tHSFHIRObj.%ClassName(0)="OperationOutcome" {
			Do ..LogErrorFromOperationOutcome(tHSFHIRObj, .pXDSbQueryResponse)
			If pXDSbQueryResponse.Errors.Errors.Count()>0 Set tSC = $$$ERROR($$$GeneralError, pXDSbQueryResponse.Errors.Errors.GetAt(1).Description)
			Quit
		}
		
		#; Must be Bundle or OperationOutcome.
		If tHSFHIRObj.%ClassName(0)'="Bundle" {
			Set tSC = $$$ERROR($$$GeneralError, "Unexpected return resource type "_tHSFHIRObj.%ClassName(0)_" for MHD query")
			Quit
		}
		
		#; Nothing found, no errors, just return success.
		If tHSFHIRObj.entry.Count()=0 {
			Do pXDSbQueryResponse.ContentStream.WriteLine("<query:AdhocQueryResponse xmlns=""urn:oasis:names:tc:ebxml-regrep:xsd:query:3.0"" xmlns:query=""urn:oasis:names:tc:ebxml-regrep:xsd:query:3.0"" status=""urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Success"">")
			Do pXDSbQueryResponse.ContentStream.WriteLine("<rim:RegistryObjectList xmlns=""urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0"" xmlns:rim=""urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0""></rim:RegistryObjectList>")
			Do pXDSbQueryResponse.ContentStream.WriteLine("</query:AdhocQueryResponse>")
			Do pXDSbQueryResponse.ContentStream.Rewind()
			Quit
		}
		
		If pMHDQueryRequest.Type="DocumentManifest" {
			For i = 1:1:tHSFHIRObj.entry.Count() {
				Set tSC = ##class(HS.FHIR.Utils).GetResourceFromContainer(tHSFHIRObj.entry.GetAt(i).resource, .tResource)
				If $$$ISERR(tSC) Quit
				If tResource.%ClassName(0)="DocumentManifest" {
					Set tSC = ..DocManifestToXDSbResponse(tResource, .pXDSbQueryResponse)
					If $$$ISERR(tSC) Quit
				} ElseIf tResource.%ClassName(0)="OperationOutcome" {
					Do ..LogErrorFromOperationOutcome(tResource, .pXDSbQueryResponse)
				}
			}
		} Else {
			For i = 1:1:tHSFHIRObj.entry.Count() {
				Set tSC = ##class(HS.FHIR.Utils).GetResourceFromContainer(tHSFHIRObj.entry.GetAt(i).resource, .tResource)
				If $$$ISERR(tSC) Quit
				If tResource.%ClassName(0)="DocumentReference" {
					Set tSC = ..DocReferenceToXDSbResponse(tResource, .pXDSbQueryResponse)
					If $$$ISERR(tSC) Quit
				} ElseIf tResource.%ClassName(0)="OperationOutcome" {
					Do ..LogErrorFromOperationOutcome(tResource, .pXDSbQueryResponse)
				}
				
			}
		}
		If $$$ISERR(tSC) Quit
		
		If pXDSbQueryResponse.Errors.Errors.Count()>0 Set tSC = $$$ERROR($$$GeneralError, pXDSbQueryResponse.Errors.Errors.GetAt(1).Description)
		
	} Catch eException {
		$$$LOGERROR(eException.DisplayString())
		Set tSC = eException.AsStatus()	
	}
	
	Quit tSC
}

Method LogErrorFromOperationOutcome(pOperationOutcome As HS.FHIR.vSTU3.Model.Resource.OperationOutcome, ByRef pXDSbQueryResponse As HS.Message.IHE.XDSb.QueryResponse)
{
	For i = 1:1:pOperationOutcome.issue.Count() {
		Set tSeverity = pOperationOutcome.issue.GetAt(i).severity.value
		Set tSeverity = $Case(tSeverity, "error":"Error", "fatal":"Error", "warning":"Warning", "information":"Warning", :"Error")
		Set tCode = pOperationOutcome.issue.GetAt(i).code.value
		Set tDescription = pOperationOutcome.issue.GetAt(i).diagnostics.value
		If tDescription="" {
			If $IsObject(pOperationOutcome.issue.GetAt(i).details) {
				Set tDescription = pOperationOutcome.issue.GetAt(i).details.text.value
				If (tDescription="")&&($IsObject(pOperationOutcome.issue.GetAt(i).details.coding))&&(pOperationOutcome.issue.GetAt(i).details.coding.Count()>0) {
					Set tDescription = pOperationOutcome.issue.GetAt(i).details.coding.GetAt(1).display.value
					If tDescription="" Set tDescription = pOperationOutcome.issue.GetAt(i).details.coding.GetAt(1).code.value
				}
			}
			If tDescription="" Set tDescription = "Unknown "_tSeverity_" description"
		}
		Do pXDSbQueryResponse.Errors.logError(tCode, tSeverity, tDescription)
	}
	Quit
}

Method DocReferenceToXDSbResponse(pDocumentReference As HS.FHIR.vSTU3.Model.Resource.DocumentReference, ByRef pXDSbQueryResponse As HS.Message.IHE.XDSb.QueryResponse) As %Status
{
	Set tSC = $$$OK
	
	Try {
		#; This method assumes that a returned DocumentReference has one content
		#; object, and that that content object has one attachment object.
		
		Set tDocument = ##class(HS.Message.IHE.XDSb.Document).%New()
		
		For i = 1:1:pDocumentReference.contained.Count() {
			Set tSC = ##class(HS.FHIR.Utils).GetResourceFromContainer(pDocumentReference.contained.GetAt(i), .tResource)
			If $$$ISERR(tSC) Quit
			Set tResourceType = tResource.%ClassName(0)
			If tResourceType="Practitioner" {
				Set tFirstName = ""
				Set tLastName = ""
				If ($IsObject(tResource.name)) {
					If tResource.name.Count()>0 {
						If tResource.name.GetAt(1).given.Count() Set tFirstName = tResource.name.GetAt(1).given.GetAt(1).value
						If tResource.name.GetAt(1).family.value'="" Set tLastName = tResource.name.GetAt(1).family.value
						If (tFirstName'="")||(tLastName'="") {
							Set tAuthor = ##class(HS.IHE.XDSb.Types.Author).%New()
							Set tAuthor.AuthorPerson = "^"_tLastName_"^"_tFirstName_"^^^"
							Do tDocument.Author.Insert(tAuthor)
						}
					}
				}
			} ElseIf tResourceType="Patient" {
				#; Loop through identifiers to get PatientId (MPIID) and SourcePatientId.
				For j = 1:1:tResource.identifier.Count() {
					Set tIdentifier = tResource.identifier.GetAt(j)
					If $IsObject(tIdentifier.type) {
						Set tCode = ""
						Set tDisplay = ""
						If tIdentifier.type.coding.Count() {
							Set tCode = tIdentifier.type.coding.GetAt(1).code.value
							Set tDisplay = tIdentifier.type.coding.GetAt(1).display.value
						}
						Set tText = tIdentifier.type.text.value
						Set tValue = tIdentifier.value.value
						Set tSystem = tIdentifier.system.value
						If $Extract($ZConvert(tSystem,"L"),1,8)="urn:oid:" Set tSystem = $Extract(tSystem,9,*)
						Set tIdString = tIdentifier.value.value_"^^^&"_tSystem_"&ISO"
						If (tCode="MPIID")||(tDisplay="MPIID")||(tText="MPIID") {
							Set tDocument.PatientId = tIdString
						} ElseIf (tCode="MRN")||(tDisplay="MRN")||(tText="MRN")||(tCode="MR")||(tDisplay="MR")||(tText="MR") {
							Set tDocument.SourcePatientId = tIdString
							Set tSlot = ##class(HS.IHE.XDSb.Types.Slot).%New()
							Set tSlot.Name = "urn:healthshare:slots:sourceId"
							Do tSlot.ValueList.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New(tSystem))
							Do tDocument.DocumentSlots.Insert(tSlot)
						}
					}
				}
				Set tSourcePatientInfo = ##class(HS.IHE.XDSb.Types.SlotValue).%New()
				Do tDocument.SourcePatientInfo.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New("PID-3|"_tDocument.SourcePatientId))
				Set tFirstName = ""
				Set tMiddleName = ""
				Set tLastName = ""
				If tResource.name.Count() {
					If tResource.name.GetAt(1).family.value'="" Set tLastName = tResource.name.GetAt(1).family.value
					If tResource.name.GetAt(1).given.Count() Set tFirstName = tResource.name.GetAt(1).given.GetAt(1).value
					If tResource.name.GetAt(1).given.Count()>1 Set tMiddleName = tResource.name.GetAt(1).given.GetAt(2).value
				}
				Do tDocument.SourcePatientInfo.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New("PID-5|"_tLastName_"^"_tFirstName_"^"_tMiddleName))
				Do tDocument.SourcePatientInfo.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New("PID-7|"_$Translate(tResource.birthDate.value,"TZ-")))
				Set tSex = $Case(tResource.gender.value, "male":"M", "female":"F", :"U")
				Do tDocument.SourcePatientInfo.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New("PID-8|"_tSex))
				Set tAddressString = ""
				If tResource.address.Count() {
					For j = 1:1:tResource.address.GetAt(1).line.Count() {
						If tAddressString'="" Set tAddressString = tAddressString_";"
						Set tAddressString = tAddressString_tResource.address.GetAt(1).line.GetAt(j).value
					}
					Set tAddressString = tAddressString_"^^"_tResource.address.GetAt(1).city.value
					Set tAddressString = tAddressString_"^"_tResource.address.GetAt(1).state.value
					Set tAddressString = tAddressString_"^"_tResource.address.GetAt(1).postalCode.value
				}
				Do tDocument.SourcePatientInfo.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New("PID-11|"_tAddressString))
			}
		}
		
		Set tDocument.AvailabilityStatus = $Case(pDocumentReference.status.value, "current":"Approved", "superseded":"Deprecated", :"Approved")
		
		If $IsObject(pDocumentReference.class.coding)&&(pDocumentReference.class.coding.Count()) {
			Set tCode = pDocumentReference.class.coding.GetAt(1).code.value
			Set tDescription = pDocumentReference.class.coding.GetAt(1).display.value
			Set tSystem = pDocumentReference.class.coding.GetAt(1).system.value
			Set tDocument.ClassCode.Code = tCode
			Set tDocument.ClassCode.Description = tDescription
			Set tDocument.ClassCode.Scheme = ..GetCodingScheme("classCode", tCode, tSystem, tSystem)
		}
		
		Set tDocument.Title = pDocumentReference.description.value
		
		For i = 1:1:pDocumentReference.securityLabel.Count() {
			If pDocumentReference.securityLabel.GetAt(i).coding.Count() {
				Set tCodedValue = ##class(HS.IHE.XDSb.Types.CodedValue).%New()
				Set tCode = pDocumentReference.securityLabel.GetAt(i).coding.GetAt(1).code.value
				Set tDescription = pDocumentReference.securityLabel.GetAt(i).coding.GetAt(1).display.value
				Set tSystem = pDocumentReference.securityLabel.GetAt(i).coding.GetAt(1).system.value
				Set tCodedValue.Code = tCode
				Set tCodedValue.Description = tDescription
				Set tCodedValue.Scheme = ..GetCodingScheme("confidentialityCode", tCode, tSystem, tSystem)
				Do tDocument.ConfidentialityCode.Insert(tCodedValue)
			}
		}
		
		#; Convert FHIR indexed into an HL7 DTM YYYYMMDDHHMMSS in UTC for XDSb CreationTime.
		Set tIndexedUTC = ##class(HS.FHIR.Utils).ConvertToUTC(pDocumentReference.indexed.value)
		Set tDocument.CreationTime = $Extract($Translate(tIndexedUTC,"TZ-:. "),1,14)
		
		For i = 1:1:pDocumentReference.identifier.Count() {
			Set tIdentifier = pDocumentReference.identifier.GetAt(i)
			If $IsObject(tIdentifier.type) {
				Set tCode = ""
				Set tDisplay = ""
				If tIdentifier.type.coding.Count() {
					Set tCode = tIdentifier.type.coding.GetAt(1).code.value
					Set tDisplay = tIdentifier.type.coding.GetAt(1).display.value
				}
				Set tText = tIdentifier.type.text.value
				Set tValue = tIdentifier.value.value
				If (tCode="EntryUUID")||(tDisplay="EntryUUID")||(tText="EntryUUID") Set tDocument.EntryUUID = tIdentifier.value.value Continue
				If (tCode="LogicalUUID")||(tDisplay="LogicalUUID")||(tText="LogicalUUID") Set tDocument.LogicalUUID = tIdentifier.value.value Continue
				If (tCode="ObjectType")||(tDisplay="ObjectType")||(tText="ObjectType") Set tDocument.ObjectType = $Select(tValue="urn:uuid:7edca82f-054d-47f2-a032-9b2a5b5186c1":"Stable",1:"OnDemand") Continue
			}
		}
		
		Set tDocument.EventCodeList = ""
		
		If ($IsObject(pDocumentReference.content.GetAt(1).format))&&(pDocumentReference.content.GetAt(1).format.code.value'="") {
			Set tCode = pDocumentReference.content.GetAt(1).format.code.value
			Set tDescription = pDocumentReference.content.GetAt(1).format.display.value
			Set tSystem = pDocumentReference.content.GetAt(1).format.system.value
			Set tDocument.FormatCode.Code = tCode
			Set tDocument.FormatCode.Description = tDescription
			Set tDocument.FormatCode.Scheme = ..GetCodingScheme("formatCode", tCode, tSystem, tSystem)
		}
		
		Set tDocument.Hash = pDocumentReference.content.GetAt(1).attachment.hash.value
		
		Set tDocument.LanguageCode = pDocumentReference.content.GetAt(1).attachment.language.value
		
		Set tDocument.MimeType = pDocumentReference.content.GetAt(1).attachment.contentType.value
		
		Set tDocument.Comments = pDocumentReference.content.GetAt(1).attachment.title.value
		
		Set tDocument.URI = pDocumentReference.content.GetAt(1).attachment.url.value
		
		If $IsObject(pDocumentReference.type.coding)&&(pDocumentReference.type.coding.Count()) {
			Set tCode = pDocumentReference.type.coding.GetAt(1).code.value
			Set tDescription = pDocumentReference.type.coding.GetAt(1).display.value
			Set tSystem = pDocumentReference.type.coding.GetAt(1).system.value
			Set tDocument.TypeCode.Code = tCode
			Set tDocument.TypeCode.Description = tDescription
			Set tDocument.TypeCode.Scheme = ..GetCodingScheme("typeCode", tCode, tSystem, tSystem)
		}
		
		If $IsObject(pDocumentReference.context) {
			If $IsObject(pDocumentReference.context.facilityType.coding)&&(pDocumentReference.context.facilityType.coding.Count()) {
				Set tCode = pDocumentReference.context.facilityType.coding.GetAt(1).code.value
				Set tDescription = pDocumentReference.context.facilityType.coding.GetAt(1).display.value
				Set tSystem = pDocumentReference.context.facilityType.coding.GetAt(1).system.value
				Set tDocument.HealthcareFacilityTypeCode.Code = tCode
				Set tDocument.HealthcareFacilityTypeCode.Description = tDescription
				Set tDocument.HealthcareFacilityTypeCode.Scheme = ..GetCodingScheme("healthcareFacilityTypeCode", tCode, tSystem, tSystem)
			}
			If $IsObject(pDocumentReference.context.practiceSetting.coding)&&(pDocumentReference.context.practiceSetting.coding.Count()) {
				Set tCode = pDocumentReference.context.practiceSetting.coding.GetAt(1).code.value
				Set tDescription = pDocumentReference.context.practiceSetting.coding.GetAt(1).display.value
				Set tSystem = pDocumentReference.context.practiceSetting.coding.GetAt(1).system.value
				Set tDocument.PracticeSettingCode.Code = tCode
				Set tDocument.PracticeSettingCode.Description = tDescription
				Set tDocument.PracticeSettingCode.Scheme = ..GetCodingScheme("practiceSettingCode", tCode, tSystem, tSystem)
			}
			For i = 1:1:pDocumentReference.context.event.Count() {
				If pDocumentReference.context.event.GetAt(i).coding.Count() {
					Set tCodedValue = ##class(HS.IHE.XDSb.Types.CodedValue).%New()
					Set tCode = pDocumentReference.context.event.GetAt(i).coding.GetAt(1).code.value
					Set tDescription = pDocumentReference.context.event.GetAt(i).coding.GetAt(1).display.value
					Set tSystem = pDocumentReference.context.event.GetAt(i).coding.GetAt(1).system.value
					Set tCodedValue.Code = tCode
					Set tCodedValue.Description = tDescription
					Set tCodedValue.Scheme = ..GetCodingScheme("eventCodeList", tCode, tSystem, tSystem)
					Do tDocument.EventCodeList.Insert(tCodedValue)
				}
			}
		}
		
		// MHD maps DocumentReference masterIdentifier to XDSb Document Entry UniqueId.
		// Per http://hl7.org/fhir/datatypes.html#identifier, "If the identifier value itself
		// is naturally a globally unique URI (e.g. an OID, a UUID, or a URI with no trailing
		// local part), then the system SHALL be "urn:ietf:rfc:3986", and the URI is in the
		// value (OIDs and UUIDs using urn:oid: and urn:uuid: - see examples)". Per MHD STU3
		// CP-ITI-943-01-ballot42, if the uniqueId *does* have a trailing part, presumably for
		// an extension value (e.g., for OID^extension), then the URI will be placed in the
		// masterIdentifier system property and the extension will be placed in the masterIdentifier
		// value property.
		If ($IsObject(pDocumentReference.masterIdentifier))&&(pDocumentReference.masterIdentifier.value.value'="") {
			// Since the DocumentReference has already been through validation, assume
			// that if masterIdentifier is present then it has both system and value
			// and that system is a valid value.
			Set tValue = pDocumentReference.masterIdentifier.value.value
			Set tSystem = pDocumentReference.masterIdentifier.system.value
			If (##class(HS.HC.Util).IsOID(tValue))||(##class(HS.HC.Util).IsUUID(tValue)) {
				If $Extract(tValue,1,8)="urn:oid:" {
					Set tUniqueId = $Extract(tValue,9,*)
				} ElseIf $Extract(tValue,1,9)="urn:uuid:" {
					Set tUniqueId = $Extract(tValue,10,*)
				} Else {
					Set tUniqueId = tValue
				}
			} Else {
				If $Extract(tSystem,1,8)="urn:oid:" Set tSystem = $Extract(tSystem,9,*)
				Set tUniqueId = tSystem_"^"_tValue
			}
		} Else {
			Set tUniqueId = ""
		}
		Set tDocument.UniqueId = tUniqueId
		
		Set tDocument.Version = 1
		
		Set tDocument.XOP = ""
		
		#; RepositoryUniqueId not really relevant.  Maybe it should be an extension?
		Set tDocument.RepositoryUniqueId = ""
		
		Do pXDSbQueryResponse.Documents.Insert(tDocument)
		
	} Catch eException {
		$$$LOGERROR(eException.DisplayString())
		Set tSC = eException.AsStatus()	
	}
	
	Quit tSC
}

Method DocManifestToXDSbResponse(pDocumentManifest As HS.FHIR.vSTU3.Model.Resource.DocumentManifest, ByRef pXDSbQueryResponse As HS.Message.IHE.XDSb.QueryResponse) As %Status
{
	Set tSC = $$$OK
	
	Try {
		#; This method assumes that a returned DocumentManifest has one content
		#; object, and that that content object has one pReference object.
		
		Set tSubmission = ##class(HS.Message.IHE.XDSb.Submission).%New()
		
		For i = 1:1:pDocumentManifest.contained.Count() {
			Set tSC = ##class(HS.FHIR.Utils).GetResourceFromContainer(pDocumentManifest.contained.GetAt(i), .tResource)
			If $$$ISERR(tSC) Quit
			Set tResourceType = tResource.%ClassName(0)
			If tResourceType="Practitioner" {
				Set tFirstName = ""
				Set tLastName = ""
				If ($IsObject(tResource.name)) {
					If tResource.name.Count()>0 {
						If tResource.name.GetAt(1).given.Count() Set tFirstName = tResource.name.GetAt(1).given.GetAt(1).value
						If tResource.name.GetAt(1).family.value'="" Set tLastName = tResource.name.GetAt(1).family.value
						If (tFirstName'="")||(tLastName'="") {
							Set tAuthor = ##class(HS.IHE.XDSb.Types.Author).%New()
							Set tAuthor.AuthorPerson = "^"_tLastName_"^"_tFirstName_"^^^"
							Do tSubmission.Author.Insert(tAuthor)
							Set tSlot = ##class(HS.IHE.XDSb.Types.Slot).%New()
							Set tSlot.Name = "authorPerson"
							Do tSlot.ValueList.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New(tAuthor.AuthorPerson))
							Do tSubmission.SubmissionSlots.Insert(tSlot)
						}
					}
				}
			} ElseIf tResourceType="Patient" {
				#; Loop through identifiers to get PatientId (MPIID) and SourcePatientId.
				For j = 1:1:tResource.identifier.Count() {
					Set tIdentifier = tResource.identifier.GetAt(j)
					If $IsObject(tIdentifier.type) {
						Set tCode = ""
						Set tDisplay = ""
						If tIdentifier.type.coding.Count() {
							Set tCode = tIdentifier.type.coding.GetAt(1).code.value
							Set tDisplay = tIdentifier.type.coding.GetAt(1).display.value
						}
						Set tText = tIdentifier.type.text.value
						Set tValue = tIdentifier.value.value
						Set tSystem = tIdentifier.system.value
						If $Extract($ZConvert(tSystem,"L"),1,8)="urn:oid:" Set tSystem = $Extract(tSystem,9,*)
						Set tIdString = tIdentifier.value.value_"^^^&"_tSystem_"&ISO"
						If (tCode="MPIID")||(tDisplay="MPIID")||(tText="MPIID")||(tResource.identifier.Count()=1) {
							Set tSubmission.PatientId = tIdString
						}
					}
				}
			}
		}
		
		Set tSubmission.AvailabilityStatus = $Case(pDocumentManifest.status.value, "current":"Approved", "superseded":"Submitted", :"Approved")
		
		Set tSubmission.Comments = ""
		
		Set tSourceSystemOID = ""
		Set tSourceSystem = pDocumentManifest.source.value
		If ##class(HS.HC.Util).IsOID(tSourceSystem) {
			If $Extract($ZConvert(tSourceSystem,"L"),1,8)="urn:oid:" {
				Set tSourceSystemOID = $Extract(tSourceSystem,9,*)
			}
		} ElseIf ##class(HS.HC.Util).IsURL(tSourceSystem) {
			Set tSourceSystemOID = ##class(HS.Data.OIDMap).GetOIDForURL(tSourceSystem)
		}
		
		Set tSubmission.SourceId = tSourceSystemOID
		
		#; Convert FHIR created into an HL7 DTM YYYYMMDDHHMMSS in UTC for XDSb SubmissionTime.
		Set tCreatedUTC = ##class(HS.FHIR.Utils).ConvertToUTC(pDocumentManifest.created.value)
		Set tSubmission.SubmissionTime = $Extract($Translate(tCreatedUTC,"TZ-:. "),1,14)
		
		Set tSlot = ##class(HS.IHE.XDSb.Types.Slot).%New()
		Set tSlot.Name = "submissionTime"
		Do tSlot.ValueList.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New(tSubmission.SubmissionTime))
		Do tSubmission.SubmissionSlots.Insert(tSlot)
		
		For i = 1:1:pDocumentManifest.identifier.Count() {
			Set tIdentifier = pDocumentManifest.identifier.GetAt(i)
			If $IsObject(tIdentifier.type) {
				Set tCode = ""
				Set tDisplay = ""
				If tIdentifier.type.coding.Count() {
					Set tCode = tIdentifier.type.coding.GetAt(1).code.value
					Set tDisplay = tIdentifier.type.coding.GetAt(1).display.value
				}
				Set tText = tIdentifier.type.text.value
				Set tValue = tIdentifier.value.value
				If (tCode="EntryUUID")||(tDisplay="EntryUUID")||(tText="EntryUUID") Set tSubmission.EntryUUID = tIdentifier.value.value Continue
				If (tCode="ObjectType")||(tDisplay="ObjectType")||(tText="ObjectType") Set tSubmission.ObjectType = $Select(tValue="urn:uuid:7edca82f-054d-47f2-a032-9b2a5b5186c1":"Stable",1:"OnDemand") Continue
			}
		}
		
		Set tSubmission.Title = pDocumentManifest.description.value
		
		If $IsObject(pDocumentManifest.type.coding)&&(pDocumentManifest.type.coding.Count()) {
			Set tCode = pDocumentManifest.type.coding.GetAt(1).code.value
			Set tDescription = pDocumentManifest.type.coding.GetAt(1).display.value
			Set tSystem = pDocumentManifest.type.coding.GetAt(1).system.value
			Set tSubmission.ContentTypeCode.Code = tCode
			Set tSubmission.ContentTypeCode.Description = tDescription
			Set tSubmission.ContentTypeCode.Scheme = ..GetCodingScheme("contentTypeCode", tCode, tSystem, tSystem)
		}
		
		Set tSlot = ##class(HS.IHE.XDSb.Types.Slot).%New()
		Set tSlot.Name = "codingScheme"
		Do tSlot.ValueList.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New(tSubmission.ContentTypeCode.Scheme))
		Do tSubmission.SubmissionSlots.Insert(tSlot)
		
		Set tId = pDocumentManifest.masterIdentifier.value.value
		If $Extract($ZConvert(tId,"L"),1,8)="urn:oid:" Set tId = $Extract(tId,9,*)
		Set tSubmission.UniqueId = tId
		
		Do pXDSbQueryResponse.Submissions.Insert(tSubmission)
		
	} Catch eException {
		$$$LOGERROR(eException.DisplayString())
		Set tSC = eException.AsStatus()	
	}
	
	Quit tSC
}

ClassMethod GetCodingScheme(pCodeType As %String, pCode As %String, pSystem As %String, pDefault As %String = "") As %String
{
	Set tScheme = ""
	
	Set tOrigForm = ""
	
	If ##class(HS.HC.Util).IsOID(.pSystem,0) {
		// pSystem is an OID. See if there is a row in the Coded Entry table that matches
		// that OID+codetype+code. NOTE that in the cases where the same codetype+code has
		// two rows in the Coded Entry table, the OID version of the Scheme will be used.
		Set tOrigForm = "OID"
		Set tOID = pSystem
		If $Extract(tOID,1,8)="urn:oid:" Set tOID = $Extract(tOID,9,*)
		Set tObject = ##class(HS.IHE.CodedEntry).UniqueIndexOpen(pCodeType, tOID, pCode)
		If $IsObject($Get(tObject)) {
			Set tScheme = tObject.CodingScheme
		} Else {
			// If no row with OID+codetype+code is found, then try to get Scheme from the OID Registry.
			Set tScheme = ##class(HS.Data.OIDMap).GetCodeForOID(tOID,"")
			Set tScheme = $Case(tScheme, "LN":"LOINC", "SCT":"SNOMED", :tScheme)
		}
	} ElseIf ##class(HS.HC.Util).IsURL(.pSystem) {
		// pSystem is a URL. Try to find an OID in the OID Registry for that URL.
		Set tOrigForm = "URL"
		Set tOID = ##class(HS.Data.OIDMap).GetOIDForURL(pSystem)
		If tOID'=pSystem {
			// Found an OID in the OID Registry. See if there is a row in the Coded Entry
			// table that matches that OID. NOTE that in the cases where the same code
			// has two rows in the Coded Entry table, the OID version of the Scheme will
			// be used.
			Set tObject = ##class(HS.IHE.CodedEntry).UniqueIndexOpen(pCodeType, tOID, pCode)
			If $IsObject($Get(tObject)) {
				Set tScheme = tObject.CodingScheme
			} Else {
				// If no row with OID+codetype+code is found, then try to get Scheme from the OID Registry.
				Set tScheme = ##class(HS.Data.OIDMap).GetCodeForOID(tOID,"")
				Set tScheme = $Case(tScheme, "LN":"LOINC", "SCT":"SNOMED", :tScheme)
			}
		} Else {
			// Did not find OID in the OID Registry for this URL. For now we are assuming
			// that every row in the OID Registry has an OID.
			Set tScheme = ""
		}
	} ElseIf ##class(HS.HC.Util).IsUUID(.pSystem,0) {
		// Unlikely we'll get pSystem as a UUID, but providing for it anyway.
		Set tOrigForm = "UUID"
		Set tSystem = pSystem
		If $Extract(tSystem,1,9)="urn:uuid:" Set tScheme = $Extract(tSystem,10,*)
	}
	
	If tScheme="" {
		If (pSystem="http://connectathon.ihe")||(pSystem="urn:oid:1.3.6.1.4.1.21367.2017.3") {
			Set tScheme = "Connect-a-thon "_pCodeType_"s"
		} ElseIf pSystem="urn:oid:1.3.6.1.4.1.19376.1.2.3" {
			For tText = "IHE PCC", "IHE BPPC", "IHE-PCC", "IHE-LAB" {
				Set tObject = ##class(HS.IHE.CodedEntry).UniqueIndexOpen(pCodeType, tText, pCode)
				If $IsObject($Get(tObject)) {
					Set tScheme = tObject.CodingScheme
					Quit
				}
			}
		} ElseIf (pSystem="http://snomed.info/sct")||(pSystem="urn:oid:2.16.840.1.113883.6.96") {
			For tText = "2.16.840.1.113883.6.96", "SNOMED", "SRT", "SNM3" {
				Set tObject = ##class(HS.IHE.CodedEntry).UniqueIndexOpen(pCodeType, tText, pCode)
				If $IsObject($Get(tObject)) {
					Set tScheme = tObject.CodingScheme
					Quit
				}
			}
		} ElseIf pSystem="http://hl7.org/fhir/v3/Confidentiality" {
			Set tScheme = "2.16.840.1.113883.5.25"
		} ElseIf pSystem="http://dicom.nema.org/resources/ontology/DCM" {
			For tText = "1.2.840.10008.2.6.1", "DCM" {
				Set tObject = ##class(HS.IHE.CodedEntry).UniqueIndexOpen(pCodeType, tText, pCode)
				If $IsObject($Get(tObject)) {
					Set tScheme = tObject.CodingScheme
					Quit
				}
			}
		} ElseIf pSystem="urn:oid:2.16.840.1.113883.3.88" {
			For tText = "2.16.840.1.113883.3.88", "HITSP" {
				Set tObject = ##class(HS.IHE.CodedEntry).UniqueIndexOpen(pCodeType, tText, pCode)
				If $IsObject($Get(tObject)) {
					Set tScheme = tObject.CodingScheme
					Quit
				}
			}
		}
	}
	
	If tScheme="" Set tScheme = pDefault
	
	Quit tScheme
}

Method RetrieveResponseToXDSbResponse(pMHDRetrieveResponse As HS.Message.FHIR.Response, ByRef pXDSbRetrieveResponse As HS.Message.IHE.XDSb.RetrieveResponse) As %Status
{
	Set tSC = $$$OK
	
	Try {
		#dim tBinary As HS.FHIR.vSTU3.Model.Resource.Binary
		
		Set tSC = ##class(HS.FHIR.Utils).FHIRToHSFHIR(pMHDRetrieveResponse.ContentType, pMHDRetrieveResponse.Payload, .tBinary, "HS.FHIR.vSTU3.Model.Resource")
		If $$$ISERR(tSC) Quit
		
		Set pXDSbRetrieveResponse = ##class(HS.Message.IHE.XDSb.RetrieveResponse).%New()
		Set tDocument = ##class(HS.Message.IHE.XDSb.Document).%New()
		Set tDocument.UniqueId = tBinary.id.value
		If tBinary.contentType.value="text/xml" {
			Set tSC = tDocument.BodyCharacter.Write(tBinary.content.value)
		} Else {
			Set tSC = tDocument.Body.Write(tBinary.content.value)
		}
		Do pXDSbRetrieveResponse.Documents.Insert(tDocument)
		
		Set pXDSbRetrieveResponse.DocType = "RetrieveDocumentSetResponse"
		Set pXDSbRetrieveResponse.Name = "XDSb_RetrieveResponse"
		
		Set tStreamItem = ##class(HS.IHE.Common.Messages.MIMEAttachment).%New()
		Set tStreamItem.ContentId = tBinary.id.value
		Set tStreamItem.ContentType = tBinary.contentType.value
		Set tStreamItem.ContentTransferEncoding = "binary"
		Do tStreamItem.Body.Write(tBinary.content.value)
		
		Do pXDSbRetrieveResponse.StreamCollection.Insert(tStreamItem)
		
	} Catch eException {
		$$$LOGERROR(eException.DisplayString())
		Set tSC = eException.AsStatus()	
	}
	
	Quit tSC
}

Method AddURLTokenParam(pParamName As %String = "", pParamValues As %ListOfDataTypes, ByRef pMHDRequest As HS.Message.FHIR.Request) As %Status
{
	Set tSC = $$$OK
	
	If pParamName'=""{
		For i = 1:1:pParamValues.Count() {
			Set tIdentifier = $Piece(pParamValues.GetAt(i),"^",1)
			Set tSystem = $Piece(pParamValues.GetAt(i),"^",3)
			If (tSystem'="")&&($Extract(tSystem,1,8)'="urn:oid:")&&(##class(HS.HC.Util).IsOID(tSystem)) Set tSystem = "urn:oid:"_tSystem
			Set tSC = pMHDRequest.SetParameter(pParamName, tSystem_$S(tSystem="":"",1:"|")_tIdentifier)
		}
	}
	
	Quit tSC
}

/// UpdateRegistryService updates - If needed - the info in the RegistryService
/// property.  Update is based on pService, the ServiceName setting, and the
/// info currently in RegistryService.  The ServiceName setting is the default
/// service name to use, and may be overridden by pRequest.AdditionalInfo.GetAt("ServiceName").
/// If RegistryService is updated, then the properties on this BO's TCP adapter
/// are also updated.
/// If Service Registry settings on a TCP service are changed, then this BO
/// should be restarted to guarantee that the changes are effective at run time.
Method UpdateRegistryService(pService)
{
	Set:pService="" pService=..ServiceName
	If $lg(..RegistryService)'=pService,pService'="" {
		Set tRegistryService = ##class(HS.Registry.Service.HTTP).EndPointForNameType(pService,"HTTP")
		If $IsObject(tRegistryService) {
			Set tDeviceOID=##class(HS.Data.OIDMap).OIDForType(tRegistryService.OIDMapCode.GetAt("Device"),"Device")
			Set ..RegistryService = $lb(tRegistryService.Name,tRegistryService.%Id(),tDeviceOID,,tRegistryService.OIDMapCode.GetAt("ReceivingApplication"),tRegistryService.OIDMapCode.GetAt("ReceivingFacility"),tRegistryService.Host,tRegistryService.Port,,tRegistryService.SSLConfig,tRegistryService.URL)
		}
	}
}

}
