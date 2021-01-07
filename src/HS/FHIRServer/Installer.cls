Include (HS.HC, HS.FHIRServer)

Class HS.FHIRServer.Installer [ Abstract ]
{

Parameter uiUrl As COSEXPRESSION = """/csp/healthshare/"" _ $zconvert($namespace, ""L"") _ ""/fhirconfig""";

Parameter apiUrl As COSEXPRESSION = "..#uiUrl _ ""/api""";

/// @API
/// This method installs elements that are required for a FHIR-enabled namespace
/// <ol>
/// <li> All Intersystems-provided MetadataSet descriptors
/// <li> The endpoints for the Configuration UI App
/// </ol>
/// @Input namespace  Namespace to install the FHIR application.
ClassMethod InstallNamespace(namespace As %String = {$namespace})
{
	new $namespace
	set $namespace = namespace
	TSTART
	try {
		//Check we're in a valid namespace. HS.Util.Installer.ConfigItem will not include
		//library namespaces such as HSLIB and HSCUSTOM, and will not include namespaces
		//whose names include dash or percent characters.
		if '##class(HS.Util.Installer.ConfigItem).%ExistsId(namespace) {
			$$$ThrowFHIR($$$GeneralError, "FHIRServer cannot be installed in this type of namespace")
		}
		
		// Ensure that the namespace is marked as FHIR-enabled
		Do ##class(HS.FHIRServer.ServiceUpgrade).InitializeNamespaceConfig()
		
		// Make sure that our built-in metadata sets have been created
		Do ##class(HS.FHIRMeta.Impl.Base).bootstrapMetadataSets()
		
		set roleOrResourceChanged = 0
		
		// Ensure that the Database Resource %DB_<namespace> exists. If it already
		// exists, we do not want to alter it.
		set dbResource = "%DB_"_namespace
		if '..ResourceExists(dbResource) {
			set publicPermissions = ""
			set tSC = ##class(HS.Util.SystemAPI).Invoke("AddUpdateResource", namespace, dbResource, "The "_$Namespace_" database", publicPermissions)
			$$$ThrowOnError(tSC)
			set roleOrResourceChanged = 1
		}
		
		// Ensure that the Database Roles %DB_<namespace> and %HS_DB_<namespace> exist.
		// If they already exist, we do not want to alter them.
		for dbRole = "%DB_"_namespace, "%HS_DB_"_namespace {
			if '..RoleExists(dbRole) {
				set dbResource = "%DB_"_namespace_":RW"
				set tSC = ##class(HS.Util.SystemAPI).Invoke("AddUpdateRole", namespace, dbRole, "", dbResource)
				$$$ThrowOnError(tSC)
				set roleOrResourceChanged = 1
			}
		}
		
		// Ensure that the database for this namespace has %DB_<namespace> as its resource.
		set dbResourceToEnsure = "%DB_"_namespace
		set dbResourceCurrent = ##class(HS.Util.Installer.ConfigItem).GetDBResourceName(namespace)
		if dbResourceCurrent'=dbResourceToEnsure {
			set tSC = ##class(HS.Util.SystemAPI).Invoke("UpdateDatabaseResource", namespace, namespace, dbResourceToEnsure)
			//set tSC = ..UpdateDBResource(namespace, dbResourceToEnsure)
			$$$ThrowOnError(tSC)
			set roleOrResourceChanged = 1
		}
		
		set sqlProceduresList = $listbuild("HS_FHIRServer_Storage.ListFirst", "HS_FHIRServer_Storage.ListLast")
		set tSC = ..AddSQLProceduresToRole(namespace, "%DB_"_namespace, sqlProceduresList)
		$$$ThrowOnError(tSC)
		
		// If anything with the database resource or roles changed, examine the CSP
		// apps that should already exist - /csp/healthshare/<namespace> and
		// /csp/namespace/<namespace>/services - and ensure that they have the
		// proper database role.
		if roleOrResourceChanged {
			set roleToEnsure = "%HS_DB_"_namespace
			for cspAppName = "/csp/healthshare/"_$ZConvert(namespace,"L"), "/csp/healthshare/"_$ZConvert(namespace,"L")_"/services" {
				// Return format from GetCSPAppRoles is ":%DB_HSCUSTOM:%DB_HSLIB:%HS_DB_%DEFAULT:%HS_DB_HSSYS"
				set cspAppRoles = ..GetCSPAppRoles(cspAppName)
				if (cspAppRoles'="") && (cspAppRoles'[(":"_roleToEnsure)) {
					for i = 2:1:$Length(cspAppRoles,":") {
						set oneRole = $Piece(cspAppRoles,":",i)
						if oneRole'="" {
							if (..RoleExists(oneRole)) && (oneRole'="%DB_%DEFAULT") && (oneRole'="%HS_DB_%DEFAULT") {
								set roleArray(oneRole) = ""
							}
						}
					}
					set roleArray(roleToEnsure) = ""
					set roleString = ""
					set oneRole = ""
					for {
						set oneRole = $Order(roleArray(oneRole))
						if oneRole="" quit
						set roleString = roleString _ ":"_oneRole
					}
					Set tProps("MatchRoles") = roleString
					Set tSC = ##class(HS.Util.SystemAPI).Invoke("UpdateCSPApp", namespace, cspAppName, $$$NVPairToList(tProps), 1, "u")
					$$$ThrowOnError(tSC)
				}
			}
		}
		
		//Build UI and REST API web applications
		kill tProps
		set buildDirectory = "/csp/hslib/HealthConnect.FHIRServer"
		set tRoles="%DB_"_$tr($namespace,"%")_",%DB_HSLIB,%DB_HSSYS,%DB_HSCUSTOM"
		Set tCookiePath = ""
		Set tSC = ##class(HS.Util.SystemAPI).Invoke("CreateCSPApp", $namespace, 1, ..#uiUrl, $namespace, buildDirectory, "FHIR configuration UI", tRoles, tCookiePath)
		$$$ThrowOnError(tSC)
		Set tProps("AutheEnabled") = $$$AutheCache + $$$AutheDelegated // Cache password + users can be delegated
		Set tProps("CSPZENEnabled") = 1
		Set tProps("InbndWebServicesEnabled") = 0
		Set tSC=##class(HS.Util.SystemAPI).Invoke("UpdateCSPApp", $namespace, ..#uiUrl, $$$NVPairToList(tProps),0,"u") $$$ThrowOnError(tSC)
		do ##class(HS.HC.Util.Installer).Log(.tLogFile, $$$CurrentClass, $$$CurrentMethod, "Created FHIR web application")
		
		kill tProps
		set tRoles="%DB_"_$tr($namespace,"%")_",%DB_HSLIB,%DB_HSSYS,%DB_HSCUSTOM"
		Set tCookiePath = ""
		Set tSC = ##class(HS.Util.SystemAPI).Invoke("CreateCSPApp", $namespace, 0, ..#apiUrl, $namespace, ..#apiUrl, "FHIR configuration REST API", tRoles, tCookiePath)
		$$$ThrowOnError(tSC)
		Set tProps("AutheEnabled") = $$$AutheCache + $$$AutheDelegated // Cache password + users can be delegated
		Set tProps("DispatchClass") = "HS.FHIRServer.Config.RestHandler"
		Set tProps("CSPZENEnabled") = 1
		Set tProps("InbndWebServicesEnabled") = 0
		Set tSC=##class(HS.Util.SystemAPI).Invoke("UpdateCSPApp", $namespace, ..#apiUrl, $$$NVPairToList(tProps),0,"u") $$$ThrowOnError(tSC)
		do ##class(HS.HC.Util.Installer).Log(.tLogFile, $$$CurrentClass, $$$CurrentMethod, "Created FHIR API web application")
		
	} catch ex {
		TROLLBACK 1
		throw ex
	}
	// Success, Commit any changes
	TCOMMIT
}

