Include (HS.HC, HS.FHIRServer)

Class HS.FHIRServer.ConsoleSetup Extends HS.FHIRServer.Tools.ValueReader
{

ClassMethod Setup()
{
	// Ensure that the Namespace is FHIR-enabled 
	Do ##class(HS.FHIRServer.Installer).InstallNamespace()
	Set choice = 1
	set type = ##class(%ZHSLIB.HealthShareMgr).GetHealthShareNamespaceType()
	for {
		if type = "FlashGateway"
		{
			w !,!,"Do not use without advice from the ISC support, use GUI instead.",!
			w "Some actions may cause a decrease in performance and/or data corruption",!
		}
		w !,"What do you want to do?",!
		w "  0)  Quit",!
		w "  1)  Create a FHIRServer Endpoint",!
		w "  2)  Add a profile package to an endpoint",!
		w "  3)  Display a FHIRServer Endpoint Configuration",!
		w "  4)  Configure a FHIRServer Endpoint",!
		w "  5)  Decommission a FHIRServer Endpoint",!
		w "  6)  Delete a FHIRServer Endpoint",!
		w "  7)  Update the CapabilityStatement Resource",!
		w "  8)  Index new SearchParameters for an Endpoint",!
		w "  9)  Upload a FHIR metadata package",!
		w "  10) Delete a FHIR metadata package",!
		Set choice = ..readNumber("Choose your Option", choice, $lb(0,10))
		try {
			if choice = 0 Return
			if choice = 1 Do ..CreateEndpoint() Continue
			if choice = 2 Do ..AddProfileToEndpoint() Continue
			if choice = 3 Do ..DisplayEndpoint() Continue
			if choice = 4 Do ..ConfigureEndpoint() Continue
			if choice = 5 Do ..DecommissionEndpoint() Continue
			if choice = 6 Do ..RemoveEndpoint() Continue
			if choice = 7 Do ..UpdateCapabilityStatement() Continue
			if choice = 8 Do ..ReIndex() Continue
			if choice = 9 Do ..CreateMetadata() Continue
			if choice = 10 Do ..DeleteMetadata() Continue
		} catch ex {
			w "Exception Encountered: ", $System.Status.DisplayError(ex.AsStatus()),!
			Do ex.StackAsArray(.stack)
			for ord=$Get(stack,0):-1:1 { 
				w "  ["_ord_"] -> ", $get(stack(ord)), " ", $get(stack(ord, "PLACE")),!
			}
		}
	}
}

ClassMethod Migrate(pInteract As %Boolean = 1)
{
	Set metadataConfigKey = "HL7v30"

	Set oldClass = "HS.FHIR.vSTU3.Repository.Resource.Abstract"
	
	Set info = ..SelectEndpoint("Choose the Target Endpoint")


	if info = "" {
		w "There are no endpoints supporting version " _ metadataConfigKey _ " to migrate to",!
		return
	}
	
	Set strategy = ##class(HS.FHIRServer.API.InteractionsStrategy).GetStrategyForEndpoint($LG(info,1))
	
	Set confirm = "You are about to migrate all version "_metadataConfigKey_" data in your FHIRServer. Proceed?"
	if ..readYesNo(confirm, 0, 1) {
		// Delete all the new data
		//Set options = 0
		//Do strategy.Delete(.options)

		// Copy data from the old table
		Do strategy.MigrateFromPre2020()
		//Do $classmethod(newClass, "CloneFHIRData", oldClass)
		
		// Reindex the new data
		//Set options("recreateIndices") = 1
		//Set options("verbose") = 1
		//o strategy.Update(.options)
}
}

ClassMethod ReIndex(pInteract As %Boolean = 1)
{
	Set epInfo = ..SelectEndpoint("For which Endpoint do you want to index the new SearchParameters?", 1)
	if epInfo="" {
		w "There are no existing FHIR Endpoints requiring indexing",!
		return
	}
	

	Set key = $LG(epInfo, 1)
	w "You are about to index new SearchParameters for endpoint ", key, !
	w "This operation may take a long time to complete.",!
	if ..readYesNo("Proceed?", 0, 1) {
		do ##class(HS.FHIRServer.Storage.Json.Tools.Index).upgradeServiceMetadata(key)
	}
}

ClassMethod CreateEndpoint(pInteract As %Boolean = 1)
{
	Set strategyClass = ..SelectStrategyClass()
	Set strategyKey = $parameter(strategyClass,"StrategyKey")

	Set packageList = ..SelectPackages()
	Set version = $Piece($LG(packageList),"@",2)
	
	Set tDefaultUrl = ..GetDefaultEndpoint(version)
	Set confirm = "Do you want to create the default repository endpoint, " _ tDefaultUrl _ "?"
	if ..readYesNo(confirm, 1, 0) {
		Set appUrl = tDefaultUrl
	} else {
		Set appUrl = ..readString("Enter the endpoint URL starting with '/'","",1)
	}
	
	Set oauthClientName = ..readString("Enter the OAuth Client Name for this Endpoint (if any)","",0)

	Set confirm = "Do you want to create separate database files for your FHIR data?"
	Set resourceDBPath = ""
	Set versionDBPath = ""
	Set createDbFiles = ..readYesNo(confirm, 1, 0) 
	if createDbFiles {
		Set defaultPath = ##class(%File).NormalizeDirectory($system.Util.InstallDirectory() _ "mgr")

		Set resourceDBPath = ..readString("Enter the directory path where the FHIR Resource database will be created",defaultPath,1)
		Set versionDBPath = ..readString("Enter the directory path where the FHIR Version database will be created",defaultPath,1)
	}
	

	w "You are about to create a new endpoint",!
	w "  CSP url:    ", appUrl,!
	w "  Packages:   ", $LTS(packageList,", "),!
	if createDbFiles {
		w "  ResourceDb: ", resourceDBPath,!
		w "  VersionDb:  ", versionDBPath,!
	}
	
	if ..readYesNo("Proceed?", 0, 0) {
		Do ##class(HS.FHIRServer.Installer).InstallInstance(appUrl, strategyClass, packageList, oauthClientName,,createDbFiles, resourceDBPath, versionDBPath)
	}
}

ClassMethod GetDefaultEndpoint(versionNum As %String) As %String
{
	Set baseUrl = "/csp/healthshare/"_$ZConvert($Namespace, "L")_"/fhir/r" _ $E(versionNum)
	Set url = baseUrl
	Set suffixchar = 96	// 'a' - 1
	while $IsObject(##class(HS.FHIRServer.ServiceAdmin).GetInstanceForEndpoint(url))
	{
		Set url = baseUrl _ $Char($I(suffixchar))
	}
	return url
}

ClassMethod AddProfileToEndpoint(pInteract As %Boolean = 1)
{
	Set list = ##class(HS.FHIRServer.API.InteractionsStrategy).GetEndpointInfo()
	Set CHOICES = 0
	for ord=1:1:$LL(list) {
		Set info = $LG(list, ord)
		Set serviceId = $LG(info,5)
		Set available = ##class(HS.FHIRServer.ServiceInstance).GetAvailableProfiles(serviceId)
		if available '= "" {
			Set CHOICES($I(CHOICES)) = $LB(info,available)
		}
	}
	if CHOICES = 0 {
		w "There are no applicable profiles for any endpoints",!
		Quit
	}
	w "There are profiles available for these endpoints ...",!
	for ord=1:1:CHOICES {
		Set info = $LG(CHOICES(ord),1)	
		set url = $Select($LG(info,1)'="":$LG(info,1), 1:"(no url)")
		w "  ", ord, ") ", url," [" _ $case($lg(info, 4), 1:"enabled", 0: "disabled") _ "] (for Strategy '", $LG(info,2), "' and Metadata Set '",  $LG(info,3),"')",!
	}
	Set epChoice = ..readNumber("Choose the Endpoint to update", 1, $lb(1,CHOICES))
	set info = $LG(CHOICES(epChoice),1)
	Set serviceId = $LG(info, 5)
	set available = $LG(CHOICES(epChoice),2)
	set count=$LL(available)
	for ord=1:1:count {
		w "  ",	ord,") ",$LG(available, ord),!
	}
	Set prompt = "Enter any profile numbers (separated by a comma), or press enter to cancel"
	Set itemList = ..readNumber(prompt, "", $lb(1,count), 1)
	set lix = 0
	set profileList = ""
	while $ListNext(itemList, lix, itemNum) {
		Set $List(profileList,*+1) = $LG(available, itemNum)
	}
	Do ##class(HS.FHIRServer.Installer).AddPackagesToInstance(serviceId, profileList)
}

ClassMethod DecommissionEndpoint(pInteract As %Boolean = 1)
{
	Set epInfo = ..SelectEndpoint("Which Endpoint do you want to decommission?")
	if epInfo="" {
		w "There are no existing FHIR Endpoints",!
		return
	}
	Set appKey = $LG(epInfo, 1)
	Set serviceId = $LG(epInfo,5)
	
	Set confirm = "You are about to Decommission the endpoint '"_appKey_"'.  Resource data will be preserved, but FHIR operations will no longer be available.  Proceed?"
	if ..readYesNo(confirm, 0, 1) {
		Do ##class(HS.FHIRServer.Installer).DecommissionInstance(serviceId)
	}
}

ClassMethod RemoveEndpoint(pInteract As %Boolean = 1)
{
	Set epInfo = ..SelectEndpoint("Which Endpoint do you want to remove?")
	if epInfo="" {
		w "There are no existing FHIR Endpoints",!
		return
	}
	Set appKey = $LG(epInfo, 1)
	Set strategyKey = $LG(epInfo,2)
	Set metadataConfigKey = $LG(epInfo,3)
	Set serviceId = $LG(epInfo,5)
	
	Set confirm = "Do you want to delete all FHIR version "_ metadataConfigKey _ " data with strategy '" _ strategyKey_"'?"
	Set deleteData = ..readYesNo(confirm, 0, 1)

	Set confirm = "You are about to DELETE the endpoint '"_appKey_"' and " _ $Select(deleteData:"DELETE", 1:"PRESERVE") _ " all FHIR data.  Proceed?"
	if ..readYesNo(confirm, 0, 1) {
		Do ##class(HS.FHIRServer.Installer).UninstallInstance(appKey, deleteData)
	}
}

ClassMethod DisplayEndpoint(pInteract As %Boolean = 1)
{
	Set epInfo = ..SelectEndpoint("Which Endpoint do you want to display?")
	if epInfo="" {
		w "There are no existing FHIR Endpoints",!
		return
	}
	Set appKey = $LG(epInfo, 1)
	#dim strategy as HS.FHIRServer.API.InteractionsStrategy = ##class(HS.FHIRServer.API.InteractionsStrategy).GetStrategyForEndpoint(appKey)
	Set cspConfigObj = ##class(HS.Util.RESTCSPConfig).URLIndexOpen(appKey)
	Do ##class(HS.FHIRServer.Tools.ConfigEditor).showCSPConfigs( cspConfigObj, strategy.GetServiceConfigData())
}

ClassMethod ConfigureEndpoint(pInteract As %Boolean = 1)
{
	Set epInfo = ..SelectEndpoint("Which Endpoint do you want to configure?")
	if epInfo="" {
		w "There are no existing FHIR Endpoints",!
		return
	}
	Set appKey = $LG(epInfo, 1)
	#dim strategy as HS.FHIRServer.API.InteractionsStrategy = ##class(HS.FHIRServer.API.InteractionsStrategy).GetStrategyForEndpoint(appKey)
	Set cspConfigObj = ##class(HS.Util.RESTCSPConfig).URLIndexOpen(appKey)
	set serviceConfigObj = strategy.GetServiceConfigData()
	
	set isEnabled = $lg(epInfo, 4)
	set enable = ..readYesNo("Endpoint enabled", isEnabled , 0)
	set changed = (isEnabled '= enable)
	set changed = ##class(HS.FHIRServer.Tools.ConfigEditor).editCSPConfigObj( cspConfigObj ) || changed
	set changed = ##class(HS.FHIRServer.Tools.ConfigEditor).editServiceConfigObj( serviceConfigObj ) || changed
	if changed && ..readYesNo("Save Changes?", 1, 1) {
		$$$ThrowOnError( cspConfigObj.%Save()) 
		Do strategy.SaveServiceConfigData(serviceConfigObj)
		Do strategy.SetEnabled(appKey, enable)

		w "Changes have been saved",!
	}
}

ClassMethod UpdateCapabilityStatement(pInteract As %Boolean = 1)
{
	Set epInfo = ..SelectEndpoint("For which Endpoint do you want to update the CapabilityStatement?")
	if epInfo="" {
		w "There are no existing FHIR Endpoints",!
		return
	}
	Set key = $LG(epInfo, 1)

	#dim strategy as HS.FHIRServer.API.InteractionsStrategy = ##class(HS.FHIRServer.API.InteractionsStrategy).GetStrategyForEndpoint(key)
	if '$IsObject(strategy) {
		$$$ThrowFHIR($$$GeneralError, "Unable to create Storage Strategy Class")
	}
	Set interactions = strategy.NewInteractionsInstance()
	
	Set confirm = "Update the "_key_" service CapabilityStatement to reflect the endpoint strategy. Proceed?"
	if ..readYesNo(confirm, 0, 1) {
		do interactions.SetMetadata( strategy.GetMetadataResource() )
	}
}

ClassMethod CreateMetadata(pInteract As %Boolean = 1)
{
	w "The following packages are installed:",!
	Set packages = ##class(HS.FHIRMeta.Storage.Package).GetAllPackages()
	
	for ord=1:1:packages.Count() {
		set pkg = packages.GetAt(ord)
		Set SORT(pkg.coreVersion _ $Select(pkg.type="fhir.core":"", 1:ord)) = pkg
	}
	Set ix=""
	for {
		Set ix=$Order(SORT(ix),1,pkg)
		Quit:ix=""
		w $Select(pkg.type="fhir.core":"[core] ",1:"[custom for "_pkg.coreVersion_"] "), pkg.id, ": ", pkg.description,!
		set ALL(pkg.id) = ""
	}
	Set rootDir = ..readString("Enter the path to a directory containing one or more metadata packages (or return to exit)","",0)
	Quit:rootDir=""
	
	Set dirList = ##class(HS.FHIRMeta.Load.NpmLoader).findPackages(rootDir)
	if $ll(dirList) = 0 {
		w "No metadata package directories could be located under ",rootDir,!
		Quit
	}
	set lix=0
	set overwrite = 0
	w "Found packages: ",!
	while $ListNext(dirList, lix, packageDir) {
		Set packagePath = ##class(%File).NormalizeFilename("package.json", packageDir)
		Set jpackage = ##class(%DynamicObject).%FromJSON(packagePath)
		set packageId = jpackage.name _ "@" _ jpackage.version
		if $D(ALL(packageId)) {
			set overwrite = 1
		}
		w "  ",packageId,!
	}
	if overwrite=1 {
		set confirm = "Do you want to reload existing packages (y), or keep the current ones(n)?"
		set overwrite = ..readYesNo(confirm, 0, 0)	
	}
	set confirm = "Proceed?"
	if ..readYesNo(confirm, 1, 0) {
		do ##class(HS.FHIRMeta.Load.NpmLoader).importPackages(dirList)
	}
}

ClassMethod DeleteMetadata(pInteract As %Boolean = 1)
{
	Set packageId = ..SelectDeleteablePackage()
	if packageId '= "" {
		Set confirm = "You are about to DELETE the metadata package '"_packageId_"'. Proceed?"
		if ..readYesNo(confirm, 0, 1) {
			Do ##class(HS.FHIRMeta.Load.NpmLoader).UninstallPackage(packageId)
			write "Metadata set deleted",!
		}
	} else {
		write !,"All installed FHIR Metadata packages are in use by at least one endpoint and cannot be deleted",!
	}
}

ClassMethod SelectStrategyClass() As %String
{
	Do ##class(HS.FHIRServer.API.InteractionsStrategy).GetStrategyList(.sl)
	Set keyList = 0
	Set key = ""
	for {
		Set key = $Order(sl(key))
		Quit:key=""
		
		Set keyList($I(keyList)) = key
		w "  " _ keyList _ ") " _ key _ " (" _ sl(key, "desc"), ")", !
	}
	Set key = keyList( ..readNumber("Choose the Storage Strategy", 1, $lb(1,keyList)) )
	//w "Selected key " _ key,!
	return sl(key)
}

ClassMethod SelectPackages() As %List
{
	#dim corePackage as HS.FHIRMeta.Storage.Package = ..SelectCorePackage("Choose the FHIR version for this endpoint")
	return ..SelectCustomPackages(corePackage.id, "Enter any package numbers (separated by a comma) or press enter to skip")
}

ClassMethod SelectCustomPackages(corePackageId As %String, prompt As %String) As %List
{
	Set packageList = $LB(corePackageId)
	Set profileList = ##class(HS.FHIRMeta.Storage.Package).GetCustomPackages(corePackageId)
	if profileList.Count() {
		w "The following profile packages are available:",!
		for ord=1:1:profileList.Count() {
			Set package = profileList.GetAt(ord)
			w "  ", ord,") ", package.name, " version ",package.version," (", package.description,")",!
		}	
		Set itemList = ..readNumber(prompt, "", $lb(1,profileList.Count()), 1)
		set lix = 0
		while $ListNext(itemList, lix, itemNum) {
			Set $List(packageList,*+1) = profileList.GetAt(itemNum).id	
		}
	}
	return packageList
}

ClassMethod SelectDeleteablePackage() As %String
{
	Set packages = ##class(HS.FHIRMeta.Storage.Package).GetAllPackages()
	Set count = packages.Count()
	Set choices = 0
	for ord=1:1:count {
		#dim package as HS.FHIRMeta.Storage.Package = packages.GetAt(ord)
		if $$$ISOK(##class(HS.FHIRServer.ServiceAdmin).CanDeleteMetadataPackage(package.id)) {
			if choices = 0 {
				Set choices($I(choices)) = ""
				w "The following packages are not currently in use by an endpoint and may be deleted",!
				w "  1) Cancel - do not delete anything",!

			}
			Set choices($I(choices)) = package.id
			w "  ", choices, ") ", package.name," version ",package.version," (",  package.title,")",!
		}
	}
	if choices = 0 {
		return ""
	}
	Set prompt = "Select the package to delete"
	Set itemNum = ..readNumber(prompt, 1, $lb(1,choices))
	Return choices(itemNum)
}

ClassMethod SelectCorePackage(prompt As %String) As HS.FHIRMeta.Storage.Package
{
	Set packages = ##class(HS.FHIRMeta.Storage.Package).GetCorePackages()
	Set count = packages.Count()
	for ord=1:1:count {
		#dim package as HS.FHIRMeta.Storage.Package = packages.GetAt(ord)
		w "  ", ord, ") ", package.name," version ",package.version," (",  package.description,")",!
	}
	Set itemNum = ..readNumber(prompt, 1, $lb(1,count))
	Return packages.GetAt(itemNum)
}

ClassMethod SelectEndpoint(prompt As %String, needIndexing As %Boolean = 0) As %String
{
	Set epList = ""
	Set list = ##class(HS.FHIRServer.API.InteractionsStrategy).GetEndpointInfo("")
	set lix = 0
	while $ListNext(list, lix, info) {
		if needIndexing {
			Set changeList = ##class(HS.FHIRServer.Storage.Json.SearchColumn).getAddedParametersForServiceId($LG(info,5))
			Continue:changeList=""
		}
		w:epList="" !,prompt,!
		Set $List(epList,*+1) = info
		set url = $Select($LG(info,1)'="":$LG(info,1), 1:"(no url)")
		w "  ", $LL(epList), ") ", url," [" _ $case($lg(info, 4), 1:"enabled", 0: "disabled") _ "] (for Strategy '", $LG(info,2), "' and Metadata Set '",  $LTS($LG(info,3)),"')",!
	}
	if epList '= "" {
		Set itemNum = ..readNumber("Choose the Endpoint", 1, $lb(1,$ll(epList)))
		Return $LG(epList, itemNum)
	}
	return ""
}

}
