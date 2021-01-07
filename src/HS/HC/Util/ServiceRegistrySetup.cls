Include HS.HC

Class HS.HC.Util.ServiceRegistrySetup
{

/// @API<br>
/// This method chooses the most appropriate means of submitting the setup of a specified
/// HTTP type Service Registry entry. Depending on the current namespace type, will either
/// direct set the Service Registry entry, or log a DeferredAction.<br>
/// If namespace type is Foundation, does direct set into the Service Registry table.<br>
/// If namespace type is not Foundation, then submits DeferredAction.<br>
/// Input:<br>
/// pServiceName:    Service Registry entry name.
/// pHost:           Host name.
/// pPort:           Port.
/// pPrefix:         URL prefix.
/// pServiceURL:     URL for service (URL property of Service Registry entry).
/// pSSLConfig:      SSL configuration name.
/// pCredentialName: Interoperability credential name.
ClassMethod AddEditHTTPService(pServiceName As %String, pHost As %String, pPort As %String = "", pPrefix As %String = "", pServiceUrl As %String, pSSLConfig As %String = "", pCredentialName As %String = "", ByRef pFullUrl As %String, ByRef pIsDeferred As %Boolean)
{
	Set pFullUrl = ""
	Set pIsDeferred = ""
	
	Set tNamespace = $Namespace
	
	Set tConfigObj = ##class(HS.Util.Installer.ConfigItem).%OpenId(tNamespace)
	If '$IsObject(tConfigObj) {
		$$$ThrowStatus($$$ERROR($$$GeneralError, $$$CurrentClass_" " _$$$CurrentMethod_" cannot be invoked in this type of namespace"))
	}
	
	If (tConfigObj.Type = "Foundation") {
		// Foundation will take direct set of service entry.
		Do ..AddEditHTTPServiceFoundation(pServiceName, pHost, pPort, pPrefix, pServiceUrl, pSSLConfig, pCredentialName, .pFullUrl)
	} Else {
		Do ..AddEditHTTPServiceNonFoundation(pServiceName, pHost, pPort, pPrefix, pServiceUrl, pSSLConfig, pCredentialName, .pFullUrl, .pIsDeferred)
	}
	
	Quit
}

ClassMethod GetURLAndFullUrl(pHost As %String, pPort As %String, pPrefix As %String, pServiceUrl As %String, pSSLConfig As %String, ByRef pURL As %String, ByRef pFullUrl As %String)
{
	// Calculate the URL and Full Url (aka Service Registry entry EndPoint) for the service.
	
	Set pURL = ""
	Set pFullUrl = ""
	
	Set pURL = $S(pPrefix'="":("/"_pPrefix), 1:"")
	Set pURL = pURL_pServiceUrl
	Set pURL=$S($E(pURL)="/":"",1:"/")_pURL
	Set:pURL="/" pURL=""	//For endpoints that have nothing after the port
	
	Set pFullUrl = $S(pSSLConfig="":"http://",1:"https://")_pHost_$S(pPort="":"",1:":"_pPort)_pURL
	
	Quit
}

ClassMethod AddEditHTTPServiceFoundation(pServiceName As %String, pHost As %String, pPort As %String, pPrefix As %String, pServiceUrl As %String, pSSLConfig As %String = "", pCredentialName As %String = "", ByRef pFullUrl)
{
	Do ..GetURLAndFullUrl(pHost, pPort, pPrefix, pServiceUrl, pSSLConfig, .tURL, .pFullUrl)
	
	// If there is an existing Service Registry entry with pFullUrl
	// as the EndPoint, then do not set a new Service Registry entry.
	Set tServiceObj = ##class(HS.Registry.Service.HTTP).EndPointForURL(pFullUrl)
	If '$IsObject(tServiceObj) {
		Set tService = ##class(HS.Registry.Service.HTTP).%New()
		Set tService.Name = pServiceName
		Set tService.Type = "HTTP"
		Set tService.Host = pHost
		Set tService.Port = pPort
		Set tService.URL = tURL
		Set tService.SSLConfig = pSSLConfig
		Set tService.HTTPCredentialsConfig = pCredentialName
		$$$ThrowOnError(tService.%Save())
		Set pFullUrl = tService.EndPoint
	}
}

