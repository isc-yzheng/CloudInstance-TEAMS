Class HS.FHIRServer.Util.ContextSearch Extends HS.HC.Util.ContextSearch
{

/// FHIRMetadataSets returns a list where each display row is a FHIR metadata set Key,
/// plus " / ", plus FHIR metadata set Description.
ClassMethod FHIRMetadataSets(Output pCaption As %String, Output pTopResults, Output pResults, ByRef pParms As %String, pSearchKey As %String = "") As %Status
{
	Set tSC = $$$OK
	
	// This method returns the core FHIR package for each version that can be transformed to/from SDA.
	Set pResults(1) = "HL7v40 / FHIR R4 Core Specification"
	Set pResults(2) = "HL7v30 / FHIR STU3 Core Specification"
	
	Quit tSC
}

/// FHIRServerEndpoints returns a list of the defined FHIRServer Service endpoints.
ClassMethod FHIRServerEndpoints(Output pCaption As %String, Output pTopResults, Output pResults, ByRef pParms As %String, pSearchKey As %String = "") As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set tEndpointList = ##class(HS.FHIRServer.ServiceAdmin).GetEndpointList()
		If $ListValid(tEndpointList) {
			For i = 1:1:$ListLength(tEndpointList) {
				Set pResults(i) = $ListGet(tEndpointList, i)
			}
		}
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

}
