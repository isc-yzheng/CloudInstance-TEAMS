Include (HS.FHIRServer, %occErrors, HS.HC)

Class HS.FHIRServer.Config.RestHandler Extends HSMOD.REST.Base
{

Parameter HandleCorsRequest As %Integer = 1;

XData UrlMap
{
<Routes>
<Map Prefix="/auth"		Forward="HSMOD.Authentication.RESTSession.API"/>
<Map Prefix="/fhirlog"	Forward="HS.FHIRServer.Config.FHIRLogHandler"/>
<Route Url="/setup"						Method="GET"	Call="GetPageSetup" />

<Route Url="/package"					Method="GET"	Call="GetPackages" />
<Route Url="/package"					Method="POST"	Call="UploadPackage" />
<Route Url="/package/saved/:id"			Method="GET"	Call="PackageSaved" />

<Route Url="/endpoint"					Method="GET"	Call="GetEndpoints" />
<Route Url="/endpoint"					Method="POST"	Call="AddEndpoint" />
<Route Url="/endpoint"					Method="PUT"	Call="UpdateEndpoint" />
<Route Url="/endpoint"					Method="DELETE"	Call="DeleteEndpoint" />
<Route Url="/endpoint/decommission"		Method="POST"	Call="DecommissionEndpoint" />
<Route Url="/endpoint/pending/:jobKey"	Method="GET"	Call="GetPendingEndpoint" />
<Route Url="/endpoint/setup"			Method="GET"	Call="GetEndpointSetup" />
</Routes>
}

ClassMethod UploadPackage() As %Status
{
	try {
		set packageJSON = {}.%FromJSON(%request.Content)
		set forceDir = 0
		if $data(%request.Data("force", 1)) {
			set forceDir = $case(%request.Data("force", 1), "true":1, "false":0, :-1)
			if forceDir = -1 {
				set %response.Status = ..#HTTP400BADREQUEST
				set %response.ContentType = ..#CONTENTTYPETEXT
				write "force URL parameter must be 'true' or 'false'"
				quit
			}
		}
		
		//Create directory for custom packages
		set customPackagesPath = ##class(%Library.File).NormalizeDirectory($system.Util.InstallDirectory()_"dev/fhir/fhir-metadata/custom-packages")
		if ##class(%Library.File).DirectoryExists(customPackagesPath)=0 {
			do ##class(%Library.File).CreateDirectory(customPackagesPath)
		}
		
		//Find package name
		set iterator = packageJSON.%GetIterator()
		set packageName = ""
		while iterator.%GetNext(, .fileObject ) {
			if fileObject.name = "package.json" {
				set packageName = fileObject.data.name_"@"_fileObject.data.version
			}	
		}
		if packageName = "" {
			set %response.Status = ..#HTTP400BADREQUEST
			write "ERROR: Package name not found."
			return $$$OK
		}
		set packagePath = ##class(%Library.File).NormalizeDirectory(customPackagesPath_"/"_packageName)
		set existsDir = ##class(%Library.File).DirectoryExists(packagePath)
		
		//Create package directory if needed
		if (existsDir) && (forceDir) {
			set createDir = 1
			do ##class(%Library.File).RemoveDirectory(packagePath)
		} elseif (existsDir) && (forceDir = 0) {
			set createDir = 0
		} else {
			set createDir = 1
		}
		
		if createDir {
			do ##class(%Library.File).CreateDirectory(packagePath)
			//Unpack JSON objects		
			set iterator = packageJSON.%GetIterator()
			while iterator.%GetNext(.key , .fileObject ) {
				set fileName = ##class(%Library.File).NormalizeFilename(fileObject.name,packagePath)
    			set fileStream = ##class(%Stream.FileCharacter).%New()
				$$$ThrowOnError(fileStream.LinkToFile(fileName))
				do fileObject.data.%ToJSON(.fileStream)
				$$$ThrowOnError(fileStream.%Save())
			}
		}
    	
		//Import package
		$$$StartCapture(.cookieId)
		do ##class(HS.FHIRMeta.Load.NpmLoader).importPackages(packagePath)
		$$$EndCapture(cookieId)
		do ..EmitResult("")
		
	} catch ex {
		$$$EndCapture(cookieId)
		do ..EmitErrorResult(ex.AsStatus())
	}
	return $$$OK
}

ClassMethod GetPackages() As %Status
{
	try {
		set list = ##class(HS.FHIRMeta.Storage.Package).GetAllPackagesJSON()
		do ..EmitResult(list)
		
	} catch ex {
		do ..EmitErrorResult(ex.AsStatus())
	}
	
	return $$$OK
}

