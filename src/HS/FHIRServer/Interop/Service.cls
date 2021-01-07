Include HS.FHIRServer

/// FHIRServer REST Business Service
Class HS.FHIRServer.Interop.Service Extends (Ens.BusinessService, HS.HC.Util.Trace.Helper)
{

Parameter SETTINGS = "TargetConfigName:Basic:selector?context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId},Timeout:Basic";

/// Configuration item to which to send inbound messages.
Property TargetConfigName As Ens.DataType.ConfigName [ InitialExpression = "HS.FHIRServer.Interop.Operation" ];

/// Timeout for dispatch (so we don't hold up the HTTP service too long or hang up a production shutdown).
Property Timeout As %Integer [ InitialExpression = 25 ];

/// Process an incoming message into the production; dispatch it to the configured target.
/// The Interoperability contract requires that errors be returned as %Status here.
Method OnProcessInput(pRequest As HS.FHIRServer.Interop.Request, Output pResponse As HS.FHIRServer.Interop.Response) As %Status
{
	#dim tSC As %Status = $$$OK
	
	Try {
		If $$$HSTRACING {
			// Log a clone of pRequest, in case the contents are modified after this
			// point, for example by custom processing. Logging of QuickStream will
			// read the contents of the QuickStream into the log, effectively cloning
			// the contents.
			If pRequest.QuickStreamId'="" {
				Set quickStreamIn = ##class(HS.SDA3.QuickStream).%OpenId(pRequest.QuickStreamId)
				$$$HSTRACE("Request message", "pRequest,quickStreamIn", pRequest.%ConstructClone(1), quickStreamIn)
			} Else {
				$$$HSTRACE("Request message", "pRequest", pRequest.%ConstructClone(1))
			}
		}
		
		// Make sure the input message is sensible
		If 'pRequest.%IsA("HS.FHIRServer.Interop.Request") {
			Set tSC = $$$EnsError($$$EnsErrClassNotDerived,pRequest.%ClassName(1), "HS.FHIRServer.Interop.Request")
			Quit
		}
		
		Set tStart = $ZH
		// Now dispatch with timeout
		Set tSC = ..SendRequestSync(..TargetConfigName, pRequest, .pResponse, ..Timeout)

		Set tEnd=$ZH, tElapsed=tEnd-tStart
		$$$FSLog("Request took " _ tElapsed _ " secs.  Status=" _ tSC)
		Quit:$$$ISERR(tSC)
		
		// Make sure the output message is sensible
		If $IsObject($Get(pResponse)) {
			If 'pResponse.%IsA("HS.FHIRServer.Interop.Response") {
				Set tSC = $$$EnsError($$$EnsErrClassNotDerived, pResponse.%ClassName(1), "HS.FHIRServer.Interop.Response")
				Quit
			}
		} Else {
			// Timeout on SendRequestSync does not cause it to return error.
			// The symptom of SendRequestSync timeout is lack of response object.
			$$$ThrowFHIR($$$HSFHIRErrEnsembleTimeout)
		}
		If $IsObject(pResponse.Response) {
			If 'pResponse.Response.%IsA("HS.FHIRServer.API.Data.Response") {
				Set tSC = $$$EnsError($$$EnsErrClassNotDerived, pResponse.Response.%ClassName(1), "HS.FHIRServer.API.Data.Response")
				Quit
			}
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

}
