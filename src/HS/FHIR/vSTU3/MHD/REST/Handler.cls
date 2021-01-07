Class HS.FHIR.vSTU3.MHD.REST.Handler Extends HS.FHIR.vSTU3.REST.Handler
{

ClassMethod contentTypeForRequest(ByRef pContentType As %String, pInteraction As %String) As %Status
{
	Set tStatus = $$$OK
	
	Try {
		#; For MHD, if interaction=read (MHD Retrieve) then just
		#; get the first content type found in the Accept header.
		#; If none found then just use */*.
		If pInteraction="read" {
			Set pContentType = $GET(%request.CgiEnvs("HTTP_ACCEPT"))
			If pContentType="" {
				Set pContentType = "*/*"
			} Else {
				For i = 1:1:$Length(pContentType, ";") {
					Set tP = $Piece(pContentType, ";", i)
					If (tP["fhir")&&('((tP="application/xml+fhir")||(tP="application/json+fhir")||(tP="application/fhir+xml")||(tP="application/fhir+json"))) {
						Set tStatus = $$$ERROR($$$GeneralError, "No valid Accept data found")
						Quit
					}
				}
			}
		} Else {
			Set tStatus = ##super(.pContentType, pInteraction)
		}
		
	} Catch (tEx) {
		Set tStatus = tEx.AsStatus()
	}
	
    Quit tStatus
}

/// For STU3, MHD is not using the Accept property of the FHIR request message.
/// Simply fill in the Accept property with an acceptable value and return $$$OK.
ClassMethod acceptForRequest(pURLFormat As %String, pHTTPAccept As %String, pDefault As %String, Output pAccept As %String) As %Status
{
	Set tStatus = $$$OK
	
	Set pAccept = ""
	
	Try {
		Do ##class(HS.FHIR.Utils).GetAllValidFormats(.tFormats)
		
		If ($Get(pURLFormat)'="")&&($Data(tFormats("Parameter", pURLFormat))) {
			Set pAccept = tFormats("Parameter", pURLFormat)
		} ElseIf $Get(pHTTPAccept)'="" {
			Set pAccept = pHTTPAccept
		} Else {
			Set pAccept = pDefault
		}
		
	} Catch (tEx) {
		Set tStatus = tEx.AsStatus()
	}
	
    Quit tStatus
}

}
