Include HS.HC

/// HS.FHIR.vSTU3.PIXm.Consumer.Operations takes an HS PatientSearchRequest message as input,
/// converts it to an HS FHIR request message, and sends it to the specified end point
/// over HTTP.
Class HS.FHIR.vSTU3.PIXm.Consumer.Operations Extends (HS.FHIR.REST.Operation, HS.HC.Util.Trace.Helper)
{

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
/// are: "xml", "json", "applicaton/fhir+xml", "application/fhir+json"
Property FHIRFormat As %String(DISPLAYLIST = ",XML,JSON", VALUELIST = ",XML,JSON") [ InitialExpression = "XML" ];

XData MessageMap
{
<MapItems>
  <MapItem MessageType="HS.Message.PatientSearchRequest">
    <Method>PIXLookup</Method>
  </MapItem>
</MapItems>
}

Method OnMessage(pRequest As %Library.Persistent, Output pResponse As %Library.Persistent) As %Status
{
	Set tSC = $$$OK
	
	Try {
		If pRequest.%IsA("HS.Message.FHIR.Request") {
			$$$HSTRACE("FHIR Request", "pRequest", pRequest)
			If (pRequest.Type="Patient")&&(pRequest.Interaction="$ihe-pix") {
				Set tSC = ..FHIRRequest(pRequest, .pResponse)
			} ElseIf pRequest.Type'="Patient" {
				Set tSC = $$$ERROR($$$GeneralError, "Invalid resource type "_pRequest.Type_" on PIXm request - must be Patient")
			} ElseIf pRequest.Interaction'="$ihe-pix" {
				Set tSC = $$$ERROR($$$GeneralError, "Invalid interaction "_pRequest.Interaction_" on PIXm request - must be $ihe-pix")
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

/// PIXLookup takes an HS PatientSearchRequest message as input, tranforms
/// it into an HS FHIR request message, calls OnMessage to send it on to
/// its intended target, recieves the HS FHIR response, transforms it into
/// an HS PatientSearchResponse message, and returns it.
Method PIXLookup(pRequest As HS.Message.PatientSearchRequest, ByRef pResponse As HS.Message.PatientSearchResponse) As %Status
{
	Set tSC = $$$OK
	
	Try {
		#dim tPIXmRequest As HS.Message.FHIR.Request
		#dim tPIXmResponse As HS.Message.FHIR.Response
		
		Set tSC = ..PatientSearchToPIXmRequest(pRequest, .tPIXmRequest)
		If $$$ISERR(tSC) Quit
		
		Set tSC = ..OnMessage(tPIXmRequest, .tPIXmResponse)
		If $$$ISERR(tSC) Quit
		
		Set tSC = ..PIXmResponseToSearchResponse(tPIXmResponse, .pResponse)
		If $$$ISERR(tSC) Quit
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// PatientSearchToPIXmRequest takes an HS PatientSearchRequest as input,
/// transforms it into an HS FHIR request, and returns it.
Method PatientSearchToPIXmRequest(pPatientSearchRequest As HS.Message.PatientSearchRequest, ByRef pPIXmRequest As HS.Message.FHIR.Request) As %Status
{
	Set tSC = $$$OK
	
	Try {
		#; Update the cached service entry data If needed.
		Do ..UpdateRegistryService(pPatientSearchRequest.AdditionalInfo.GetAt("ServiceName"))
		
		Set pPIXmRequest = ##class(HS.Message.FHIR.Request).%New()
		Set pPIXmRequest.Interaction = "$ihe-pix"
		Set pPIXmRequest.Type = "Patient"
		
		#; SEARCH PARAMETERS
		#; sourceIdentifier - Assigning authority OID/URL plus identifier. Examples:
		#; - sourceIdentifier=urn:oid:2.16.840.1.113883.4.1|123456789
		#; - sourceIdentifier=http://www.someclinic.com/fhir|123456789
		#; targetSystem - Patient identifier domain URI.
		
		Set tAffinityDomainCode = $$$AffinityDomain
		
		If pPatientSearchRequest.AssigningAuthority'="" && (pPatientSearchRequest.MRN'="") {
			Set tURI = ##class(HS.Data.OIDMap).GetURIForCode(pPatientSearchRequest.AssigningAuthority, "")
			If tURI="" Set tSC = $$$ERROR($$$GeneralError, "No URI defined in OID Registry for specified Assigning Authority "_pPatientSearchRequest.AssigningAuthority) $$$ThrowOnError(tSC)
			Set tSC = pPIXmRequest.SetParameter("sourceIdentifier", tURI_"|"_pPatientSearchRequest.MRN) $$$ThrowOnError(tSC)
		} ElseIf pPatientSearchRequest.MPIID'="" {
			Set tURI = ##class(HS.Data.OIDMap).GetURIForCode(tAffinityDomainCode, "")
			If tURI="" Set tSC = $$$ERROR($$$GeneralError, "No URI defined in OID Registry for specified Assigning Authority "_tAffinityDomainCode) $$$ThrowOnError(tSC)
			Set tSC = pPIXmRequest.SetParameter("sourceIdentifier", tURI_"|"_pPatientSearchRequest.MPIID) $$$ThrowOnError(tSC)
		}
		
		Set tFormat = $ZConvert(pPatientSearchRequest.AdditionalInfo.GetAt("_format"),"L")
		If tFormat="" Set tFormat = $ZConvert(..FHIRFormat, "L")
		Do ##class(HS.FHIR.Utils).GetValidFormats("Parameter", .tFormats)
		If '$Data(tFormats(tFormat)) Set tSC = $$$ERROR($$$GeneralError, "Invalid _format value "_tFormat_" specified") $$$ThrowOnError(tSC)
		Do pPIXmRequest.SetParameter("_format", tFormat)
		Set pPIXmRequest.ContentType = tFormats(tFormat)
		
		If pPatientSearchRequest.AdditionalInfo.IsDefined("ScopingOrganizations") {
			Set tTargetSystems = ""
			Set tKey = ""
			For {
				Set tKey = pPatientSearchRequest.AdditionalInfo.Next(tKey)
				If tKey="" Quit
				If tKey'["scopingOrganization_" Continue
				Set tCode = $Piece(tKey,"scopingOrganization_",2)
				If tCode="" Set tSC = $$$ERROR($$$GeneralError, "Scoping Code missing from key") Quit
				Set tURI = ##class(HS.Data.OIDMap).GetURIForCode(tCode, "")
				If tURI="" Set tSC = $$$ERROR($$$GeneralError, "Scoping URI not defined in OID Registry for:"_tCode) Quit
				If tTargetSystems'="" Set tTargetSystems = tTargetSystems_","
				Set tTargetSystems = tTargetSystems_tURI
			}
			If tTargetSystems'="" Do pPIXmRequest.SetParameter("targetSystem", tTargetSystems)
		}
		$$$ThrowOnError(tSC)
		
		Do pPIXmRequest.AdditionalInfo.SetAt(pPatientSearchRequest.AdditionalInfo.GetAt("ServiceName"),"ServiceName")
		
	} Catch eException {
		$$$LOGERROR(eException.DisplayString())
		Set tSC = eException.AsStatus()	
	}
	
	Quit tSC
}

/// PIXmResponseToSearchResponse takes an HS FHIR response as input,
/// transforms it into an HS PatientSearchResponse, and returns it.
Method PIXmResponseToSearchResponse(pPIXmResponse As HS.Message.FHIR.Response, ByRef pPatientSearchResponse As HS.Message.PatientSearchResponse) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set pPatientSearchResponse = ##class(HS.Message.PatientSearchResponse).%New()
		Set pPatientSearchResponse.ErrStatus = $$$OK
		
		Do pPatientSearchResponse.AdditionalInfo.SetAt(pPIXmResponse.Status, "HTTPStatus")
		
		If +pPIXmResponse.Status=404 {
			Set pPatientSearchResponse.ErrStatus = $$$ERROR($$$GeneralError, "Requested record not found")
			Quit
		}
		
		Set tSC = ##class(HS.FHIR.Utils).FHIRToHSFHIR(pPIXmResponse.ContentType, pPIXmResponse.Payload, .tHSFHIRObj, "HS.FHIR.vSTU3.Model.Resource")
		If $$$ISERR(tSC) Set pPatientSearchResponse.ErrStatus = tSC Quit
		
		If (tHSFHIRObj.%ClassName(0)'="Parameters")&&(tHSFHIRObj.%ClassName(0)'="OperationOutcome") {
			Set tSC = $$$ERROR($$$GeneralError, "Unexpected resource type "_tHSFHIRObj.%ClassName(0)_" in PIXm return payload")
			Set pPatientSearchResponse.ErrStatus = $$$ERROR($$$GeneralError, "Unexpected resource type "_tHSFHIRObj.%ClassName(0)_" in PIXm return payload")
			Quit
		}
		
		If tHSFHIRObj.%ClassName(0)="OperationOutcome" {
			Set tErrorMessage = tHSFHIRObj.issue.GetAt(1).diagnostics.value
			If tErrorMessage="" {
				If $IsObject(tHSFHIRObj.issue.GetAt(1).details) {
					Set tErrorMessage = tHSFHIRObj.issue.GetAt(1).details.text.value
					If (tErrorMessage="")&&($IsObject(tHSFHIRObj.issue.GetAt(1).details.coding))&&(tHSFHIRObj.issue.GetAt(i).details.coding.Count()>0) {
						Set tErrorMessage = tHSFHIRObj.issue.GetAt(1).details.coding.GetAt(1).display.value
						If tErrorMessage="" Set tErrorMessage = tHSFHIRObj.issue.GetAt(i).details.coding.GetAt(1).code.value
					}
				}
			}
			If tErrorMessage="" Set tErrorMessage = "Unknown error message"
			Set pPatientSearchResponse.ErrStatus = $$$ERROR($$$GeneralError, tErrorMessage)
			Quit
		}
		
		If tHSFHIRObj.parameter.Count()=0 {
			Set pPatientSearchResponse.ResultsCount=0
			Quit
		}
		
		#; tAffinityDomain is the affinity domain of the service that
		#; was queried.  This is defined in the HS Service Registry
		#; Assigning Authority field for the service.  If that field
		#; is blank then use the AffinityDomain macro to get it.
		Set tAffinityDomain = $S($lg(..RegistryService,4)]"":$lg(..RegistryService,4),1:$$$AffinityDomain)
		
		$$$HSTRACE("Affinity domain", "tAffinityDomain", tAffinityDomain)
		
		Set tMatch = ##class(HS.Message.PatientSearchMatch).%New()
		
		For i = 1:1:tHSFHIRObj.parameter.Count() {
			If tHSFHIRObj.parameter.GetAt(i).name.value="targetIdentifier" {
				Set tFHIRIdentifier = tHSFHIRObj.parameter.GetAt(i).valueIdentifier
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
				Do tMatch.Identifiers.Insert(tHSIdentifier)
				If tSystem=tAffinityDomain Set tMatch.MPIID = tFHIRIdentifier.value.value
			} ElseIf tHSFHIRObj.parameter.GetAt(i).name.value="targetId" {
				Set tHSIdentifier = ##class(HS.Types.Identifier).%New()
				Set tHSIdentifier.Type = "FHIR"
				Set tHSIdentifier.Extension = tHSFHIRObj.parameter.GetAt(i).valueReference.reference.value
				Set tHSIdentifier.Status = "A"
				Do tMatch.Identifiers.Insert(tHSIdentifier)
			}
		}
		
		Do pPatientSearchResponse.Results.Insert(tMatch)
		
		Set pPatientSearchResponse.ErrStatus=$Select(pPatientSearchResponse.AdditionalInfo.GetAt("ErrStatusText")="":$$$OK,1:$$$ERROR($$$GeneralError,pPatientSearchResponse.AdditionalInfo.GetAt("ErrStatusText")))
		Do pPatientSearchResponse.AdditionalInfo.RemoveAt("ErrStatusText")
		Set pPatientSearchResponse.ResultsCount=pPatientSearchResponse.Results.Count()
		
	} Catch eException {
		Set tSC = eException.AsStatus()
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