/*  TODO --- Uninstall all FHIR Stuff
ClassMethod UninstallNamespace()
{
	do ##class(HS.FHIRServer.Tools.FHIRMetadataSetLoader).Uninstall()
	
	do ..DeleteCSPApp($namespace, "/csp/healthshare/" _ $namespace _ "/fhirconfig", 0)
	do ..DeleteCSPApp($namespace, "/csp/healthshare/" _ $namespace _ "/fhirconfig/api", 0)
}
*/
ClassMethod ResourceExists(pResource) As %Boolean
{
	New $Namespace
	Set $Namespace = "%SYS"
	Return ##class(Security.Resources).Exists(pResource)
}

ClassMethod RoleExists(pRole) As %Boolean
{
	New $Namespace
	Set $Namespace = "%SYS"
	Return ##class(Security.Roles).Exists(pRole)
}

ClassMethod CSPAppExists(pCSPApp, ByRef pAppObj, ByRef pSC) As %Boolean
{
	Set pAppObj = ""
	Set pSC = ""
	New $Namespace
	Set $Namespace = "%SYS"
	Return ##class(Security.Applications).Exists(pCSPApp, .pAppObj, .pSC)
}

ClassMethod GetCSPAppRoles(pCSPApp As %String) As %String
{
	Set tReturn = ""
	Set tAppObj = ""
	If ..CSPAppExists(pCSPApp, .tAppObj, .tSC) {
		For i = 1:1:tAppObj.MatchRoles.Count() {
			If tAppObj.MatchRoles.GetAt(i)["%DB_HSLIB" {
				Set tReturn = tAppObj.MatchRoles.GetAt(i)
			}
		}
	}
	Return tReturn
}

ClassMethod AddSQLProceduresToRole(pNamespace As %String, pRole As %String, pSQLProceduresList As %List) As %Status
{
	Set privilege = "Execute"
	Set type = "Stored Procedures"
	Set withGrant = 0
	
	Return ##class(HS.Util.SystemAPI).Invoke("SQLGrant", pNamespace, pNamespace, privilege, type, pSQLProceduresList, pRole, withGrant)
}

ClassMethod AddInstanceToRepo(pRepoOrId As %String, pPackageList As %String, pAppKey As %String = "", pOAuthClientName As %String = "", pDesc As %String = "") [ Private ]
{
		
	#dim repoManager as HS.FHIRServer.API.RepoManager
	#dim serviceInstance as HS.FHIRServer.ServiceInstance
	#dim strategy as HS.FHIRServer.API.InteractionsStrategy
	
	#dim metaAPI as HS.FHIRMeta.API = ##class(HS.FHIRMeta.API).getInstance(pPackageList)
	// Get the actual "list" form in case the argument was a legacy "popular name"
	Set pPackageList = metaAPI.PackageList
	

	Set repoManager = ##class(HS.FHIRServer.API.RepoManager).getInstance(pRepoOrId)
	// Start a Transaction
	#dim TRANSACTION as HS.Util.Scoped.Transaction = ##class(HS.Util.Scoped.Transaction).Start()
	
	// Create the new ServiceInstance object for this service
	Set serviceInstance = repoManager.AddService(pPackageList)
	Set strategy = serviceInstance.CreateStrategy()
	
	// Create the FHIRService Configuration Object
	#dim configData as HS.FHIRServer.API.ConfigData = ##class(HS.FHIRServer.Tools.ConfigEditor).NewDefaultConfig()
	
	Set configData.DebugMode = 0
	Set configData.FHIRVersion = metaAPI.FHIRVersion
	Set configData.FHIRMetadataSet = $LTS(pPackageList)
	Set configData.InteractionsStrategyClass = repoManager.repo.strategyClass
	
	// Save an initial Configuration Object
	Do strategy.SaveServiceConfigData(configData)
	
	// Create CSP App if URL provided
	if pAppKey '= "" {
		if pDesc = "" {
			Set pDesc = "FHIR Server end point; strategy=" _ repoManager.repo.strategyKey _ ", packages=" _ $LTS(pPackageList)
		}
		Do ..InstallCSPApp(pAppKey, repoManager.repo, pOAuthClientName, pDesc)
	}
	
	// Create the persistent classes
	Set options("restURL") = pAppKey
	Do repoManager.CreateService(serviceInstance.serviceId, .options)

	// Create a CapabilityStatement
	Set interactions = strategy.NewInteractionsInstance()
	do interactions.SetMetadata( strategy.GetMetadataResource() )
	Do TRANSACTION.Commit()
}

