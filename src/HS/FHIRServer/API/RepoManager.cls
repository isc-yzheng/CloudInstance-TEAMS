Include HS.FHIRServer

/// This is the primary API for managing a repository and its service(s) and endpoint(s)
Class HS.FHIRServer.API.RepoManager Extends %RegisteredObject [ Abstract ]
{

Parameter StrategyClass As %String [ Abstract ];

Parameter StrategyKey As %String [ Abstract ];

/// True if the Repo Strategy is limited to only 1 service per repo
Parameter IsSingleServiceStrategy As %Boolean = 1;

Property repo As HS.FHIRServer.Repo;

Method %OnNew(repo As HS.FHIRServer.Repo) As %Status [ Private ]
{
	set ..repo = repo
	return $$$OK
}

/// @API
/// Returns the index type for the specified resource type and parameter code
Method GetIndexType(resourceType As %String, paramCode As %String) As %Integer [ Abstract ]
{
}

/// @API
/// Factory method to return a instance of a RepoManager.
/// The input parameter, repoOrId, may be the ID value of a Repo, or an
/// instantiated HS.FHIRServer.Repo object.
ClassMethod getInstance(repoOrId) As HS.FHIRServer.API.RepoManager
{
	#dim repo as HS.FHIRServer.Repo
	
	if $IsObject(repoOrId) {
		if 'repoOrId.%IsA("HS.FHIRServer.Repo") {
			$$$ThrowFHIR($$$HSFHIRErrAPIContractViolation, "Object parameter must be a HS.FHIRServer.Repo")
		}
		set repo = repoOrId
	} else {
		Set repo = ##class(HS.FHIRServer.Repo).GetById(repoOrId)
	}
	/// Get the RepoManager classname from the Repo's Strategy Name
	return $ClassMethod(repo.managerClass, "%New", repo)
}

/// @API
/// Factory method to create a Repo Instance for the specified Strategy.
/// <br>@Input strategyKey The key for the strategy to be used by the new Repo
/// <br>@Returns the Id for the new Repo
ClassMethod CreateRepo(strategyKey As %String, createDatabases = 0, resourcePath As %String = "", versionPath As %String = "") As HS.FHIRServer.Repo
{
	Set TRANSACTION = ##class(HS.Util.Scoped.Transaction).Start()
	
	do ..GetStrategyList(.infoList)
	set key = "" 
	for {
		Set key = $Order(infoList(key))
		if key="" {
			$$$ThrowFHIR($$$GeneralError,"There is no RepoManager class for strategy key: " _ strategyKey)
		}
		if key = strategyKey {
			Quit
		}
	}
	Set managerClass = infoList(strategyKey, "repoManager")
	#dim repo as HS.FHIRServer.Repo
	Set repo = ##class(HS.FHIRServer.Repo).%New()
	Set repo.managerClass = managerClass
	Set repo.strategyClass = $parameter(managerClass,"StrategyClass")
	Set repo.strategyKey = strategyKey
	$$$ThrowOnError(repo.%Save())
	
	Set key = "X" _ $E(10000 + repo.%Id(), 2, *)
	Set repo.searchClassesPackage = "HSFHIR." _ key _ ".S"
	Set repo.resourceClassesPackage = "HSFHIR." _ key _ ".R"
	Set repo.versionClassesPackage = "HSFHIR." _ key _ ".V"
	Set repo.globalRoot = "^HS.FHIRServer." _ key
	Set repo.globalTempRoot = "^IRIS.Temp.HS.FHIRServer." _ key
	if createDatabases {
		set repo.resourceDBName =  $namespace _ key _ "R"
		set repo.versionDBName =  $namespace _ key _ "V"
		set repo.resourcePath = resourcePath
		set repo.versionPath = versionPath
		set sqlProceduresList = $listbuild("HS_FHIRServer_Storage.ListFirst", "HS_FHIRServer_Storage.ListLast")
		do ..createFHIRDatabase(repo.resourceDBName, repo.resourcePath, "HSFHIR." _ key _ ".S*,HSFHIR." _ key _ ".R*", sqlProceduresList)
		do ..createFHIRDatabase(repo.versionDBName, repo.versionPath, "HSFHIR." _ key _ ".V*", sqlProceduresList)
	}
	$$$ThrowOnError(repo.%Save())

	Do TRANSACTION.Commit()
	return repo
}

