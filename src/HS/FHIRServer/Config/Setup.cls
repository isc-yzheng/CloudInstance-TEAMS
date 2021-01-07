Include HS.HC

Class HS.FHIRServer.Config.Setup Extends HSMOD.REST.Async.API
{

/// This method uses $$$HSThisNSType to determine whether we're in a
/// HealthShare or IRIS for Health/HC kit, for lack of a better option.
/// Ideally each kit has a configuration which defines its allowed
/// interactions
ClassMethod GetSetup() As %DynamicObject
{
	//Get all metadata sets and default urls
	set corePackages = ##class(HS.FHIRMeta.Storage.Package).GetCorePackages()
	set packageList = ""
	set defaultUrls = {}
	set packageDependencies = {}
	for i=1:1:corePackages.Count() {
		set package = corePackages.GetAt(i)
		
		set packageList = packageList _ $lb(package.id)
		set customPackages = ##class(HS.FHIRMeta.Storage.Package).GetCustomPackages(package.id)
		set customPackageArray = []
		for j=1:1:customPackages.Count() {
			set customPackage = customPackages.GetAt(j)
			
			set packageList = packageList _ $lb(customPackage.id)
			do customPackageArray.%Push(customPackage.id)
		}
		do defaultUrls.%Set(package.id, ##class(HS.FHIRServer.ConsoleSetup).GetDefaultEndpoint($E(package.coreVersion)))
		do packageDependencies.%Set(package.id, customPackageArray)
	}
	
	Set isDevMode = $get(^HS.FHIRServer("dev"))
	Set isODSNamespace = ($$$HSThisNSType = "FlashGateway")
	
	set deleteType = {}
	set endpointList = ##class(HS.FHIRServer.ServiceAdmin).GetEndpointList()
	set ptr = 0
	while $listnext(endpointList, ptr, endpoint) {
		if isODSNamespace {
			do deleteType.%Set(endpoint, "decommission")
		}
		else {
			do deleteType.%Set(endpoint, "delete")
		}
	}
	
	//Get all interactions strategies
	Do ##class(HS.FHIRServer.API.InteractionsStrategy).GetStrategyList(.strategyNodes)
	set strategyList = ""
	set strategyKey = ""
	for {
		set strategyKey = $order(strategyNodes(strategyKey))
		quit:strategyKey=""
		set class = strategyNodes(strategyKey)
		if isODSNamespace && 'isDevMode {
			// In production in an ODS namespace, only show ODS strategy.
			if strategyKey '= "ODS" continue
		}
		
		set strategyList = strategyList _ $lb(class)
	}
	
	set serviceConfigData = {}
	set serviceConfigData."fhir_version" = ..NewSettingsObject(1, 0)
	set serviceConfigData."fhir_metadata_set" = ..NewSettingsObject(1, 1, packageList)
	set serviceConfigData."interactions_strategy_class" = ..NewSettingsObject(1, 1, strategyList)
	set serviceConfigData."default_search_page_size" = ..NewSettingsObject(1, 1)
	set serviceConfigData."max_search_page_size" = ..NewSettingsObject(1, 1)
	set serviceConfigData."max_search_results" = ..NewSettingsObject(1, 1)
	set serviceConfigData."fhir_session_timeout" = ..NewSettingsObject(1, 1)
	set serviceConfigData."default_prefer_handling" = ..NewSettingsObject(1, 1, $lb("lenient", "strict"))
	set serviceConfigData."required_resource" = ..NewSettingsObject(1, 1)
	if isODSNamespace {
		set serviceConfigData."max_conditional_delete_results" = ..NewSettingsObject(0, 0)
		set serviceConfigData."debug_mode" = ..NewSettingsObject(0, 0)
	}
	else {
		set serviceConfigData."max_conditional_delete_results" = ..NewSettingsObject(1, 1)
		set serviceConfigData."debug_mode" = ..NewSettingsObject(1, 1)
	}
	if isDevMode {
		set serviceConfigData."debug_mode" = ..NewSettingsObject(1, 1)
	}
	
	set cspConfig = {}
	if isODSNamespace {
		set cspConfig."oauth_client_name" = ..NewSettingsObject(0, 0)
		set cspConfig."service_config_name" = ..NewSettingsObject(0, 0)
	}
	else {
		set cspConfig."oauth_client_name" = ..NewSettingsObject(1, 1)
		set cspConfig."service_config_name" = ..NewSettingsObject(1, 1)
	}
	
	set setup = {}
	set setup.defaults = {}
	set setup.defaults.urls = defaultUrls
	set setup.defaults."delete_type" = deleteType
	set setup.defaults."custom_packages" = packageDependencies
	set setup.defaults."db_directory" = $system.Util.ManagerDirectory()
	set setup.settings = {}
	set setup.settings.enabled = ..NewSettingsObject(1, 1)
	set setup.settings."rsrc_db_location" = ..NewSettingsObject(1, 1)
	set setup.settings."ver_db_location" = ..NewSettingsObject(1, 1)
	set setup.settings."service_config_data" = serviceConfigData
	set setup.settings."csp_config" = cspConfig
	
	set pendingEndpoints = ..ReturnPendingEndpoints(1)
	if $isobject(pendingEndpoints) {
		set setup."pending_endpoints" = pendingEndpoints
	}
	
	return setup
}

ClassMethod NewSettingsObject(read As %Boolean, write As %Boolean, valueset As %List = "") As %DynamicObject
{
	set obj = {}
	do obj.%Set("display", read, "boolean")
	do obj.%Set("modify", write, "boolean")
	if valueset '= "" {
		set obj.valueset = ..ListToJson(valueset)
	}
	
	return obj
}