/// This method creates a new repo and adds the service to the repo.
/// It installs an instance of a FHIR Service into the current namespace
/// It performs the following operations:
/// <ol>
/// <li> Initializes Metadata information into Globals 
/// <li> Creates the CSP Application for the FHIR endpoint (with url = pAppKey) 
/// <li> Creates a CSPRESTConfig instance associated with the CSP app.  Specifies the OAuth client name (if any)
/// <li> Creates a default HS.FHIRServer.API.ConfigData object for this instance
/// <li> Delegates to the Strategy object to generate/initialize any storage classes or globals
/// <li> Generates a Capabilities statement for the service (based on the MetadataSet and readOnlyCapabilites flag)
/// </ol>
/// @Input pAppKey  Unique key for the endpoint.
/// @Input pStrategyClass  Class that extends HS.FHIRServer.InteractionsStrategy, which defines endpoint strategy
/// @Input pPackageList  %List of FHIR Metadata packages.
/// @Input pOAuthClientName  (optional) The OAuth 2.0 Client name to be used by the resource server.
/// @Input pDesc  (optional) Description of the endpoint.
/// @Input pCreateDatabases  (optional) Specifies whether separate databases should be created for the FHIR data.  The default value is 1(yes).
/// @Input pResourcePath  (optional) Specifies the location of FHIR resource tables and FHIR search tables. The default value is an empty string which means that the database will be created under the mgr directory.
/// @Input pVersionPath  (optional)  Specifies the location of FHIR version tables. The default value is an empty string which means that the database will be created under the mgr directory.
ClassMethod InstallInstance(pAppKey As %String = "", pStrategyClass As %String, pPackageList As %String, pOAuthClientName As %String = "", pDesc As %String = "", pCreateDatabases = 1, pResourcePath As %String = "", pVersionPath As %String = "")
{
	Set strategyKey = ##class(HS.FHIRServer.ServiceAdmin).GetStrategyKeyFromClass(pStrategyClass)
	Set repoId = ##class(HS.FHIRServer.API.RepoManager).CreateRepo(strategyKey, pCreateDatabases, pResourcePath , pVersionPath )
	Do ..AddInstanceToRepo(repoId, pPackageList, pAppKey, pOAuthClientName, pDesc)
}

