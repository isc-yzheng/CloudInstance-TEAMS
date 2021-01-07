Include HS.FHIRServer

Class HS.FHIRServer.ServiceAdmin [ Abstract ]
{

ClassMethod Show()
{
	Set SQL = "SELECT repo->ID, serviceId FROM HS_FHIRServer.RepoInstance order by repo->ID asc, cspUrl asc"
	Set statement = ##class(%SQL.Statement).%New()
	Set tSC = statement.%Prepare(SQL)
	$$$ThrowOnError(tSC)
	Set resultSet = statement.%Execute()
	While resultSet.%Next() {
		Set rid = resultSet.%GetData(1)
		Set id = resultSet.%GetData(2)
		Set IDS(rid, id) = ""
	}
	
	set rid = ""
	for {
		Set rid = $Order(IDS(rid))
		Quit:(rid="")
		#dim repo as Repo = ##class(Repo).GetById(rid)
		w "Repo[",rid,"]",!
		w "           Strategy: ", repo.GetStrategyKey(), "(",repo.strategyClass,")",!
		w "     Search Package: ", repo.searchClassesPackage,!
		w "  Resources Package: ", repo.resourceClassesPackage,!
		w "  Versions Package: ", repo.versionClassesPackage,!
		w "            Globals: ", repo.globalRoot,!
		w "       Temp Globals: ", repo.globalTempRoot,!
		Set sid = ""
		for {
			Set sid = $Order(IDS(rid, sid))
			Quit:(sid="")
			
			Set inst = ##class(ServiceInstance).GetById(sid)
			w "    Instance[",sid,"]",!
			w "        isEnabled: ",inst.isEnabled,!
			w "           cspUrl: ",inst.cspUrl,!
			w "       configData: ",inst.serviceConfigData,!
		}
	}
}

/// Return a list of all endpoints, or endpoints accessing a specific service
/// @Input serviceId  If omitted, return all endpoints, otherwise just the endpoints that
/// provide access to the specified service.
/// @Return a %List of REST endpoint URLs
ClassMethod GetEndpointList(serviceId As %String = "") As %List
{
	Set SQL = "SELECT distinct serviceId, cspURL FROM HS_FHIRServer.RepoInstance"
	Set list = ""
	Set statement = ##class(%SQL.Statement).%New()
	Set tSC = statement.%Prepare(SQL)
	$$$ThrowOnError(tSC)
	Set resultSet = statement.%Execute()
	While resultSet.%Next() {
		Set id = resultSet.%GetData(1)
		if (serviceId = "") || (serviceId = id) {
			set url = resultSet.%GetData(2)
			if url '= "" {
				// This service has an endpoint
				Set $list(list, *+1) = url
			}
		}
	}
	return list
}

ClassMethod requireWritePermission()
{
	/// TODO: Add Permission Checking for Administrative changes ... Since this is
	/// base functionality, we need a way to specify the required resource (perhaps %HSFHIR_ServiceAdmin which
	/// in HealthShare can be granted to the %HSAdmin_InstallationManagement role.
	return
	
	$$$FSLog("Check Permissions: " _  $System.Security.Check("%HSAdmin_InstallationManagement") _ " for Roles: " _ $Roles )
	if ' $System.Security.Check("%HSFHIR_ServiceAdmin", "WRITE") {
		$$$ThrowFHIR($$$GeneralError, "Administrative Access is Required",$$$OutcomeIs(403,"error","access"))
	}
}

/// Return a list of all ServiceInstance Ids.  The list may be filtered by strategyKey
/// or repoId.  Note that because each repo has a single Strategy, use of both filters
/// is redundant the repoId will be used if both are present.
/// <br>@Input strategyKey  If omitted, return all endpoints, otherwise just the ids that
/// honor the specified Strategy
/// <br>@Input repoId  If present, limit to just the ids that for the specified Repo
/// <br>@Return a %List of ServiceInstance Ids
ClassMethod GetServiceIdList(strategyKey As %String = "", repoId As %String = "") As %List
{
	if repoId'="" {
		return ##class(HS.FHIRServer.ServiceInstance).GetIdListByRepoId(repoId)
	} else {
		return ##class(HS.FHIRServer.ServiceInstance).GetIdListByStrategyKey(strategyKey)
	}
}

