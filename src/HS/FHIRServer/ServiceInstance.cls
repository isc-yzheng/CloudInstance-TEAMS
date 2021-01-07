Include HS.FHIRServer

/// Represents a single instance of a FHIRServer including locators for all of its persistent data.  New
/// instances are created by calling the AddInstance method on a RepoManager object.
Class HS.FHIRServer.ServiceInstance [ Abstract ]
{

Property serviceId As %Integer;

Property metadataSetKey As %String;

Property packageList As %List [ Calculated ];

Property strategyClass As %String [ Calculated ];

Property globalRoot As %String [ Calculated ];

Property globalTempRoot As %String [ Calculated ];

Property resourceClassesPackage As %String [ Calculated ];

Property searchClassesPackage As %String [ Calculated ];

Property versionClassesPackage As %String [ Calculated ];

Property parentRepo As HS.FHIRServer.Repo [ Calculated ];

Property serviceConfigData As %String;

Property isEnabled As %Boolean;

Property cspUrl As %String;

/// Flags whether this service has be decommissioned, meaning that it should
/// no longer be attachable to an endpoint.  It remains available for historical
/// access (as in audit data)
Property IsDecommissioned As %Boolean;

Method packageListGet() As %List [ CodeMode = expression ]
{
##class(HS.FHIRMeta.Storage.Package).MapPopularName(..metadataSetKey)
}

ClassMethod GetById(id) As RepoInstance
{
	set inst = ##class(RepoInstance).getByServiceId(id, .sc)
	$$$ThrowOnError(sc)
	return inst
}

ClassMethod FindByUrl(url) As RepoInstance
{
	return ##class(RepoInstance).UrlIdxOpen(url)
}

ClassMethod Exists(id) As %Boolean
{
	return ##class(RepoInstance).existsServiceId(id)
}

ClassMethod DeleteById(id)
{
	Do ##class(RepoInstance).deleteByServiceId(id)
}

ClassMethod GetAll() As %ListOfObjects
{
	#dim result as %ListOfObjects = ##class(%ListOfObjects).%New()
	
	Set SQL = "SELECT serviceId FROM HS_FHIRServer.RepoInstance"
	Set statement = ##class(%SQL.Statement).%New()
	Set tSC = statement.%Prepare(SQL)
	$$$ThrowOnError(tSC)
	Set resultSet = statement.%Execute()
	While resultSet.%Next() {
		Do result.Insert(..GetById(resultSet.%GetData(1)))
	}
	return result
}

ClassMethod GetIdListByStrategyKey(strategyKey As %String = "") As %List
{
	Set list = ""
	Set SQL = "SELECT serviceId, repo->StrategyClass FROM HS_FHIRServer.RepoInstance where IsDecommissioned = 0"
	Set statement = ##class(%SQL.Statement).%New()
	Set tSC = statement.%Prepare(SQL)
	$$$ThrowOnError(tSC)
	Set resultSet = statement.%Execute()
	While resultSet.%Next() {
		Set id = resultSet.%GetData(1)
		if strategyKey '= "" {
			Set cls = resultSet.%GetData(2)
			if $Parameter(cls, "StrategyKey") '= strategyKey {
				Continue
			}
		}
		Set $list(list, *+1) = id
	}
	return list
}

ClassMethod GetIdListByRepoId(repoId As %String) As %List
{
	Set list = ""
	Set SQL = "SELECT serviceId FROM HS_FHIRServer.RepoInstance where repo->ID = ? and IsDecommissioned = 0 "
	Set statement = ##class(%SQL.Statement).%New()
	Set tSC = statement.%Prepare(SQL)
	$$$ThrowOnError(tSC)
	Set resultSet = statement.%Execute(repoId)
	While resultSet.%Next() {
		Set $list(list, *+1) = resultSet.%GetData(1)
	}
	return list
}

ClassMethod GetAvailableProfiles(forServiceid As %String) As %List
{
	Set available = ""
	#dim instance as ServiceInstance = ..GetById(forServiceid)
	Set packageList = instance.packageList
	
	// Get profiles dependent on the core package (1st in the list)
	#dim customList as %ListOfDataTypes = ##class(HS.FHIRMeta.Storage.Package).GetCustomPackages($LG(packageList))
	for ord=1:1:customList.Count() {
		Set package = customList.GetAt(ord)
		if '$ListFind(packageList, package.id) {
			Set $List(available,*+1) = package.id
		}
	}
	return available
}

/// Create an instance of the InteractionsStrategy class that manages this Service
ClassMethod CreateStrategyForInstanceId(id As %String) As HS.FHIRServer.API.InteractionsStrategy
{
	Set instance = ..GetById(id)
	return instance.CreateStrategy()
}

/// Create an instance of the InteractionsStrategy class that manages this Service
Method CreateStrategy() As HS.FHIRServer.API.InteractionsStrategy [ CodeMode = expression ]
{
##class(HS.FHIRServer.API.InteractionsStrategy).getInstance($this)
}

/// Get the StrategyKey parameter for the InteractionsStrategy class that manages this Service
Method GetStrategyKey() As %String [ CodeMode = expression ]
{
..repo.strategyKey
}

}