/// This method updates an existing service instance.
/// All settings are primitive data types (%String, %Boolean, etc..) so that this
/// method may be called asynchronously (HSMOD.REST.Async requires input parameters to not be objects).
/// All inputs must be provided. The current values can be retrieved from the ServiceInstance object.
/// @Input pAppKey  Unique key for the endpoint.
/// @Input pServiceConfigData  Serialized json representation of HS.FHIRServer.API.ConfigData.
/// @Input pEnabled  Whether the service is enabled.
/// @Input pServiceConfigName  The Interop ServiceConfigName for the endpoint.
/// @Input pOAuthClientName  The OAuth 2.0 Client name to be used by the resource server.
ClassMethod UpdateInstance(pAppKey As %String, pServiceConfigData As %String, pEnabled As %Boolean, pServiceConfigName As %String, pOAuthClientName As %String)
{
	#dim transaction as HS.Util.Scoped.Transaction = ##class(HS.Util.Scoped.Transaction).Start()
	
	set instanceId = ##class(HS.FHIRServer.ServiceInstance).FindByUrl(pAppKey).serviceId
	
	set oldConfigData = ##class(HS.FHIRServer.ServiceAdmin).GetInstanceConfigData(instanceId)
	set configData = ##class(HS.FHIRServer.API.ConfigData).%New()
	$$$ThrowOnError(configData.%JSONImport(pServiceConfigData))
	
	if oldConfigData.FHIRMetadataSet '= configData.FHIRMetadataSet {
		do ..AddPackagesToInstance(instanceId, $listfromstring(configData.FHIRMetadataSet))
	}
	
	do ##class(HS.FHIRServer.ServiceAdmin).SetInstanceConfigData(instanceId, configData)
	do ##class(HS.FHIRServer.ServiceAdmin).SetInstanceEnabled(instanceId, pEnabled)
	
	set cspConfig = ##class(HS.Util.RESTCSPConfig).URLIndexOpen(pAppKey)
	set cspConfig.ServiceConfigName = pServiceConfigName
	set cspConfig.OAuthClientName = pOAuthClientName
	$$$ThrowOnError(cspConfig.%Save())
	
	do transaction.Commit()
}

