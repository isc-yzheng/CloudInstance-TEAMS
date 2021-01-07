Class HS.FHIR.vDSTU2.MHD.REST.Handler Extends HS.FHIR.vDSTU2.REST.Handler
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
					If (tP["fhir")&&('((tP="application/xml+fhir")||(tP="application/json+fhir"))) {
						// The STU3 mime types will cause a 406 Not Acceptable to be returned in the HTTP response.
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

}