// sample call  do ##class(HS.FHIRServer.API.RepoManager).createFHIRDatabase("HSFHIRX02R","","HSFHIR.X01.S*,HSFHIR.X01.R*")

ClassMethod createFHIRDatabase(dbName As %String, path As %String, mapGlobalList As %String, sqlProceduresList As %List)
{
	set ns = $namespace
	set path = $g(path)
	Set sc=##class(HS.Util.SystemAPI).CreateDatabase(dbName, 1, .path) 
	$$$ThrowOnError(sc)
	set sc =  ##class(HS.Util.SystemAPI).Invoke("AddGlobalMappings",ns,ns,mapGlobalList,dbName)
	$$$ThrowOnError(sc)
	set sc = ##class(HS.Util.SystemAPI).Invoke("ActivateConfiguration",ns,ns)
	$$$ThrowOnError(sc)
	if sqlProceduresList '= "" {
		set sc = ##class(HS.FHIRServer.Installer).AddSQLProceduresToRole(ns, "%DB_"_dbName, sqlProceduresList)
		$$$ThrowOnError(sc)
	}
}

/// @API
/// Factory method to create an instance of an HS.FHIRServer.API.InteractionsStrategy 
/// for a specified ServiceInstance
/// <br>@Input serviceOrKey  The Service Key or Service instance for the InteractionsStrategy to manage
/// <br>@Throws:  APIContractViolation if the serviceOrKey does not resolve to a service for this Repo. 
Method CreateStrategy(serviceOrKey As %String) As HS.FHIRServer.API.InteractionsStrategy
{
	return ##class(HS.FHIRServer.API.InteractionsStrategy).getInstance(serviceOrKey, $this)
}

/// @API Adds a new service to this Repo that uses the specified MetadataSet and returns
/// the ID for the new service.  The Id may be passed to the CreateStrategy method to obtain
/// a InteractionsStrategy and Interactions objects for the new service.
/// <br>@Return The ServiceInstance of the new service.  
Method AddService(pMetadataSetKey As %String) As HS.FHIRServer.ServiceInstance
{
	//if ..#IsSingleServiceStrategy && (..repo.Instances.Count() = 1) {
	if ..repo.Instances.Count() = 1 {
		// No multi-service repos in 2020.2
		$$$ThrowError($$$GeneralError, "This Repository only supports a single service")	
	}
	
	// OK to create a new Service
	Set instance = ##class(HS.FHIRServer.RepoInstance).%New()
	Set instance.metadataSetKey = pMetadataSetKey
	Set instance.isEnabled = 1
	Set instance.IsDecommissioned = 0
	Set instance.repo = ..repo
	$$$ThrowOnError( instance.%Save() )
	return instance
}

/// @API Return a multi-dimensional array of information nodes, using the
/// StrategyKey as the key.
/// indexed by StrategyKey.
/// Output:
///  pListOfClasses(n): the name of the n-th available InteractionsStrategy class
///  pListOfClasses(n, "repoManager"): the name of the n-th available RepoManager class
///  pListOfClasses(n, "desc"): the description of the n-th available strategy
ClassMethod GetStrategyList(Output pListOfClasses)
{
	// Get all subclasses of this class
	Set tResultSet = ##class(%ResultSet).%New("%ClassDefinition:SubclassOf")
	Do tResultSet.%Execute("HS.FHIRServer.API.RepoManager")
	

	// Create new instances of services found in tResultSet, add to local array and start them
	While tResultSet.Next(.tSC) {
		$$$ThrowOnError(tSC)
		Set className = tResultSet.GetData(1)
		If $$$comClassKeyGet(className, $$$cCLASSabstract) {
			//w "Skip Abstract ", className, !
			Continue
		}
	
		Set strategyClass = $parameter(className, "StrategyClass")
		Set key = $parameter(className, "StrategyKey")
		if key '= "" {
			if $D(pListOfClasses(key)) '= 0 {
				$$$ThrowFHIR($$$GeneralError, "The Strategy Key '" _ key _ " for class " _ className _ " was already used for " _ pListOfClasses(key))	
			}
			Set pListOfClasses(key) = strategyClass
			Set pListOfClasses(key, "desc") = $parameter(strategyClass, "StrategyDesc")
			Set pListOfClasses(key, "repoManager") = className
		}
	}
}