/// A package can be on the server (on disk) without being installed
/// in this namespace. This allows the user to know what to set the "force"
/// flag to before uploading a package to this namespace.
ClassMethod PackageSaved(id As %String) As %Status
{
	try {
		set path = ##class(%Library.File).NormalizeDirectory($system.Util.InstallDirectory()_"dev/fhir/fhir-metadata/custom-packages/" _ id)
		set response = {
			"package_id": (id)
		}
		do response.%Set("exists", ##class(%Library.File).DirectoryExists(path), "boolean")
		do ..EmitResult(response)
	} catch ex {
		do ..EmitErrorResult(ex.AsStatus())
	}
	
	return $$$OK
}

ClassMethod GetEndpoints() As %Status
{
	try {
		set array = []
		
		set list = ##class(HS.FHIRServer.API.InteractionsStrategy).GetEndpointInfo()
		
		set pendingEndpoints = ##class(HS.FHIRServer.Config.Setup).ReturnPendingEndpoints(0)
		set ptr = 0
		while $listnext(list, ptr, entry) {
			set url = $listget(entry, 1)
			if url [ "svc:" continue //Endpoints without a URL aren't active, in process of being generated
			set endpoint = ..SerializeEndpoint(url, pendingEndpoints)
			if endpoint '= "" {
				do array.%Push(endpoint)
			}
		}
		
		do ..EmitResult(array)
	} catch ex {
		do ..EmitErrorResult(ex.AsStatus())
	}
	
	return $$$OK
}

/// Creates a new FHIRServer endpoint, or updates the existing one if already present.
/// The endpoint creation can take >1min, so it will be done async and return a job
/// reference that the client can poll for status
ClassMethod AddEndpoint() As %Status
{
	try {
		set endpoint = {}.%FromJSON(%request.Content)
		
		set output = {}
		
		//First check to see if the endpoint is currently being modified
		set pending = ##class(HS.FHIRServer.Config.Setup).ReturnPendingEndpoints(0, endpoint.name)
		if $isobject(pending) {
			set output.job = pending.%Get(0)
			do ..EmitResult(output)
			return $$$OK
		}
		
		if '..ValidateNewEndpoint(endpoint) {
			set %response.Status = ..#HTTP400BADREQUEST
			return $$$OK
		}
		
		set createDBs = ((endpoint."rsrc_db_location" '= "") || (endpoint."ver_db_location" '= ""))
		
		set name = endpoint.name
		set interactionsStrategy = endpoint."service_config_data"."interactions_strategy_class"
		set metadataSet = endpoint."service_config_data"."fhir_metadata_set"
		
		set jobKey = ##class(HS.FHIRServer.Config.Setup).RunInBackgroundAndReturnJobKey("HS.FHIRServer.Installer", "InstallInstance", name, interactionsStrategy, $listfromstring(metadataSet),"","", createDBs, endpoint."rsrc_db_location", endpoint."ver_db_location")
		set job = ##class(HS.FHIRServer.Config.Setup).JobRecordToJson(##class(HS.FHIRServer.Config.Setup).GetJobRecordFromKey(jobKey))
		set output.job = job
		
		do ..EmitResult(output)
	}
	catch ex {
		do ..EmitErrorResult(ex.AsStatus())
	}
	
	return $$$OK
}

/// Creates a new FHIRServer endpoint, or updates the existing one if already present.
/// The endpoint creation can take >1min, so it will be done async and return a job
/// reference that the client can poll for status
ClassMethod UpdateEndpoint() As %Status
{
	try {
		set endpoint = {}.%FromJSON(%request.Content)
		
		set output = {}
		
		//First check to see if the endpoint is currently being modified
		set pending = ##class(HS.FHIRServer.Config.Setup).ReturnPendingEndpoints(0, endpoint.name)
		if $isobject(pending) {
			set output.job = pending.%Get(0)
			do ..EmitResult(output)
			return $$$OK
		}
		
		if '..ValidateExistingEndpoint(endpoint) {
			set %response.Status = ..#HTTP400BADREQUEST
			return $$$OK
		}
		
		set strategy = ##class(HS.FHIRServer.API.InteractionsStrategy).GetStrategyForEndpoint(endpoint.name)
		set oldConfigData = strategy.GetServiceConfigData()
		
		set configData = ##class(HS.FHIRServer.API.ConfigData).%New()
		$$$ThrowOnError(configData.%JSONImport(endpoint."service_config_data"))
		
		//Updating the packages can take a while, work async and return a job id
		if oldConfigData.FHIRMetadataSet '= configData.FHIRMetadataSet {
			set jobKey = ##class(HS.FHIRServer.Config.Setup).RunInBackgroundAndReturnJobKey("HS.FHIRServer.Installer", "UpdateInstance", endpoint.name, endpoint."service_config_data".%ToJSON(), endpoint.enabled, endpoint."csp_config"."service_config_name", endpoint."csp_config"."oauth_client_name")
			set job = ##class(HS.FHIRServer.Config.Setup).JobRecordToJson(##class(HS.FHIRServer.Config.Setup).GetJobRecordFromKey(jobKey))
			set output.job = job
		}
		//If we don't need to update the packages, can do the update and return immediately
		else {
			do ##class(HS.FHIRServer.Installer).UpdateInstance(endpoint.name, endpoint."service_config_data".%ToJSON(), endpoint.enabled, endpoint."csp_config"."service_config_name", endpoint."csp_config"."oauth_client_name")
			set output.endpoint = ..SerializeEndpoint(endpoint.name)
		}
		
		do ..EmitResult(output)
	}
	catch ex {
		do ..EmitErrorResult(ex.AsStatus())
	}
	
	return $$$OK
}

