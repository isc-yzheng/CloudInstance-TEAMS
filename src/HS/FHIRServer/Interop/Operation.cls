Include HS.FHIRServer

/// This business operation hosts the FHIRServer logic for taking in a FHIRServer
/// request and processing it against a FHIRServer interaction strategy.
Class HS.FHIRServer.Interop.Operation Extends (Ens.BusinessOperation, HS.HC.Util.Trace.Helper)
{

Parameter SETTINGS As %String;

XData MessageMap
{
<MapItems>
	<MapItem MessageType="HS.FHIRServer.Interop.Request">
		<Method>DispatchRequest</Method>
	</MapItem>
</MapItems>
}

Method DispatchRequest(pInteropRequest As HS.FHIRServer.Interop.Request, Output pInteropResponse As HS.FHIRServer.Interop.Response) As %Status
{
	Set tSC = $$$OK
	
	Try {
		// Get the FHIR Service
		#dim fhirRequest As HS.FHIRServer.API.Data.Request = pInteropRequest.Request
		
		Set key = $$$AppKeyFromApp(fhirRequest.SessionApplication)
		
		// Instantiate the FHIR Service Implementation
		#dim fhirService as HS.FHIRServer.API.Service = ##class(HS.FHIRServer.Service).EnsureInstance(key)
		
		$$$ThrowOnError(pInteropRequest.NewResponse(.pInteropResponse))
		
		// For any incoming request payload, create a %DynamicObject and assign
		// it to the Json property of the FHIR request object.
		If pInteropRequest.QuickStreamId '= "" {
			Set quickStreamIn = ##class(HS.SDA3.QuickStream).%OpenId(pInteropRequest.QuickStreamId, .tSC)
			$$$ThrowOnError(tSC)
			$$$HSTRACE("Request QuickStream", "quickStreamIn", quickStreamIn)
			Set fhirRequest.Json = fhirService.StreamToJSON(quickStreamIn, fhirRequest.RequestFormatCode)
		}
		
		Do fhirService.DispatchRequest(fhirRequest, .fhirResponse)

		If (($IsObject($Get(fhirResponse))) && ($IsObject(fhirResponse.Json))) {
			// Emit the response object into a QuickStream in the requested format (so that it can just be
			// copied when the RESTHandler receives it)
			Set quickStreamOut = ##class(HS.SDA3.QuickStream).%New()
			Set pInteropResponse.QuickStreamId = quickStreamOut.%Id()
			Do ##class(HS.FHIRServer.RestHandler).WriteServiceResponse(fhirResponse , fhirService, quickStreamOut, .pInteropResponse)
			Do quickStreamOut.Rewind()
			$$$HSTRACE("Response QuickStream", "quickStreamOut", quickStreamOut)
		}
		Set pInteropResponse.Response = fhirResponse
	
	} Catch eException {
		Set tSC = eException.AsStatus()
		If $$$HSTRACING {
			If (($IsObject($Get(quickStreamIn))) && (quickStreamIn.%Extends("%Stream.Object"))) {	
				Do quickStreamIn.Rewind()
				$$$HSTRACEERROR("Request QuickStream", "quickStreamIn", quickStreamIn)
			}
			If (($IsObject($Get(quickStreamOut))) && (quickStreamOut.%Extends("%Stream.Object"))) {	
				Do quickStreamOut.Rewind()
				$$$HSTRACEERROR("Response QuickStream", "quickStreamOut", quickStreamOut)
			}
		}
	}
		
	Quit tSC
}

}