/* ----------------------------
   These methods provide metadata for table building, search, and query building
   ---------------------------- */
/// @API Returns a $Name for a Global Root node that can be used by the
/// specified service instance
Method GetGlobalRoot(serviceId As %String) As %String [ Abstract ]
{
}

/// @API Returns a $Name for a Temporary Global Root node that can be used by the
/// specified service instance
Method GetGlobalTempRoot(serviceId As %String) As %String [ Abstract ]
{
}

/// @API
/// Returns the table name that stores resources for the specified type
Method GetResourceTableName(serviceId As %String, pResourceType As %String, shortName As %Boolean = 0) As %String [ Abstract ]
{
}

/// @API
/// Returns the classname of the persistent object used store resources for the specified type
Method GetResourceClassName(serviceId As %String, pResourceType As %String) As %String [ Abstract ]
{
}

/// @API
/// Returns the table name used to index the specified type.  Note, it may be the
/// same as the ResourceTable
Method GetSearchTableName(serviceId As %String, pResourceType As %String, pChildName As %String, shortName As %Boolean = 0) As %String [ Abstract ]
{
}

/// @API
/// Returns the classname of the persistent object used to index the specified type.  Note, it may be the
/// same as the ResourceClass
Method GetSearchClassName(serviceId As %String, pResourceType As %String) As %String [ Abstract ]
{
}

/// @API
/// Returns the SQL Table name for older resource versions for the specified type
Method GetResourceVersionTableName(serviceId As %String, pResourceType As %String, shortName As %Boolean = 0) As %String [ Abstract ]
{
}

/// @API
/// Returns the classname of the persistent object used store older resource versions for the specified type
Method GetResourceVersionClassName(serviceId As %String, pResourceType As %String) As %String [ Abstract ]
{
}

/// @API
/// Returns the classname of the persistent object used to index the specified type.  Note, it may be the
/// same as the ResourceClass
Method GetSearchColumnName(serviceId As %String, pResourceType As %String, paramCode As %String) As %String [ Abstract ]
{
}

/* ----------------------------
   These methods manage the storage for the repository
   ---------------------------- */
/// @API Create the service.  This method initializes a service for an endpoint
/// including generating any classes or schemas required and registering the configuration for
/// later modification or deletion
Method CreateService(serviceId As %String, ByRef options) [ Abstract ]
{
}

/// @API Delete the service.  This method removes a service.  This includes and FHIR data and
/// associated schema classes as well as registration data.  A decommissioned service cannot be removed.
Method DeleteService(serviceId As %String, ByRef options) [ Abstract ]
{
}

/// @API Decommission the service.  This method detaches a service from any REST endpoints, making it inaccessiable for
/// client operations.  The Service may remove all of its data, or it may preserves data to support retention policies. A decommissioned
/// service cannot be deleted until all data in the service have been deleted (via retention policies).  
Method DecommissionService(serviceId As %String, ByRef options) [ Abstract ]
{
}

/// @API Update the schema. This method applies changes to an already configured schema (if possible)
/// For example, to add a search parameter including ensuring that the new field is indexed.
/// Handle changes to the schema structure 
Method UpdateService(serviceId As %String, ByRef options) [ Abstract ]
{
}

}