/// This method updates a service instance (endpoint) to support the specified list of FHIR
/// metadata packages.  Each package in the input %List must depend on the core FHIR
/// version supported by the service instance.  This method is idempotent, it will only add
/// package that are not already supported.
/// <br> @Input pServiceId The id of the ServiceInstance
/// <br> @Input pPackageList A %List of FHIR metadata package Id's to be supported
ClassMethod AddPackagesToInstance(pServiceId As %String, pPackageList As %List)
{
	//w "Add packages (" _ $LTS(pPackageList) _ ") to service ",pServiceId,!
	#dim instance as HS.FHIRServer.ServiceInstance
	Set instance = ##class(HS.FHIRServer.ServiceInstance).GetById(pServiceId)
	#dim repoManager as HS.FHIRServer.API.RepoManager
	Set repoManager = ##class(HS.FHIRServer.API.RepoManager).getInstance(instance.parentRepo)
	Set options("packagesToAdd") = pPackageList
	do repoManager.UpdateService(pServiceId, .options)
}

/// @API
/// This method installs an instance of a FHIR Service into the current namespace
/// It performs the following operations:
/// <ol>
/// <li> Creates the CSP Application for the FHIR endpoint (with url = pAppKey) 
/// <li> Creates a CSPRESTConfig instance associated with the CSP app.  Specifies the OAuth client name (if any)
/// </ol>
/// @Input pAppKey  Unique key for the endpoint.
/// @Input pOAuthClientName  (optional) The OAuth 2.0 Client name to be used by the resource server.
/// @Input pDesc  (optional) Description of the endpoint.
ClassMethod InstallCSPApp(pAppKey As %String, pRepo As HS.FHIRServer.Repo, pOAuthClientName As %String = "", pDesc As %String = "")
{
	// Validate form if App Key
	if ($E(pAppKey) '= "/") || ($E(pAppKey,*) = "/" ) {
		$$$ThrowFHIR($$$GeneralError, "AppKey must begin with a slash and must NOT end with a slash")
	}
	if ##class(HS.FHIRServer.ServiceAdmin).EndpointExists(pAppKey) {
		$$$ThrowFHIR($$$GeneralError, "There is already an instance installed for endpoint " _ pAppKey)
	}

	// Create the CSP Application
	Set tNS = $Namespace
		
	// If an CSP app already exists for this app key and namespace, then
	// update only a few of the properties and carry over existing values
	// for the rest.
	Set tCSPAppExists = ..CSPAppExists(pAppKey, .appObj)
	// Security.Application object property name is NameSpace, not Namespace.
	If (tCSPAppExists) && (appObj.NameSpace'=tNS) {
		$$$ThrowFHIR($$$GeneralError, "CSP app "_pAppKey_" already exists for another namespace ("_appObj.NameSpace_")")
	}

	// These items definitely need to be set/changed to these values.
	Set tProps("Name") = pAppKey
	Set tProps("NameSpace") = tNS
	Set tProps("DispatchClass") = "HS.FHIRServer.RestHandler" 
	Set tProps("AutheEnabled") = ($$$AutheUnauthenticated + $$$AutheCache + $$$AutheDelegated)
	Set tProps("Description") = pDesc
	Set tMatchRoles = ":%HS_DB_"_$tr(tNS,"%")_":%DB_HSLIB:%DB_HSSYS"
	if pRepo.resourceDBName '="" {
		Set tMatchRoles = tMatchRoles _ ":%DB_" _ pRepo.resourceDBName	
	}
	if pRepo.versionDBName '="" {
		Set tMatchRoles = tMatchRoles _ ":%DB_" _ pRepo.versionDBName	
	}
	Set tProps("MatchRoles") = tMatchRoles
	
	If tCSPAppExists {
		For name = "Timeout", "InbndWebServicesEnabled", "AutoCompile", "IsNameSpaceDefault", "DeepSeeEnabled", "GroupById", "CSPZENEnabled", "UseCookies", "CookiePath" {
			Set tProps(name) = $Property(appObj, name)
		}
	} Else {
		Set tProps("Timeout") = 900
		Set tProps("InbndWebServicesEnabled") = 0
		Set tProps("AutoCompile") = 0
		Set tProps("IsNameSpaceDefault") = 0
		Set tProps("UseCookies") = 0
		Set tProps("DeepSeeEnabled") = 0
		Set tProps("GroupById") = ""
		Set tProps("CookiePath") = ""
		Set tProps("CSPZENEnabled") = 1
	}
	Set tSC=##class(HS.Util.SystemAPI).Invoke("UpdateCSPApp",tNS,pAppKey,$$$NVPairToList(tProps),1,"n")
	$$$ThrowOnError( tSC )

	// Create the App Config Persistent object
	Set restConfigObj = ##class(HS.Util.RESTCSPConfig).URLIndexOpen(pAppKey)
	If '$IsObject($Get(restConfigObj)) {
		Set restConfigObj = ##class(HS.Util.RESTCSPConfig).%New()
		Set restConfigObj.URL = pAppKey
	}
	if pOAuthClientName'="" {
		Set restConfigObj.OAuthClientName = pOAuthClientName
	}
	$$$ThrowOnError( restConfigObj.%Save() )
}