ClassMethod EndpointExists(cspPath As %String) As %Boolean [ CodeMode = expression ]
{
''..GetInstanceIdForEndpoint(cspPath)
}

ClassMethod IsEndpointEnabled(cspPath As %String) As %Boolean [ CodeMode = expression ]
{
..IsInstanceEnabled(..GetInstanceIdForEndpoint(cspPath))
}

ClassMethod SetEndpointEnabled(cspPath As %String, isEnabled As %Boolean)
{
	do ..requireWritePermission()
	Do ..SetInstanceEnabled(..GetInstanceIdForEndpoint(cspPath), isEnabled)
}

ClassMethod SetInstanceIdForEndpoint(cspPath As %String, instanceId As %String)
{
	do ..requireWritePermission()
	TSTART
	try {
		#dim oldInstance as ServiceInstance = ##class(ServiceInstance).FindByUrl(cspPath)
		if (oldInstance '= "") {
			if (oldInstance.serviceId = instanceId) {
				quit
			}
			Set oldInstance.cspUrl = ""
			$$$ThrowOnError(oldInstance.%Save())
			// Force a reload of the old Service instances in all processes
			Do ##class(HS.FHIRServer.Service).InvalidateInstances(oldInstance.serviceId)
		}
		#dim instance as ServiceInstance= ##class(ServiceInstance).GetById(instanceId)
		Set instance.cspUrl = cspPath
		$$$ThrowOnError(instance.%Save())
		// Force a reload of the new Service instances in all processes
		Do ##class(HS.FHIRServer.Service).InvalidateInstances(instanceId)
	} catch ex {
		TROLLBACK 1
		throw ex
	}
	TCOMMIT
}

ClassMethod DetachEndpointFromInstance(cspPath As %String)
{
	do ..requireWritePermission()
	#dim instance as ServiceInstance = ##class(ServiceInstance).FindByUrl(cspPath)
	if instance '= "" {
		Set instance.cspUrl = ""
		$$$ThrowOnError(instance.%Save())
		// Force a reload of the new Service instances in all processes
		Do ##class(HS.FHIRServer.Service).InvalidateInstances(instance.serviceId)
		
	}
}

ClassMethod GetInstanceIdForEndpoint(cspPath As %String) As %String
{
	#dim instance as ServiceInstance = ##class(ServiceInstance).FindByUrl(cspPath)
	return $S(instance="":"", 1:instance.serviceId)
}

ClassMethod GetInstanceForEndpoint(cspPath As %String) As HS.FHIRServer.ServiceInstance
{
	return ##class(ServiceInstance).FindByUrl(cspPath)
}

ClassMethod IsInstanceEnabled(instanceId As %String) As %Boolean
{
	#dim instance as ServiceInstance= ##class(ServiceInstance).GetById(instanceId)
	return instance.isEnabled
}

ClassMethod SetInstanceEnabled(instanceId As %String, isEnabled As %Boolean)
{
	do ..requireWritePermission()
	#dim instance as ServiceInstance= ##class(ServiceInstance).GetById(instanceId)
	Set instance.isEnabled = ''isEnabled
	$$$ThrowOnError(instance.%Save())
	// Force a reload of the new Service instances in all processes
	Do ##class(HS.FHIRServer.Service).InvalidateInstances(instanceId)
}

/// Returns whether the instance has been decommissioned.
/// @Param instanceId - The Id of the instance to decommission.  Throws if no such
/// instance exists
ClassMethod IsInstanceDecommissioned(instanceId As %String) As %Boolean
{
	#dim instance as ServiceInstance= ##class(ServiceInstance).GetById(instanceId)
	return instance.IsDecommissioned
}