ClassMethod ListToJson(list As %List) As %DynamicAbstractObject
{
	if $listvalid($listget(list, 1)) && $listlength($listget(list, 1)) > 0 {
		set vs = {}
		for i=1:1:$listlength(list) {
			set item = $listget(list, i)
			set name = $listget(item, 1)
			set values = $listfromstring($piece($listtostring(item), ",", 2, *))
			do vs.%Set(name, ..ListToJson(values))
		}
	}
	else {
		set vs = []
		for i=1:1:$listlength(list) {
			do vs.%Push($listget(list, i))
		}
	}
	
	return vs
}

ClassMethod ReturnPendingEndpoints(clearCompleted As %Boolean, name As %String = "") As %DynamicArray
{
	set records = ..GetJobRecords()
	
	set openJobs = []
	for i=1:1:records.Count() {
		set record = records.GetAt(i)
		if (record.Classname '= "HS.FHIRServer.Installer") ||
			((record.MethodName '= "InstallInstance") && (record.MethodName '= "UpdateInstance")) ||
			(record.Namespace '= $namespace) {
			continue
		}
		if clearCompleted && (record.Status = $$$JobComplete) {
			$$$ThrowOnError(##class(HSMOD.REST.Async.JobRecord).%DeleteId(record.%Id()))
			continue
		}
		
		if name '= "" {
			if $listget(record.ArgumentList, 1) '= name {
				continue
			}
		}
		
		do openJobs.%Push(..JobRecordToJson(record))
		
		if clearCompleted && ((record.Status = $$$JobError) || (record.Status = $$$JobInternalError)) {
			$$$ThrowOnError(##class(HSMOD.REST.Async.JobRecord).%DeleteId(record.%Id()))
		}
	}
	if openJobs.%Size() = 0 {
		return ""
	}
	
	return openJobs
}

ClassMethod JobRecordToJson(jobRecord As HSMOD.REST.Async.JobRecord) As %DynamicObject
{
	set json = {}
	set json."job_key" = jobRecord.JobKey
	set json.status = jobRecord.Status
	set json.name = $listget(jobRecord.ArgumentList, 1)
	if jobRecord.Result.Size > 0 {
		set json.result = ##class(%DynamicAbstractObject).%FromJSON(jobRecord.Result)
	}
	return json
}

}