ClassMethod AddEditHTTPServiceNonFoundation(pServiceName As %String, pHost As %String, pPort As %String, pPrefix As %String, pServiceUrl As %String, pSSLConfig As %String = "", pCredentialName As %String = "", ByRef pFullUrl As %String, ByRef pIsDeferred As %Boolean)
{
	// Array of production classes that call InstallDeferred() from their OnStart().
	Do ..GetDeferredActionProductions(.tValidProductionClasses)
	
	// tHasProduction indicates whether the current production in the local
	// namespace is or extends a class that is known call InstallDeferred().
	Set tHasProduction = 0
	
	#dim tProductionObj As Ens.Config.Production
	$$$ThrowOnError(##class(HS.Util.Installer.Kit.Base).GetProduction(.tProductionObj, .tProductionClass))
	If tProductionClass'="" {
		If ($Data(tValidProductionClasses(tProductionClass))) {
			Set tHasProduction = 1
		} Else {
			Set tValidProductionClass = ""
			For {
				Set tValidProductionClass = $Order(tValidProductionClasses(tValidProductionClass))
				If tValidProductionClass="" Quit
				If $ClassMethod(tProductionClass, "%IsA", tValidProductionClass) {
					Set tHasProduction = 1
					Quit
				}
			}
		}
	} Else {
		Set tHasProduction = 0
	}
	
	If tHasProduction {
		Do ..AddEditHTTPServiceDeferred(pServiceName, pHost, pPort, pPrefix, pServiceUrl, pSSLConfig, pCredentialName)
		Set pIsDeferred = 1
	} Else {
		$$$ThrowStatus($$$ERROR($$$GeneralError, "Cannot submit request for Add or Edit of Service Registry entry - verify that registry namespace production is running"))
	}
	
	Quit
}

ClassMethod GetDeferredActionProductions(ByRef pProductions)
{
	Set pProductions("HS.Util.AbstractFlashProduction") = ""
	Set pProductions("HS.Util.AbstractAccessProduction") = ""
	Set pProductions("HS.Util.AbstractRegistryProduction") = ""
	Quit
}

/// Create a new DeferredAction for adding a Service Registry entry, or add to an
/// existing DeferredAction for adding a Service Registry entry.
ClassMethod AddEditHTTPServiceDeferred(pServiceName As %String, pHost As %String, pPort As %String, pPrefix As %String, pServiceUrl As %String, pSSLConfig As %String = "", pCredentialName As %String = "")
{
	// DeferredAction "service-registry-entries" = $lb( serviceinfo, serviceinfo, ... )
	// serviceinfo = $lb(pServiceName, pHost, pPort, pPrefix, pServiceUrl, pSSLConfig, pCredentialName)
	
	Set tServiceEntries = ##class(HS.Util.Installer.ConfigItem).GetDeferredAction($Namespace, "service-registry-entries")
	
	If tServiceEntries="" {
		// There is no existing saved deferred service-registry-entries action.
		// Initialize the service list with current specified service info.
		Set tServiceEntries = $ListBuild($ListBuild(pServiceName, pHost, pPort, pPrefix, pServiceUrl, pSSLConfig, pCredentialName))
		
	} Else {
		// There is an existing saved deferred service-registry-entries action.
		// Add the current specified service info to the service list, if it
		// is not a duplicate.
		Set tIsDuplicate = 0
		Set tOldServiceEntries = tServiceEntries
		Set tServiceEntries = ""
		For tLLIndex = 1:1:$ListLength(tOldServiceEntries) {
			Set tOneService = $ListGet(tOldServiceEntries, tLLIndex)
			If ((pServiceName=$ListGet(tOneService,1)))&&(pHost=$ListGet(tOneService,2))&&(pPort=$ListGet(tOneService,3))&&(pServiceUrl=$ListGet(tOneService,5)) {
				Set tIsDuplicate = 1
				Quit
			}
			Set tServiceEntries = tServiceEntries _ $ListBuild(tOneService)
			
		}
		If tIsDuplicate {
			// Upon duplicate, Quit but do not throw a fail.
			Quit
		}
		Set tServiceEntries = tServiceEntries _ $ListBuild($ListBuild(pServiceName, pHost, pPort, pPrefix, pServiceUrl, pSSLConfig, pCredentialName))
	}
	
	Do ##class(HS.Util.Installer.ConfigItem).AddDeferredAction($Namespace, "service-registry-entries", tServiceEntries)
	
	Quit
}

}
