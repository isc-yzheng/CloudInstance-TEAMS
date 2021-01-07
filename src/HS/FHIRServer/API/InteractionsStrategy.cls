Include HS.FHIRServer

Class HS.FHIRServer.API.InteractionsStrategy Extends %RegisteredObject [ Abstract ]
{

Parameter StrategyKey As %String [ Abstract ];

Property InstanceKey As %String [ Calculated ];

Property RepoManager As HS.FHIRServer.API.RepoManager [ Calculated ];

Property RepoInstance As HS.FHIRServer.RepoInstance [ Calculated ];

Parameter StrategyDesc As %String [ Abstract ];

Parameter StrategyGlobal As %String [ Final, Internal ] = "^HS.FHIRServer.Strategy";

Property %serviceInstance As HS.FHIRServer.ServiceInstance [ Private ];

Property schema As HS.FHIRServer.Schema [ Calculated ];

Property %schema As HS.FHIRServer.Schema [ Private ];

Property %repoManager As HS.FHIRServer.API.RepoManager [ Private ];

/// @API
/// Factory method to create an instance of the InteractionsStrategy class associated with the
/// specified service.
/// <br>@Input serviceOrKey  The Service Key or Service instance for the InteractionsStrategy to manage
/// <br>@Input repoManager (optional)  If present, this RepoManager instance will be assigned as the RepoManager
/// property of the returned strategy.  If not present, a new RepoManger will be created.
/// <br>@Return An instance of an InteractionsStrategy object to manage the service
/// <br>@Throws:  APIContractViolation if the serviceOrKey does not resolve to a service in the Repo managed
/// by the specified 'repoManager'
ClassMethod getInstance(serviceOrKey As %String, repoManager As HS.FHIRServer.API.RepoManager = "") As HS.FHIRServer.API.InteractionsStrategy
{
	#dim serviceInstance as HS.FHIRServer.ServiceInstance
	if $IsObject(serviceOrKey) {
		// An object was provided, verify it is the correct type
		if 'serviceOrKey.%IsA("HS.FHIRServer.RepoInstance") {
			$$$ThrowFHIR($$$HSFHIRErrAPIContractViolation, "Object parameter must be a HS.FHIRServer.RepoInstance")
		}
		set serviceInstance = serviceOrKey
	} else {
		// An InstanceKey was provided, acquire the object
		Set serviceInstance = ##class(HS.FHIRServer.ServiceInstance).GetById(serviceOrKey)
	}
	#dim repo as HS.FHIRServer.Repo
	Set repo = serviceInstance.parentRepo
	
	#dim managerToUse As HS.FHIRServer.API.RepoManager	
	if $IsObject(repoManager) {
		// Make sure Service Manager and RepoManger are for the same Repo Id.
		if repo.%Id() '= repoManager.repo.%Id() {
			$$$ThrowFHIR($$$HSFHIRErrAPIContractViolation, "Specified service is not a service in the specified repo")	
		}
		Set managerToUse = repoManager
	} else {
		Set managerToUse = ##class(HS.FHIRServer.API.RepoManager).getInstance(repo)
	}
	return $ClassMethod(repo.strategyClass, "%New", serviceInstance, managerToUse)
}

Method %OnNew(serviceInstance As HS.FHIRServer.ServiceInstance, repoManager As HS.FHIRServer.API.RepoManager = "") As %Status [ Private ]
{
	// Don't hold onto the persistent copy of the ServiceInstance, store a copy instead
	Set ..%serviceInstance = serviceInstance
	set ..%repoManager = repoManager
	Set ..%schema = ##class(HS.FHIRServer.Schema).LoadSchema(serviceInstance.packageList)
	return $$$OK
}

/// @API Creates an instance of the Interactions handler object
Method NewInteractionsInstance() As HS.FHIRServer.API.Interactions [ Abstract ]
{
}

/// @API Returns an instance of an InteractionsStrategy that manages the specified endpoint base URL.
ClassMethod GetStrategyForEndpoint(pBaseUrl As %String) As HS.FHIRServer.API.InteractionsStrategy
{
	if ' ##class(HS.FHIRServer.ServiceAdmin).EndpointExists(pBaseUrl) {
		$$$ThrowFHIR($$$HSFHIRErrFHIREndpointNotDefined, pBaseUrl )
	}
	#dim serviceInstance as HS.FHIRServer.ServiceInstance = ##class(HS.FHIRServer.ServiceAdmin).GetInstanceForEndpoint(pBaseUrl)
	$$$FSLog("Inst: "_serviceInstance)
	return serviceInstance.CreateStrategy()
}

