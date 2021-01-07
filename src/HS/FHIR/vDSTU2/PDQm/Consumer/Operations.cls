Include HS.HC

/// HS.FHIR.vDSTU2.PDQm.Consumer.Operations takes an HS PatientSearchRequest message as input,
/// converts it to an HS FHIR request message, and sends it to the specified end point
/// over HTTP.
Class HS.FHIR.vDSTU2.PDQm.Consumer.Operations Extends (HS.FHIR.REST.Operation, HS.HC.Util.Trace.Helper)
{

Parameter INVOCATION = "Queue";

Parameter SETTINGS = "FHIRFormat";

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

/// The FHIR format to use for the request ContentType and Accept headers.
/// This setting may be overridden by adding an AdditionalInfoItem named
/// _format to the PatientSearchRequest.  Valid values for the AdditionalInfoItem
/// are: "xml", "json", "applicaton/xml+fhir", "application/json+fhir",
/// "application/fhir+xml", and "application/fhir+json".
Property FHIRFormat As %String(DISPLAYLIST = ",XML,JSON", VALUELIST = ",XML,JSON") [ InitialExpression = "XML" ];

XData MessageMap
{
<MapItems>
  <MapItem MessageType="HS.Message.PatientSearchRequest">
    <Method>PDQmRequest</Method>
  </MapItem>
</MapItems>
}

Method OnMessage(pRequest As %Library.Persistent, Output pResponse As %Library.Persistent) As %Status
{
	Set tSC = $$$OK
	
	Try {
		If pRequest.%IsA("HS.Message.FHIR.Request") {
			$$$HSTRACE("FHIR Request", "pRequest", pRequest)
			If (pRequest.Type="Patient")&&((pRequest.Interaction = "search")||( pRequest.Interaction = "read")) {
				Set tSC = ..FHIRRequest(pRequest, .pResponse)
			} ElseIf pRequest.AdditionalInfo.GetAt("GetURL")'="" {
				Set tSC = ..FHIRRequest(pRequest, .pResponse)
			} ElseIf pRequest.Type'="Patient" {
				Set tSC = $$$ERROR($$$GeneralError, "Invalid resource type "_pRequest.Type_" on PDQm request - must be Patient")
			} ElseIf '((pRequest.Interaction = "search")||( pRequest.Interaction = "read")) {
				Set tSC = $$$ERROR($$$GeneralError, "Invalid interaction "_pRequest.Interaction_" on PDQm request - must be search or read")
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
		
	} Catch eException {
		Set tSC = eException.AsStatus()
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

/// PDQmRequest takes an HS PatientSearchRequest message as input, transforms
/// it into an HS FHIR request message, calls OnMessage to send it on to
/// its intended target, receives the HS FHIR response, transforms it
/// into an HS PatientSearchResponse message, and returns it.
Method PDQmRequest(pRequest As HS.Message.PatientSearchRequest, ByRef pResponse As HS.Message.PatientSearchResponse) As %Status
{
	Set tSC = $$$OK
	
	Try {
		#dim tPDQmRequest As HS.Message.FHIR.Request
		#dim tPDQmResponse As HS.Message.FHIR.Response
		
		#; GetURL overrides anything else in the PatientSearchRequest.
		#; PDQm Search is supported via GetURL and via PatientSearchRequest properties.
		#; PDQm Retrieve is supported ONLY via GetURL.
		If pRequest.AdditionalInfo.GetAt("GetURL")'="" {
			Set tPDQmRequest = ##class(HS.Message.FHIR.Request).%New()
			Do tPDQmRequest.AdditionalInfo.SetAt(pRequest.AdditionalInfo.GetAt("GetURL"), "GetURL")
			If pRequest.AdditionalInfo.GetAt("ServiceName")'="" {
				Do tPDQmRequest.AdditionalInfo.SetAt(pRequest.AdditionalInfo.GetAt("ServiceName"), "ServiceName")
			}
		} Else {
			Set tSC = ..PatientSearchToPDQmRequest(pRequest, .tPDQmRequest)
		}
		If $$$ISERR(tSC) Quit
		
		Set tSC = ..OnMessage(tPDQmRequest, .tPDQmResponse)
		If $$$ISERR(tSC) Quit
		
		Do tPDQmRequest.AdditionalInfo.SetAt($system.INetInfo.HostNameToAddr($system.INetInfo.LocalHostName()),"FromHost")
		Do tPDQmRequest.AdditionalInfo.SetAt($ListGet(..RegistryService,7),"ToHost")
		If pRequest.AdditionalInfo.GetAt("GetURL")="" {
			Set tUrl = tPDQmRequest.BaseURL
			If $Extract(tUrl,*)'="/" Set tUrl = tUrl_"/"
			Set tParams = ""
			Set tKey = ""
			For {
				Set tValue = tPDQmRequest.Parameters.GetNext(.tKey)
				If tKey="" Quit
				If tParams'="" Set tParams = tParams_"&"
				Set tParamValue = ""
				For i = 1:1:$ListLength(tValue) {
					If tParamValue'="" Set tParamValue = tParamValue_","
					Set tParamValue = tParamValue_$ListGet(tValue,i)
				}
				Set tParams = tParams_tKey_"="_tParamValue
			}
			Set tUrl = tUrl_tParams
		} Else {
			Set tUrl = pRequest.AdditionalInfo.GetAt("GetURL")
		}
		Do tPDQmRequest.AdditionalInfo.SetAt(tUrl, "Url")
		Set tHeaders = ""
		Set tKey = ""
		For {
			Set tValue = tPDQmRequest.Headers.GetNext(.tKey)
			If tKey="" Quit
			If $ZConvert(tKey,"U")="HOST" Continue
			If tHeaders'="" Set tHeaders = tHeaders_";"
			Set tHeaders = tHeaders_tKey_"="_tValue
		}
		Do tPDQmRequest.AdditionalInfo.SetAt(tHeaders, "Headers")
		//Do $$$ATNAEvent("PDQmConsumer",tPDQmRequest,tPDQmResponse,tSC)
		
		Set tSC = ..PDQmResponseToPatientResponse(tPDQmResponse, .pResponse)
		If $$$ISERR(tSC) Quit
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// PatientSearchToPDQmRequest takes an HS PatientSearchRequest as input,
/// transforms it into an HS FHIR request, and returns it.
Method PatientSearchToPDQmRequest(pPatientSearchRequest As HS.Message.PatientSearchRequest, pPDQmRequest As HS.Message.FHIR.Request) As %Status
{
	Set tSC = $$$OK
	
	Try {
		#; Update the cached service entry data If needed.
		Do ..UpdateRegistryService(pPatientSearchRequest.AdditionalInfo.GetAt("ServiceName"))
		
		Set pPDQmRequest = ##class(HS.Message.FHIR.Request).%New()
		
		#; SEARCH PARAMETERS
		#; _count - The number of search matches per page.  If the number
		#;   of matches is less than _count then no continuation links are
		#;   returned.  If the number of matches is greater than _count
		#;   then matches (_count*(page-1))+1 through (_count*(page-1))+_count
		#;   are returned and first, previous, next and last links are
		#;   included in the response.  _count is honored only on an
		#;   initial query and not on a continuation query.  For continuation,
		#;   _count is taken from _count from the initial query.
		#; page - The page number to consider the current page.  Page size
		#;   is determined by _count.  If _count is specified but page is
		#;   not specified then page is set to 1.  If page is greater than
		#;   2 and there is less than page number of pages then page is
		#;   set to the last page.
		#; _id (Patient resource id)
		#; identifier - Assigning authority OID plus identifier, for example
		#;   identifier=urn:oid:1.2.3.4|145&identifier=urn:oid:2.16.840.1.113883.4.1|123456789.
		#;   Multiple identifier parameters constitute an AND search, meaning
		#;   a given patient must have all the specified identifiers.
		#; family (string - must support :exact)
		#; given (string - must support :exact)
		#; birthdate (YYYY, YYYY-MM, YYYY-MM-DD)
		#; address (string - must support :exact)
		#; address-city (string - must support :exact)
		#; address-state (string - must support :exact)
		#; address-postalcode (string - must support :exact)
		#; address-county (string - must support :exact)
		#; telecom
		#; gender
		
		Set tExact = $Select(pPatientSearchRequest.AdditionalInfo.GetAt("ExactMatch"):"exact",1:"")
		
		If pPatientSearchRequest.AssigningAuthority'="" && (pPatientSearchRequest.MRN'="") {
			Set tURI = ##class(HS.Data.OIDMap).GetURIForCode(pPatientSearchRequest.AssigningAuthority, "")
			If tURI="" Set tSC = $$$ERROR($$$GeneralError, "No URI defined in OID Registry for specified Assigning Authority "_pPatientSearchRequest.AssigningAuthority) Quit
			Do pPDQmRequest.SetParameter("identifier", tURI_"|"_pPatientSearchRequest.MRN)
		} ElseIf pPatientSearchRequest.AssigningAuthority="" && (pPatientSearchRequest.MRN'="") {
			#; HealthShare FHIR server logic does not support MRN + no AA search, but some other server might.
			Do pPDQmRequest.SetParameter("identifier", "|"_pPatientSearchRequest.MRN)
		} ElseIf pPatientSearchRequest.MPIID'="" {
			Do pPDQmRequest.SetParameter("identifier", "urn:oid:"_$$$AffinityDomainOID_"|"_pPatientSearchRequest.MPIID)
		} Else {
			Do pPDQmRequest.SetParameter("family", pPatientSearchRequest.LastName, tExact)
			Do pPDQmRequest.SetParameter("given", pPatientSearchRequest.FirstName, tExact)
			Do pPDQmRequest.SetParameter("given", pPatientSearchRequest.MiddleName, tExact)
			
			If pPatientSearchRequest.DOB'="" Do pPDQmRequest.SetParameter("birthdate", $ZDT(pPatientSearchRequest.DOB,3))
			
			If pPatientSearchRequest.Sex'="" {
				Set tSex = $Case(pPatientSearchRequest.Sex, "M":"male", "F":"female", "O":"other", "U":"unknown", :"unknown")
				Do pPDQmRequest.SetParameter("gender", tSex)
			}
			
			Set tAddresses = ""
			If pPatientSearchRequest.Addresses.Count()>0 {
				For i = 1:1:pPatientSearchRequest.Addresses.Count() {
					If tAddresses'="" {
						If $Extract(tAddresses)'="(" Set tAddresses = "("_tAddresses
						Set tAddresses = tAddresses_","
					}
					Set tAddressObj = pPatientSearchRequest.Addresses.GetAt(i)
					If tAddressObj.StreetLine'="" {
						Set tAddresses = tAddressObj.StreetLine
						If (tAddressObj.City'="")||(tAddressObj.State'="")||(tAddressObj.PostalCode'="") Set tAddress = tAddress_","_tAddressObj.City
						If (tAddressObj.State'="")||(tAddressObj.Zip'="") Set tAddress = tAddress_","_tAddressObj.State
						If tAddressObj.PostalCode'="" Set tAddresses = tAddresses_","_tAddressObj.PostalCode
					} Else {
						If (tAddressObj.City'="") Do pPDQmRequest.SetParameter("address-city", tAddressObj.City, tExact)
						If (tAddressObj.State'="") Do pPDQmRequest.SetParameter("address-state", tAddressObj.State, tExact)
						If (tAddressObj.PostalCode'="") Do pPDQmRequest.SetParameter("address-postalcode", tAddressObj.PostalCode, tExact)
						If (tAddressObj.Country'="") Do pPDQmRequest.SetParameter("address-country", tAddressObj.Country, tExact)
					}
				}
				If $Extract(tAddresses)="(" Set tAddresses = tAddresses_")"
			} ElseIf pPatientSearchRequest.Street'="" {
				Set tAddresses = pPatientSearchRequest.Street
				If (pPatientSearchRequest.City'="")||(pPatientSearchRequest.State'="")||(pPatientSearchRequest.Zip'="") Set tAddresses = tAddresses_","_pPatientSearchRequest.City
				If (pPatientSearchRequest.State'="")||(pPatientSearchRequest.Zip'="") Set tAddresses = tAddresses_","_pPatientSearchRequest.State
				If pPatientSearchRequest.Zip'="" Set tAddresses = tAddresses_","_pPatientSearchRequest.Zip
			} Else {
				If (pPatientSearchRequest.City'="") Do pPDQmRequest.SetParameter("address-city", pPatientSearchRequest.City, tExact)
				If (pPatientSearchRequest.State'="") Do pPDQmRequest.SetParameter("address-state", pPatientSearchRequest.State, tExact)
				If (pPatientSearchRequest.Zip'="") Do pPDQmRequest.SetParameter("address-postalcode", pPatientSearchRequest.Zip, tExact)
			}
			If tAddresses'="" Do pPDQmRequest.SetParameter("address", tAddresses, tExact)
			
			Set tTelecoms = ""
			If pPatientSearchRequest.Telecoms.Count()>0 {
				For i = 1:1:pPatientSearchRequest.Telecoms.Count() {
					If tTelecoms'="" {
						If $Extract(tTelecoms)'="(" Set tTelecoms = "("_tTelecoms
						Set tTelecoms = tTelecoms_","
					}
					Set tTelecomObj = pPatientSearchRequest.Telecoms.GetAt(i)
					If tTelecomObj.PhoneNumber'="" {
						Set tTelecom = tTelecomObj.PhoneNumber
						Set tSystem = "phone"
					} ElseIf tTelecomObj.Email'="" {
						Set tTelecom = tTelecomObj.Email
						Set tSystem = "email"
					} ElseIf tTelecomObj.URL'="" {
						Set tTelecom = tTelecomObj.URL
						Set tSystem = "url"
					}
					//Set tTelecom = tSystem_"|"_tTelecom
					Set tTelecoms = tTelecoms_tTelecom
				}
				If $Extract(tTelecoms)="(" Set tTelecoms = tTelecoms_")"
			} Else {
				If pPatientSearchRequest.Telephone'="" {
					Set tTelecom = pPatientSearchRequest.Telephone
					Set tSystem = "phone"
					//Set tTelecom = tSystem_"|"_tTelecom
					Set tTelecoms = tTelecom
				}
				If pPatientSearchRequest.BusinessPhone'="" {
					If $Extract(tTelecoms)'="(" Set tTelecoms = "("_tTelecoms_","
					Set tTelecom = pPatientSearchRequest.BusinessPhone
					Set tSystem = "phone"
					//Set tTelecom = tSystem_"|"_tTelecom
					Set tTelecoms = tTelecoms_tTelecom
					If $Extract(tTelecoms)="(" Set tTelecoms = tTelecoms_")"
				}
			}
			If tTelecoms'="" Do pPDQmRequest.SetParameter("telecom", tTelecoms)
			
			If pPatientSearchRequest.SSN'="" {
				Do pPDQmRequest.SetParameter("identifier", "http://hl7.org/fhir/sid/us-ssn|"_pPatientSearchRequest.SSN)
			}
		}
		
		Do pPDQmRequest.SetParameter("_queryId", pPatientSearchRequest.AdditionalInfo.GetAt("queryId"))
		Do pPDQmRequest.SetParameter("_count", pPatientSearchRequest.MaxMatches)
		Do pPDQmRequest.SetParameter("page", pPatientSearchRequest.AdditionalInfo.GetAt("page"))
		
		Set tFormat = $ZConvert(pPatientSearchRequest.AdditionalInfo.GetAt("_format"),"L")
		If tFormat="" Set tFormat = $ZConvert(..FHIRFormat, "L")
		Do ##class(HS.FHIR.Utils).GetValidFormats("Parameter", .tFormats)
		If '$Data(tFormats(tFormat)) Set tSC = $$$ERROR($$$GeneralError, "Invalid _format value "_tFormat_" specified") $$$ThrowOnError(tSC)
		Do pPDQmRequest.SetParameter("_format", tFormat)
		Set pPDQmRequest.ContentType = tFormats(tFormat)
		
		#; Setting this header for ATNA audit logging purposes.
		#; Should end up in ParticipantObjectDetail.
		Do pPDQmRequest.Headers.SetAt(tFormat, "HTTP_ACCEPT")
		
		#; Parameter known as targetSystem in DSTU1 is now folded into
		#; the identifier parameter.  A targetSystem is indicated by
		#; and identifier parameter value that is a system but no MRN
		#; and with a trailing vertical bar.  May be multiple values.
		#; Pass multiple values in single identifier parameter.
		If pPatientSearchRequest.AdditionalInfo.IsDefined("ScopingOrganizations") {
			Set tTargetSystem = ""
			Set tKey = ""
			For {
				Set tKey = pPatientSearchRequest.AdditionalInfo.Next(tKey)
				If tKey="" Quit
				If tKey'["scopingOrganization_" Continue
				Set tCode = $Piece(tKey,"scopingOrganization_",2)
				If tCode="" Set tSC = $$$ERROR($$$GeneralError, "Scoping Code missing from key") Quit
				Set tURI = ##class(HS.Data.OIDMap).GetURIForCode(tCode, "")
				If tURI="" Set tSC = $$$ERROR($$$GeneralError, "Scoping URI not defined in OID Registry for:"_tCode) Quit
				If tTargetSystem'="" Set tTargetSystem = tTargetSystem_","
				Set tTargetSystem = tTargetSystem_tURI_"|"
			}
			If tTargetSystem'="" Do pPDQmRequest.SetParameter("identifier", tTargetSystem)
		}
		$$$ThrowOnError(tSC)
		
		#; PDQm Retrieve (read) is supported only via GetURL.
		Set pPDQmRequest.Interaction = "search"
		Set pPDQmRequest.Type = "Patient"
		Do pPDQmRequest.AdditionalInfo.SetAt(pPatientSearchRequest.AdditionalInfo.GetAt("ServiceName"),"ServiceName")
		
	} Catch eException {
		$$$LOGERROR(eException.DisplayString())
		Set tSC = eException.AsStatus()	
	}
	
	Quit tSC
}