ClassMethod DecommissionEndpoint() As %Status
{
	try {
		$$$StartCapture(.cookieId)
		set endpoint = {}.%FromJSON(%request.Content)
		
		do ##class(HS.FHIRServer.Installer).DecommissionInstance(##class(HS.FHIRServer.ServiceAdmin).GetInstanceIdForEndpoint(endpoint.name))
		
		$$$EndCapture(cookieId)
		do ..EmitResult("")
	} catch ex {
		$$$EndCapture(cookieId)
		do ..EmitErrorResult(ex.AsStatus())
	}
	
	return $$$OK
}

ClassMethod DeleteEndpoint() As %Status
{
	try {
		$$$StartCapture(.cookieId)
		set endpoint = {}.%FromJSON(%request.Content)
		
		do ##class(HS.FHIRServer.Installer).UninstallInstance(endpoint.name, endpoint."delete_data")
		
		$$$EndCapture(cookieId)
		do ..EmitResult("")
	} catch ex {
		$$$EndCapture(cookieId)
		do ..EmitErrorResult(ex.AsStatus())
	}
	
	return $$$OK
}

ClassMethod GetPendingEndpoint(jobKey As %String) As %Status
{
	try {
		set jobRecord = ##class(HS.FHIRServer.Config.Setup).GetJobRecordFromKey(jobKey)
		if $isobject(jobRecord) {
			do ..EmitResult(##class(HS.FHIRServer.Config.Setup).JobRecordToJson(jobRecord))
		}
		else {
			do ..EmitResult()
		}
	} catch ex {
		do ..EmitErrorResult(ex.AsStatus())
	}
	
	return $$$OK
}

ClassMethod GetEndpointSetup() As %Status
{
	try {
		set setup = ##class(HS.FHIRServer.Config.Setup).GetSetup()
		
		do ..EmitResult(setup)
	} catch ex {
		do ..EmitErrorResult(ex.AsStatus())
	}
	
	return $$$OK
}

ClassMethod GetPageSetup() As %Status
{
	try {
		set setup = {}
		try {
			//If HealthShare is installed, get the version. Otherwise catch to the standard version code
			Set version = ##class(%ZHSLIB.HealthShareMgr).VersionInfo()
		} Catch {
			Set version = $System.Version.GetVersion()
		}
		set setup."product_version" = version
		set setup."component_version" = ##class(HS.FHIRServer.Installer).#ConfigVersion
		
		do ..EmitResult(setup)
	} catch ex {
		do ..EmitErrorResult(ex.AsStatus())
	}
	
	return $$$OK
}

ClassMethod ValidateNewEndpoint(endpoint As %DynamicObject) As %Boolean
{
	if ##class(HS.FHIRServer.ServiceAdmin).EndpointExists(endpoint.name) {
		return 0
	}
	
	set settings = ##class(HS.FHIRServer.Config.Setup).GetSetup().settings
	
	if '$isobject(endpoint."service_config_data") {
		return 0
	}
	
	set name = endpoint.name
	set interactionsStrategy = endpoint."service_config_data"."interactions_strategy_class"
	set metadataSet = endpoint."service_config_data"."fhir_metadata_set" 
	if (name = "") || (interactionsStrategy = "") || (metadataSet = "") {
		return 0
	}
	
	//Check the required settings are allowed in this namespace
	set found = 0
	for i=0:1:settings."service_config_data"."interactions_strategy_class".valueset.%Size()-1 {
		if interactionsStrategy = settings."service_config_data"."interactions_strategy_class".valueset.%Get(i) {
			set found = 1
		}
	}
	if 'found {
		return 0
	}
	
	for i=1:1:$length(metadataSet, ",") {
		set package = $piece(metadataSet, ",", i)
		set found = 0
		for j=0:1:settings."service_config_data"."fhir_metadata_set".valueset.%Size()-1 {
			if package = settings."service_config_data"."fhir_metadata_set".valueset.%Get(j) {
				set found = 1
			}
		}
		if 'found {
			return 0
		}
	}
	
	return 1
}