/// @Deprecated
/// <br>Change your code to call ##class(HS.FHIRServer.API.RepoManager).GetStrategyList instead.
/// This method is just a passthrough and will be removed in the future.
ClassMethod GetStrategyList(Output pListOfClasses)
{
	Do ##class(HS.FHIRServer.API.RepoManager).GetStrategyList(.pListOfClasses)
}

Method RepoManagerGet() [ CodeMode = expression ]
{
..%repoManager
}

Method schemaGet() [ CodeMode = expression ]
{
..%schema
}

Method InstanceKeyGet() As %String [ CodeMode = expression ]
{
..%serviceInstance.serviceId
}

Method RepoInstanceGet() As HS.FHIRServer.ServiceInstance [ CodeMode = expression ]
{
..%serviceInstance
}

Method RepoGet() As HS.FHIRServer.Repo [ CodeMode = expression ]
{
..%serviceInstance.repo
}

/// @API
/// Returns a package name reserved for generated search classes in this instance
Method GetSearchClassesPackage() As %String [ CodeMode = expression ]
{
..%serviceInstance.searchClassesPackage
}

/// @API
/// Returns a package name reserved for generated resource classes in this instance
Method GetResourceClassesPackage() As %String [ CodeMode = expression ]
{
..%serviceInstance.resourceClassesPackage
}

/// @API
/// Returns the name of a Global node that is the root of any global-based data for this instance
Method GetGlobalRoot() As %String [ CodeMode = expression ]
{
..%repoManager.GetGlobalRoot(..%serviceInstance.serviceId)
}

/// @API
/// Returns the name of a Global node that is the root of any temporary global-based data for this instance
Method GetGlobalTempRoot() As %String [ CodeMode = expression ]
{
..%repoManager.GetGlobalTempRoot(..%serviceInstance.serviceId)
}

/* ------- */
/// @API
/// Returns the table name that stores resources for the specified type
Method GetResourceTable(resourceType As %String, shortName As %Boolean = 0) As %String [ CodeMode = expression ]
{
..%repoManager.GetResourceTableName(..%serviceInstance.serviceId, resourceType, shortName)
}

/// @API
/// Returns the classname of the persistent object used store resources for the specified type
Method GetResourceClass(resourceType As %String) As %String [ CodeMode = expression ]
{
..%repoManager.GetResourceClassName(..%serviceInstance.serviceId, resourceType)
}

/// @API
/// Returns the table name used to index the specified type.  Note, it may be the
/// same as the ResourceTable
Method GetSearchTable(resourceType As %String, pChildName As %String = "", shortName As %Boolean = 0) As %String [ CodeMode = expression ]
{
..%repoManager.GetSearchTableName(..%serviceInstance.serviceId, resourceType, pChildName, shortName)
}

/// @API
/// Returns the classname of the persistent object used to index the specified type.  Note, it may be the
/// same as the ResourceClass
Method GetSearchClass(resourceType As %String) As %String [ CodeMode = expression ]
{
..%repoManager.GetSearchClassName(..%serviceInstance.serviceId, resourceType)
}

/// @API
/// Returns the SQL Table name for older resource versions for the specified type
Method GetResourceVersionTable(resourceType As %String = "", shortName As %Boolean = 0) As %String [ CodeMode = expression ]
{
..%repoManager.GetResourceVersionTableName(..%serviceInstance.serviceId, resourceType, shortName)
}

/// @API
/// Returns the classname of the persistent object used store older resource versions for the specified type
Method GetResourceVersionClass(resourceType As %String) As %String [ CodeMode = expression ]
{
..%repoManager.GetResourceVersionClassName(..%serviceInstance.serviceId, resourceType)
}

/* ------- */
/// @API
/// Get the endpoint URLs for a specific strategy/metadata combination
ClassMethod GetEndpointURL(pStrategyKey As %String, pMetadataSetKey As %String) As %String [ Deprecated ]
{
	return ""
}

/// @API
/// Returns a list of information for endpoints in this Namespace, optionally filtered by strategyKey
/// Each entry in the list is a $List( appKey, strategyKey, metadataSetKey, enabled, instanceKey )
ClassMethod GetEndpointInfo(pStrategyKey As %String = "") As %String
{
	Set list = ""
	Set idList = ##class(HS.FHIRServer.ServiceAdmin).GetServiceIdList()
	Set index = 0
	while $listnext(idList, index, instanceId) {
		
		#dim serviceInstance As HS.FHIRServer.ServiceInstance
		set serviceInstance = ##class(HS.FHIRServer.ServiceInstance).GetById(instanceId)
		
		Set url = serviceInstance.cspUrl
		if url="" {
			Set url = "svc:"_instanceId
		}
		Set strategyKey = serviceInstance.GetStrategyKey()
		Set metadataSetKey = serviceInstance.packageList
		Set enabled = ##class(HS.FHIRServer.ServiceAdmin).IsInstanceEnabled(instanceId)
		
		// Apply Filters if any
		if (pStrategyKey '= "") && (strategyKey '= pStrategyKey) Continue
		
		Set $List(list, *+1) = $listbuild(url, strategyKey, metadataSetKey, enabled, instanceId)
	}
	return list
}