/// @API
/// This method uninstalls an instance of a FHIR Service in the current namespace
/// It performs the following operations:
/// <ol>
/// <li> Removes the CSP configuration
/// <li> Removes the web application
/// <li> Optionally deletes data associated with the endpoint
/// </ol>
/// @Input pAppKey  Unique key for the endpoint.
/// @Input deleteData  (optional) Whether to also delete the data assocaited with the endpoint.
ClassMethod UninstallInstance(pAppKey As %String, deleteData As %Boolean = 1)
{
	// Start a Transaction
	#dim transaction as HS.Util.Scoped.Transaction = ##class(HS.Util.Scoped.Transaction).Start()
	
	if $E(pAppKey,1,4) = "svc:" {
		// Deleting a Service with no assigned endpoint
		Set instanceId = $E(pAppKey,5,*)
		Set instance = ##class(ServiceInstance).GetById(instanceId)
		Set strategy = instance.CreateStrategy()
	} else {
		// Deleting a service with an assigned endpoint
		#dim strategy as HS.FHIRServer.API.InteractionsStrategy = ##class(HS.FHIRServer.API.InteractionsStrategy).GetStrategyForEndpoint(pAppKey)
		Set instanceId = strategy.InstanceKey
		// Delete the CSP Endpoint
		$$$ThrowOnError(##class(HS.Util.SystemAPI).Invoke("DeleteCSPApp", $Namespace, pAppKey, ""))
		
		// Delete the CSP
		Set cspConfig = ##class(HS.Util.RESTCSPConfig).URLIndexOpen(pAppKey)
		if $IsObject(cspConfig) {
			Set id = cspConfig.%Id()
			kill cspConfig
			$$$ThrowOnError(##class(HS.Util.RESTCSPConfig).%DeleteId(id))
		}
	}
	
	// Ask the strategy to delete the data it can
	if deleteData {
		Set options = 0
		Do strategy.Delete(.options)
	}
	
	// Remove the ServiceInstance
	Do ##class(HS.FHIRServer.ServiceAdmin).DeleteInstance(instanceId)
	
	// Remove any cached instances of FHIRService from our Context object
	Do ##class(HS.FHIRServer.Service).InvalidateInstances(instanceId)


	// Success, Commit any changes
	do transaction.Commit()
}

/// @API
/// This method decommissions an instance of a FHIR Service in the current namespace
/// It performs the following operations:
/// <ol>
/// <li> Removes the CSP configuration
/// <li> Removes the web application
/// <li> Flags the ServiceInstance as decommissioned and retains data according to retention policies
/// <li> NOTE: a Strategy may have not retention policy and completely delete the service and its data
/// </ol>
/// @Input instanceId  Unique key for the endpoint.
ClassMethod DecommissionInstance(instanceId As %String)
{
	if (instanceId = "") || (instanceId = 0) {
		$$$ThrowFHIR($$$HSFHIRErrAPIContractViolation, "Cannot specify a null Instance Id")
	}
	TSTART
	try {
		set epList = ##class(HS.FHIRServer.ServiceAdmin).GetEndpointList(instanceId)
		
		Set ptr = 0
		while $listnext(epList, ptr, restURL) {
			// Delete the CSP Endpoint
			$$$ThrowOnError(##class(HS.Util.SystemAPI).Invoke("DeleteCSPApp", $Namespace, restURL, ""))
			
			// Delete the CSP
			Set cspConfig = ##class(HS.Util.RESTCSPConfig).URLIndexOpen(restURL)
			if $IsObject(cspConfig) {
				Set id = cspConfig.%Id()
				kill cspConfig
				$$$ThrowOnError(##class(HS.Util.RESTCSPConfig).%DeleteId(id))
			}
			
			// Ask the strategy to decomission the endpoint
			Set strategy = ##class(HS.FHIRServer.API.InteractionsStrategy).GetStrategyForEndpoint(restURL)
			Do strategy.Decommission(.options)
		}
		
	} catch ex {
		TROLLBACK 1
		throw ex
	}
	// Success, Commit any changes
	TCOMMIT
}

/// This method is no longer available, it has been replaced by HS.FHIRMeta.Load.NpmLoader::importPackages
ClassMethod InstallMetadataSet(key As %String, description As %String, extendsKey As %String, fileData As %List, reloadMetadata As %Boolean) [ Deprecated ]
{
	$$$ThrowFHIR($$$GeneralError, "HS.FHIRServer.Installer::InstallMetadataSet has been replaced by HS.FHIRMeta.Load.NpmLoader::importPackages")
}

/// This method is no longer available, it has been replaced by HS.FHIRMeta.Load.NpmLoader::importPackages
ClassMethod UninstallMetadataSet(key As %String) [ Deprecated ]
{
	$$$ThrowFHIR($$$GeneralError, "HS.FHIRServer.Installer::UninstallMetadataSet has been replaced by HS.FHIRMeta.Load.NpmLoader::UninstallPackage")
}

}