ClassMethod ValidateExistingEndpoint(endpoint As %DynamicObject) As %Boolean
{
	if '##class(HS.FHIRServer.ServiceAdmin).EndpointExists(endpoint.name) {
		return 0
	}
	
	//Check updates are only changing things than can be changed
	$$$ThrowOnError(##class(HS.FHIRServer.API.InteractionsStrategy).GetServiceConfigDataForEndpoint(endpoint.name).%JSONExportToString(.string))
	set currentConfig = {}.%FromJSON(string)
	
	set settings = ##class(HS.FHIRServer.Config.Setup).GetSetup().settings
	
	if '$isobject(endpoint."service_config_data") {
		return 0
	}
	
	set iter = settings."service_config_data".%GetIterator()
	while iter.%GetNext(.name, .value) {
		if (value.modify = 0) && (currentConfig.%Get(name) '= endpoint."service_config_data".%Get(name)) {
			return 0
		}
	}
	
	set restConfigObj = ##class(HS.Util.RESTCSPConfig).URLIndexOpen(endpoint.name)
	if (settings."csp_config"."oauth_client_name".modify = 0) && (restConfigObj.OAuthClientName '= endpoint."csp_config"."oauth_client_name") {
		return 0
	}
	if (settings."csp_config"."service_config_name".modify = 0) && (restConfigObj.ServiceConfigName '= endpoint."csp_config"."service_config_name") {
		return 0
	}
	
	return 1
}

ClassMethod SerializeEndpoint(url As %String, pendingEndpoints As %DynamicArray = "") As %DynamicObject
{
	//Only attempt to serialize endpoints that aren't still trying to install
	if pendingEndpoints '= "" {
		set iter = pendingEndpoints.%GetIterator()
		while iter.%GetNext(, .pendingEndpoint) {
			set name = pendingEndpoint.name
			if name = url {
				return ""
			}
		}
	}
	set endpoint = {}
	set endpoint.name = url
	do endpoint.%Set("enabled",##class(HS.FHIRServer.ServiceAdmin).IsEndpointEnabled(url), "boolean")
	
	set repo = ##class(HS.FHIRServer.ServiceAdmin).GetInstanceForEndpoint(url).repo
	set endpoint."rsrc_db" = repo.resourceDBName
	set endpoint."ver_db" = repo.versionDBName
	
	set configData = ##class(HS.FHIRServer.API.InteractionsStrategy).GetServiceConfigDataForEndpoint(url)
	$$$ThrowOnError(configData.%JSONExportToString(.json))
	set endpoint."service_config_data" = {}.%FromJSON(json)
	
	set cspConfig = ##class(HS.Util.RESTCSPConfig).URLIndexOpen(url)
	set cspConfigJson = {}
	set cspConfigJson."oauth_client_name" = cspConfig.OAuthClientName
	set cspConfigJson."service_config_name" = cspConfig.ServiceConfigName
	set endpoint."csp_config" = cspConfigJson
	
	return endpoint
}

/// Prints <var>pPayload</var> if it is not empty, else sets the response status to be 'No Content' </br>
ClassMethod EmitResult(pPayload As %DynamicAbstractObject = "")
{
	#dim %response As %CSP.Response
	If pPayload = "" {
		Set %response.Status = ..#HTTP204NOCONTENT
	} Else {
		Set %response.ContentType = ..#CONTENTTYPEJSON
		Write pPayload.%ToJSON()
	}
}

/// Constructs a JSON object and prints it using the error status in <var>pStatus</var> </br>
ClassMethod EmitErrorResult(pStatus As %Status)
{
	set message = $System.Status.GetErrorText(pStatus)
	set code = $System.Status.GetErrorCodes(pStatus)
	//Delete operation on a non-existant application should return a 204
	if code = $$$ApplicationDoesNotExist {
		do ..EmitResult("")
		return $$$OK
	}
	
	#dim %response As %CSP.Response
	#dim payload as %DynamicObject = ##class(%DynamicObject).%New()
	#dim error as %DynamicObject = ##class(%DynamicObject).%New()
	Do payload.%Set("error", error)
	Do error.%Set("message", message)
	Do error.%Set("code", code)
	
	Set %response.Status = ..#HTTP500INTERNALSERVERERROR
	Set %response.ContentType = ..#CONTENTTYPEJSON
	Write payload.%ToJSON()
}

}