/// PDQmResponseToPatientResponse takes an HS FHIR response as input,
/// transforms it into an HS PatientSearchResponse, and returns it.
Method PDQmResponseToPatientResponse(pPDQmResponse As HS.Message.FHIR.Response, ByRef pPatientSearchResponse As HS.Message.PatientSearchResponse) As %Status
{
	Set tSC = $$$OK
	
	Try {
		#dim tEntry As HS.FHIR.vDSTU2.Model.Resource.Bundle.Entry
		#dim tPatientResource As HS.FHIR.vDSTU2.Model.Resource.Patient
		
		Set pPatientSearchResponse = ##class(HS.Message.PatientSearchResponse).%New()
		Set pPatientSearchResponse.ErrStatus = $$$OK
		
		Do pPatientSearchResponse.AdditionalInfo.SetAt(pPDQmResponse.Status, "HTTPStatus")
		
		Set tSC = ##class(HS.FHIR.Utils).FHIRToHSFHIR(pPDQmResponse.ContentType, pPDQmResponse.Payload, .tHSFHIRObj, "HS.FHIR.vDSTU2.Model.Resource")
		If $$$ISERR(tSC) Set pPatientSearchResponse.ErrStatus = tSC Quit
		
		If (tHSFHIRObj.%ClassName(0)'="Bundle")&&(tHSFHIRObj.%ClassName(0)'="Patient")&&(tHSFHIRObj.%ClassName(0)'="OperationOutcome") {
			Set pPatientSearchResponse.ErrStatus = $$$ERROR($$$GeneralError, "Unexpected resource type "_tHSFHIRObj.%ClassName(0)_" in PDQm return payload")
			Quit
		}
		
		If tHSFHIRObj.%ClassName(0)="OperationOutcome" {
			Do ..ErrorFromOperationOutcome(tHSFHIRObj, .tErrorMessage)
			Set pPatientSearchResponse.ErrStatus = $$$ERROR($$$GeneralError, tErrorMessage)
			Quit
		} ElseIf (tHSFHIRObj.%ClassName(0)="Bundle")&&(tHSFHIRObj.entry.Count()=1) {
			Set tEntry = tHSFHIRObj.entry.GetAt(1)
			If $IsObject(tEntry.resource.OperationOutcome) {
				Do ..ErrorFromOperationOutcome(tEntry.resource.OperationOutcome, .tErrorMessage)
				Set pPatientSearchResponse.ErrStatus = $$$ERROR($$$GeneralError, tErrorMessage)
				Quit
			}
		}
		If $$$ISERR(pPatientSearchResponse.ErrStatus) Quit
		
		#; tAffinityDomain is affinity domain of the service that
		#; was queried.  This is defined in the HS Service Registry
		#; Assigning Authority field for the service.  If that field
		#; is blank then use the AffinityDomain macro to get it.
		Set tAffinityDomain = $S($lg(..RegistryService,4)]"":$lg(..RegistryService,4),1:$$$AffinityDomain)
		
		$$$HSTRACE("Affinity domain", "tAffinityDomain", tAffinityDomain)
		
		#; Loop through the Bundle entries to build the PatientSearchResponse.
		#; Only expecting to find Patient resources and OperationOutcome
		#; resources.  OperationOutcome resources are ignored.
		If tHSFHIRObj.%ClassName(0)="Patient" {
			Set tSC = ..PatientResourceToSearchMatch(tHSFHIRObj, tAffinityDomain, .tPatientSearchMatch)
			If $$$ISERR(tSC) Set pPatientSearchResponse.ErrStatus = tSC Quit
			Do pPatientSearchResponse.Results.Insert(tPatientSearchMatch)
		} Else {
			For i = 1:1:tHSFHIRObj.entry.Count() {
				Set tEntry = tHSFHIRObj.entry.GetAt(i)
				If $IsObject(tEntry.resource.Patient) {
					Set tPatientResource = tEntry.resource.Patient
					Set tSC = ..PatientResourceToSearchMatch(tEntry.resource.Patient, tAffinityDomain, .tPatientSearchMatch)
					If $$$ISERR(tSC) Quit
					Do tPatientSearchMatch.AdditionalInfo.SetAt(tEntry.fullUrl.value,"FullUrl")
					Do pPatientSearchResponse.Results.Insert(tPatientSearchMatch)
				} ElseIf '$IsObject(tEntry.resource.OperationOutcome) {
					Set tSC = ##class(HS.FHIR.Utils).GetResourceTypeFromContainer(tEntry.resource, .tEntryResourceType)
					Do pPatientSearchResponse.Results.Clear()
					Set pPatientSearchResponse.ErrStatus = $$$ERROR($$$GeneralError, "Unexpected resource type found in PDQm response Bundle entry "_i_" - "_tEntryResourceType)
					Quit
				}
			}
		}
		
		For tIdx=1:1:pPatientSearchResponse.Results.Count() {
			Set tItem=pPatientSearchResponse.Results.GetAt(tIdx)
			For tIdx2=1:1:tItem.Identifiers.Count() {
				If tItem.Identifiers.GetAt(tIdx2).Root=tAffinityDomain Set tItem.MPIID=tItem.Identifiers.GetAt(tIdx2).Extension Quit
			}
			/// Ensure response is consistent with what is returned from MPI Manager (Primarily for XCPD)
			If tItem.MPIID]"" {
				Set tMPIMatch = ##class(HS.Message.PatientMPIMatch).%New()
				Do tMPIMatch.CopyFrom(tItem,tMPIMatch)
				Do tMPIMatch.SearchMatches.Insert(tIdx)
				For tIdxA=1:1:tItem.Telecoms.Count() {
					Do tMPIMatch.Telecoms.Insert(tItem.Telecoms.GetAt(tIdxA))
				}
				For tIdxA=1:1:tItem.Addresses.Count() {
					Do tMPIMatch.Addresses.Insert(tItem.Addresses.GetAt(tIdxA))
				}
				Do pPatientSearchResponse.MPIIDList.Insert(tMPIMatch)
			}
		}
		If $$$ISERR(pPatientSearchResponse.ErrStatus) Quit
		
		For i = 1:1:tHSFHIRObj.link.Count() {
			Set tLinkRel = tHSFHIRObj.link.GetAt(i).relation.value
			Set tLinkUrl = tHSFHIRObj.link.GetAt(i).url.value
			If (tLinkRel="first")||(tLinkRel="previous")||(tLinkRel="next")||(tLinkRel="last") {
				Do pPatientSearchResponse.AdditionalInfo.SetAt(tLinkUrl, tLinkRel)
			}
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

Method ErrorFromOperationOutcome(pOperationOutcome As HS.FHIR.vDSTU2.Model.Resource.OperationOutcome, Output pErrorMessage As %String)
{
	Set pErrorMessage = pOperationOutcome.issue.GetAt(1).diagnostics.value
	
	If pErrorMessage="" {
		If $IsObject(pOperationOutcome.issue.GetAt(1).details) {
			Set pErrorMessage = pOperationOutcome.issue.GetAt(1).details.text.value
			If (pErrorMessage="")&&($IsObject(pOperationOutcome.issue.GetAt(1).details.coding))&&(pOperationOutcome.issue.GetAt(i).details.coding.Count()>0) {
				Set pErrorMessage = pOperationOutcome.issue.GetAt(1).details.coding.GetAt(1).display.value
				If pErrorMessage="" Set pErrorMessage = pOperationOutcome.issue.GetAt(i).details.coding.GetAt(1).code.value
			}
		}
	}
	
	If pErrorMessage="" Set pErrorMessage = "Unknown error message"
	
	Quit
}

Method PatientResourceToSearchMatch(pPatientResource As HS.FHIR.vDSTU2.Model.Resource.Patient, pAffinityDomain As %String, Output pPatientSearchMatch As HS.Message.PatientSearchMatch) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set pPatientSearchMatch = ##class(HS.Message.PatientSearchMatch).%New()
		
		For i = 1:1:pPatientResource.identifier.Count() {
			Set tFHIRIdentifier = pPatientResource.identifier.GetAt(i)
			Set tHSIdentifier = ##class(HS.Types.Identifier).%New()
			Set tSystem = tFHIRIdentifier.system.value
			If tSystem'="" {
				Set tSystem = ##class(HS.Data.OIDMap).GetCodeForURI(tSystem, tSystem_" not found in OID Registry")
			} Else {
				Set tSystem = "Assigning Authority value missing"
			}
			Set tHSIdentifier.Root = tSystem
			Set tHSIdentifier.Extension = tFHIRIdentifier.value.value
			Set tHSIdentifier.Status = "A"
			Do pPatientSearchMatch.Identifiers.Insert(tHSIdentifier)
			If tSystem=pAffinityDomain {
				Set pPatientSearchMatch.MPIID = tFHIRIdentifier.value.value
			} ElseIf (tFHIRIdentifier.system.value="urn:oid:2.16.840.1.113883.4.1")||(tFHIRIdentifier.system.value="http://hl7.org/fhir/sid/us-ssn") {
				Set pPatientSearchMatch.SSN = tFHIRIdentifier.value.value
			}
		}
		
		If pPatientResource.name.Count()>0 {
			If pPatientResource.name.GetAt(1).family.Count()>0 {
				Set pPatientSearchMatch.LastName = pPatientResource.name.GetAt(1).family.GetAt(1).value
			}
			If pPatientResource.name.GetAt(1).given.Count()>0 {
				Set pPatientSearchMatch.FirstName = pPatientResource.name.GetAt(1).given.GetAt(1).value
				If pPatientResource.name.GetAt(1).given.Count()>1 Set pPatientSearchMatch.MiddleName = pPatientResource.name.GetAt(1).given.GetAt(2).value
			}
			If pPatientResource.name.GetAt(1).prefix.Count()>0 {
				Set pPatientSearchMatch.Prefix = ..StringListToString(pPatientResource.name.GetAt(1).prefix)
			}
			If pPatientResource.name.GetAt(1).suffix.Count()>0 {
				Set pPatientSearchMatch.Suffix = ..StringListToString(pPatientResource.name.GetAt(1).suffix)
			}
			#dim tName As HS.FHIR.vDSTU2.Model.Base.HumanName
			For j = 1:1:pPatientResource.name.Count() {
				Set tName = pPatientResource.name.GetAt(j)
				If tName.use.value="anonymous" {
					Set tPersonName = ##class(HS.Types.PersonName).%New()
					If tName.given.Count()>0 {
						Set tPersonName.Given = tName.given.GetAt(1).value
						If tName.given.Count()>1 {
							Set tPersonName.Middle = tName.given.GetAt(2).value
						}
					}
					If tName.family.Count()>0 {
						Set tPersonName.Family = tName.family.GetAt(1).value
					}
					If tName.prefix.Count()>0 {
						Set tPersonName.Prefix = ..StringListToString(tName.prefix)
					}
					If tName.suffix.Count()>0 {
						Set tPersonName.Suffix = ..StringListToString(tName.suffix)
					}
					Do pPatientSearchMatch.Names.Insert(tPersonName)
				}
			}
		}
		
		Set pPatientSearchMatch.Sex = $Case(pPatientResource.gender.value, "male":"M", "female":"F", "other":"O", "unknown":"U", :"")
		
		#; birthDate is of FHIR type date  It may be a date or
		#; a partial date (YYYY only or YYYY-MM). NO time zone.
		Set tDOB = pPatientResource.birthDate.value
		If tDOB'="" {
			If tDOB?4N1"-"2N1"-"2N {
				Set tDOB = tDOB_" 00:00:00"
				Set pPatientSearchMatch.DOB = $ZDateH(tDOB,3)
			} ElseIf tDOB?4N1"-"2N {
				// Currently cannot handle partial date.
			} ElseIf tDOB?4N {
				// Currently cannot handle partial date.
			}
		}
		
		For i = 1:1:pPatientResource.telecom.Count() {
			Set tFHIRTelecom = pPatientResource.telecom.GetAt(i)
			Set tMatchTelecom = ##class(HS.Types.Telecom).%New()
			Set tUse = $Case(tFHIRTelecom.use.value, "home":"H", "work":"WP", "temp":"TMP", "old":"BAD", "mobile":"MC", :"")
			Set tType = $Case(tFHIRTelecom.system.value, "phone":"L", "fax":"F", "email":"email", "pager":"P", "other":"O", :"")
			If tType="email" {
				Set tMatchTelecom.Email = tFHIRTelecom.value.value
			} Else {
				Set tMatchTelecom.Type = tType
				Set tMatchTelecom.Use = tUse
				Set tMatchTelecom.PhoneNumberFull = tFHIRTelecom.value.value
			}
			Do pPatientSearchMatch.Telecoms.Insert(tMatchTelecom)
		}
		
		For i = 1:1:pPatientResource.address.Count() {
			Set tFHIRAddr = pPatientResource.address.GetAt(i)
			Set tMatchAddr = ##class(HS.Types.Address).%New()
			For j = 1:1:tFHIRAddr.line.Count() {
				If j>1 Set tMatchAddr.StreetLine = tMatchAddr.StreetLine_";"
				Set tMatchAddr.StreetLine = tMatchAddr.StreetLine_tFHIRAddr.line.GetAt(j).value
			}
			Set tMatchAddr.City = tFHIRAddr.city.value
			Set tMatchAddr.State = tFHIRAddr.state.value
			Set tMatchAddr.PostalCode = tFHIRAddr.postalCode.value
			Set tMatchAddr.County = tFHIRAddr.district.value
			Set tMatchAddr.Country = tFHIRAddr.country.value
			Do pPatientSearchMatch.Addresses.Insert(tMatchAddr)
		}
		
		For i = 1:1:pPatientResource.extension.Count() {
			If pPatientResource.extension.GetAt(i).url="http://hl7.org/fhir/StructureDefinition/patient-mothersMaidenName" {
				Set pPatientSearchMatch.MothersMaidenSurname = pPatientResource.extension.GetAt(i).valueString.value
			} ElseIf pPatientResource.extension.GetAt(i).url="http://hl7.org/fhir/StructureDefinition/patient-religion" {
				Set tCode = ""
				If $IsObject(pPatientResource.extension.GetAt(i).valueCodeableConcept.coding) {
					If ($IsObject(pPatientResource.extension.GetAt(i).valueCodeableConcept.coding))&&(pPatientResource.extension.GetAt(i).valueCodeableConcept.coding.Count()>0) {
						Set tCode = pPatientResource.extension.GetAt(i).valueCodeableConcept.coding.GetAt(1).code.value
						If tCode="" Set tCode = pPatientResource.extension.GetAt(i).valueCodeableConcept.coding.GetAt(1).display.value
					}
					If tCode="" {
						Set tCode = pPatientResource.extension.GetAt(i).valueCodeableConcept.text.value
					}
				}
				Set pPatientSearchMatch.ReligiousAffiliation = tCode
			}
		}
		
		If pPatientResource.multipleBirthInteger.value'="" {
			// HS.Types.PersonInfo BirthOrder has no unambiguous way of indicating
			// multiple birth true/false. Therefore do not populate BirthOrder if
			// multipleBirthBoolean was returned instead of multipleBirthInteger.
			Set pPatientSearchMatch.BirthOrder = pPatientResource.multipleBirthInteger.value
		}
		
		If $IsObject(pPatientResource.maritalStatus)&&(pPatientResource.maritalStatus.coding.Count()>0) {
			If pPatientResource.maritalStatus.coding.GetAt(1).code.value'="" {
				Set pPatientSearchMatch.MaritalStatus = pPatientResource.maritalStatus.coding.GetAt(1).code.value
			} ElseIf pPatientResource.maritalStatus.text.value'="" {
				Set pPatientSearchMatch.MaritalStatus = pPatientResource.maritalStatus.text.value
			}
		}
		
		If $IsObject(pPatientResource.communication)&&(pPatientResource.communication.Count()>0) {
			If pPatientResource.communication.GetAt(1).language.text.value'="" {
				Set pPatientSearchMatch.Language = pPatientResource.communication.GetAt(1).language.text.value
			} ElseIf (pPatientResource.communication.GetAt(1).language.coding.Count()>0)&&(pPatientResource.communication.GetAt(1).language.coding.GetAt(1).code.value'="") {
				Set pPatientSearchMatch.Language = pPatientResource.communication.GetAt(1).language.coding.GetAt(1).code.value
			}
		}
		
		If $IsObject(pPatientResource.deceasedBoolean)&&(pPatientResource.deceasedBoolean.value'="") {
			Set pPatientSearchMatch.DeathStatus = pPatientResource.deceasedBoolean.value
		} ElseIf $IsObject(pPatientResource.deceasedDateTime)&&(pPatientResource.deceasedDateTime.value'="") {
			Set tValue = $Translate(pPatientResource.deceasedDateTime.value, "TZ", " ")
			If $Length(tValue)=10 Set tValue = tValue_" 00:00:00"
			Set pPatientSearchMatch.DeathTime = tValue
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

ClassMethod StringListToString(pList As %Library.ListOfDataTypes) As %String
{
	Set tString = ""
	For i = 1:1:pList.Count() {
		If tString'="" Set tString = tString_" "
		Set tString = tString_pList.GetAt(i).value
	}
	Quit tString
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