/// Decommissions the Service.  Any endpoints accessing the specified service are detached from the service.  A strategy
/// may delete or preserve data as appropriate for the retention policies it implements.
/// @Param instanceId - The Id of the instance to decommission.  Throws if no such
/// instance exists.
ClassMethod DecommissionInstance(instanceId As %String)
{
	do ..requireWritePermission()
	#dim instance as ServiceInstance= ##class(ServiceInstance).GetById(instanceId)
	if 'instance.IsDecommissioned {
		Set instance.IsDecommissioned = 1
		Set instance.cspUrl = ""
		$$$ThrowOnError( instance.%Save() )
		// Force a reload of the new Service instances in all processes
		Do ##class(HS.FHIRServer.Service).InvalidateInstances(instanceId)
	}
}

ClassMethod DeleteInstance(instanceId As %String)
{
	do ..requireWritePermission()
	do ##class(ServiceInstance).DeleteById(instanceId)
}

/// Return the Service Configuration data for the specified instance id
ClassMethod GetInstanceConfigData(instanceId As %String) As HS.FHIRServer.API.ConfigData
{
	#dim inst as ServiceInstance= ##class(ServiceInstance).GetById(instanceId)
	return ##class(HS.FHIRServer.API.ConfigData).FromJSON( inst.serviceConfigData )
}

ClassMethod SetInstanceConfigData(instanceId As %String, configData As HS.FHIRServer.API.ConfigData)
{
	$$$FSLog("Updating Config for instance " _ instanceId )
	do ..requireWritePermission()
	#dim inst as ServiceInstance= ##class(ServiceInstance).GetById(instanceId)
	
	//Don't allow modification of metadata set or strategy class. those are defined by the service
	//instance.
	set configData.FHIRMetadataSet = $listtostring(inst.metadataSetKey)
	set configData.InteractionsStrategyClass = inst.strategyClass
	
	Set inst.serviceConfigData = configData.AsJSONString()
	$$$ThrowOnError(inst.%Save())

	// Possibly modify the "create each time" flag in the Service
	Set debugMode = (configData.DebugMode \ $$$FHIRDebugNewInstance # 2) 
	Do ##class(HS.FHIRServer.Service).SetDebugMode(instanceId, debugMode)
	
	// Force a reload of Service instances in all processes
	Do ##class(HS.FHIRServer.Service).InvalidateInstances(instanceId)
}

ClassMethod CanDeleteMetadataPackage(packageId As %String) As %Status
{
	Set sc = $$$OK
	#dim package as HS.FHIRMeta.Storage.Package
	Set package = ##class(HS.FHIRMeta.Storage.Package).GetById(packageId)
	Set instanceIdList = package.GetServiceInstanceIdList()
	if instanceIdList '= "" {
		set eplist = ""
		set lix = 0
		while $ListNext(instanceIdList, lix, instanceId) {
			Set urls = ..GetEndpointList(instanceId)
			if urls = "" {
				Set urls = $LB("instance["_instanceId_"]")
			}
			Set eplist = eplist _ urls
		}
		Set sc = $$$ERROR($$$GeneralError, "Metadata package '" _ packageId _ "' is still in use by endpoints ("_$LTS(eplist)_")")
	}
	return sc
}

ClassMethod DeleteMetadataPackage(packageId As %String)
{
	/// Do not delete if in use
	$$$ThrowOnError(..CanDeleteMetadataPackage(packageId))
	Do ##class(HS.FHIRMeta.Storage.Package).Delete(packageId)
}

ClassMethod GetStrategyKeyFromClass(pStrategyClass As %String) As %String
{
	Set strategyKey = ""
	try {
		// If the specified class has a StrategyKey parameter (obsolete)
		set strategyKey = $Parameter(pStrategyClass,"StrategyKey")
	} catch {}
	
	if strategyKey = "" {
		// Search all strategies for one that has this class.
		// Determine the Strategy Key from the requested Strategy Class
		do ##class(HS.FHIRServer.API.RepoManager).GetStrategyList(.infoList)
		set strategyKey = "" 
		for {
			Set strategyKey = $Order(infoList(strategyKey), 1, strategyClass)
			if strategyKey="" {
				$$$ThrowFHIR($$$GeneralError,"The specified 'pStrategyClass' is not used by any strategy: "_pStrategyClass)
			}
			if strategyClass = pStrategyClass {
				Quit
			}
		}
	}
	return strategyKey
}

}