/// @API
/// Returns a list of information for an endpoint in this Namespace
/// The list is a $List( strategyKey, metadataSetKey, enabled )
ClassMethod GetOneEndpointInfo(pUrl As %String) As %List
{
	if '##class(HS.FHIRServer.ServiceAdmin).EndpointExists(pUrl) {
		$$$ThrowFHIR($$$HSFHIRErrServiceNotConfigured, pUrl, $$$OutcomeIs(404, "error","missing"))
	}
	#dim serviceInstance As HS.FHIRServer.ServiceInstance
	set serviceInstance = ##class(HS.FHIRServer.ServiceAdmin).GetInstanceForEndpoint(pUrl)
	
	Set strategyKey = serviceInstance.GetStrategyKey()
	Set packageList = serviceInstance.packageList
	Set enabled = ##class(HS.FHIRServer.ServiceAdmin).IsInstanceEnabled(serviceInstance.serviceId)

	return $listbuild(strategyKey, packageList, enabled)
}

ClassMethod SetEnabled(pAppKey As %String, enabled As %Boolean)
{
	Do ##class(HS.FHIRServer.ServiceAdmin).SetEndpointEnabled(pAppKey, enabled)
}

/// Update the FHIRService ConfigData object for this endpoint
Method SaveServiceConfigData(configData As HS.FHIRServer.API.ConfigData)
{
	// Save the data
	Do ##class(HS.FHIRServer.ServiceAdmin).SetInstanceConfigData(..%serviceInstance.serviceId, configData)
}

/// Returns the FHIRService ConfigData object for this endpoint
Method GetServiceConfigData() As HS.FHIRServer.API.ConfigData
{
	return ##class(HS.FHIRServer.ServiceAdmin).GetInstanceConfigData(..%serviceInstance.serviceId)
}

ClassMethod GetServiceConfigDataForEndpoint(pUrl As %String) As HS.FHIRServer.API.ConfigData
{
	Set strategy = ..GetStrategyForEndpoint(pUrl)
	return strategy.GetServiceConfigData()
}

/// @API<br>
/// Return a CapabilityStatement metadata resource. The returned content is derived from
/// a strategy-specific means of formulating a CapabilityStatement. An example use of the
/// output might be to store the CapabilityStatement for a given Service.<br>
/// This method should not be confused with the Interactions class LoadMetadata() method,
/// which retrieves the stored CapabilityStatement for the current Service.
Method GetMetadataResource() As %DynamicObject [ Abstract ]
{
}

/// @API Create the service.  This method initializes a service for an endpoint
/// including generating any classes or schemas required and registering the configuration for
/// later modification or deletion
Method Create(ByRef options)
{
	do ..%repoManager.CreateService(..%serviceInstance.serviceId, .options)
}

/// @API Delete the service.  This method removes a service.  This includes and FHIR data and
/// associated schema classes as well as registration data.  A decommissioned service cannot be removed.
Method Delete(ByRef options)
{
	do ..%repoManager.DeleteService(..%serviceInstance.serviceId, .options)
}

/// @API Decommission the service.  This method detaches a service from any REST endpoints, making it inaccessiable for
/// client operations.  The Service may remove all of its data, or it may preserves data to support retention policies. A decommissioned
/// service cannot be deleted until all data in the service have been deleted (via retention policies).  
Method Decommission(ByRef options)
{
	do ..%repoManager.DecommissionService(..%serviceInstance.serviceId, .options)
}

/// @API Update the schema. This method applies changes to an already configured schema (if possible)
/// For example, to add a search parameter including ensuring that the new field is indexed.
/// Handle changes to the schema structure 
Method Update(ByRef options)
{
	do ..%repoManager.UpdateService(..%serviceInstance.serviceId, .options)
}

/// @API This method migrates existing FHIR data from a previous installation of FHIR 
/// from pre-HealthConnect 2020.1
Method MigrateFromPre2020(ByRef options) [ Abstract, Deprecated ]
{
}

}
