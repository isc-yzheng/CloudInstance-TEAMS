Class HS.HC.Util.Installer.FHIR.Reset.vDSTU2 Extends (HS.Util.Installer.Foundation.Reset, HS.HC.Util.Installer.FHIR.Reset)
{

ClassMethod Reset(pDiscardCapabilities = 0) As %Status
{
	Set tSC = $$$OK
	
	Set tVerbose = $$$WriteProg
	
	Try {
		Do ##class(HS.HC.Util.Installer).Log(.tLogFile, $$$CurrentClass, $$$CurrentMethod, "in "_$Namespace_" started at "_$ZDateTime($Horolog,3))
		
		Set tResourceType = "Conformance"
		Set tStorageClass = "HS.FHIR.vDSTU2.Repository.Storage"
		
		If 'pDiscardCapabilities {
			Set tSC = ..SaveResources(tResourceType, tStorageClass, .tMetadata)
			If $$$ISERR(tSC) Quit
		}
		
		Set tSC = ..ResetBasedOnAbstractClass("HS.FHIR.vDSTU2.Repository.Resource.Abstract", tVerbose)
		If $$$ISERR(tSC) Quit
		
		Kill ^HS.XF.ResourceHash
		
		If 'pDiscardCapabilities {
			Set tSC = ..RestoreResources(tStorageClass, .tMetadata)
			If $$$ISERR(tSC) Quit
		}
		
		Do ##class(HS.HC.Util.Installer).Log(.tLogFile, $$$CurrentClass, $$$CurrentMethod, "Running HS.FHIR.SessionData.FHIRSession.%DeleteExtent()")
		Set tSC = ##class(HS.FHIR.SessionData.FHIRSession).%DeleteExtent()
		If $$$ISERR(tSC) Quit
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	If 'pDiscardCapabilities Do ..ClearQuickStreams(.tMetadata)
	
	If $$$ISERR(tSC) {
		Do ##class(HS.HC.Util.Installer).Log(.tLogFile, $$$CurrentClass, $$$CurrentMethod, "ERROR at "_$ZDateTime($Horolog,3)_" - "_$system.Status.GetErrorText(tSC))
	} Else {
		Do ##class(HS.HC.Util.Installer).Log(.tLogFile, $$$CurrentClass, $$$CurrentMethod, "in "_$Namespace_" done at "_$ZDateTime($Horolog,3))
	}
	
	Quit tSC
}

}
