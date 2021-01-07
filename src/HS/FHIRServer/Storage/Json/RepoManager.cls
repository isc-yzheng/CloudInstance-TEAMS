Class HS.FHIRServer.Storage.Json.RepoManager Extends HS.FHIRServer.API.RepoManager
{

Parameter StrategyClass As %String = "HS.FHIRServer.Storage.Json.InteractionsStrategy";

Parameter StrategyKey As %String = "Json";

Parameter StrategyDesc As %String = "All Resources stored in a single table as Json text";

Parameter IsSingleServiceStrategy As %Boolean = 0;

Parameter AllResourcesTypeName As %String [ Internal ] = "Rsrc";

Method GetGlobalRoot(serviceId As %String) As %String [ CodeMode = expression ]
{
$Name(@..repo.globalRoot@(serviceId))
}

Method GetGlobalTempRoot(serviceId As %String) As %String [ CodeMode = expression ]
{
$Name(@..repo.globalTempRoot@(serviceId))
}

/// @API
/// Returns the index type for the specified resource type and parameter code
Method GetIndexType(resourceType As %String, paramCode As %String) As %Integer
{
	
 	return ##class(HS.FHIRServer.Storage.Json.SearchColumn).#PlainIndex
}

/// @API
/// Returns the table name that stores resources for the specified type
Method GetResourceTableName(serviceId As %String, resourceType As %String, shortName As %Boolean = 0) As %String
{
	Set type = ..#AllResourcesTypeName
 	return $Select(shortName:type, 1:$TR(..repo.resourceClassesPackage,".","_") _ "." _ type)
}

/// @API
/// Returns the classname of the persistent object used store resources for the specified type
Method GetResourceClassName(serviceId As %String, resourceType As %String) As %String [ CodeMode = expression ]
{
..repo.resourceClassesPackage _ "." _ ..#AllResourcesTypeName
}

/// @API
/// Returns the table name used to index the specified type.  Note, it may be the
/// same as the ResourceTable
Method GetSearchTableName(serviceId As %String, resourceType As %String, pChildName As %String, shortName As %Boolean = 0) As %String
{
	Set type = $Select(resourceType="":..#AllResourcesTypeName, 1:resourceType)
	Set package = ..repo.searchClassesPackage
	Set base = $TR(package,".","_")
	if pChildName'="" {
		Set base = base _ "_" _ type
		Set type = pChildName 
	}
	set type = $S($system.SQL.IsReservedWord(type):$C(34)_type_$C(34), 1:type)
	return $Select(shortName:type, 1:base _ "." _ type)
}

/// @API
/// Returns the classname of the persistent object used to index the specified type.  Note, it may be the
/// same as the ResourceClass
Method GetSearchClassName(serviceId As %String, resourceType As %String) As %String [ CodeMode = expression ]
{
..repo.searchClassesPackage _ "." _ $Select(resourceType="":..#AllResourcesTypeName, 1:resourceType)
}

/// @API
/// Returns the SQL Table name for older resource versions for the specified type
Method GetResourceVersionTableName(serviceId As %String, resourceType As %String, shortName As %Boolean = 0) As %String
{
	Set type = "RsrcVer"
 	return $Select(shortName:type, 1:$TR(..repo.versionClassesPackage,".","_") _ "." _ type)
}

/// @API
/// Returns the classname of the persistent object used store older resource versions for the specified type
Method GetResourceVersionClassName(serviceId As %String, resourceType As %String) As %String [ CodeMode = expression ]
{
..repo.versionClassesPackage _ "." _ "RsrcVer"
}

/// @API
/// Returns the classname of the persistent object used to index the specified type.  Note, it may be the
/// same as the ResourceClass
Method GetSearchColumnName(serviceId As %String, resourceType As %String, paramCode As %String) As %String [ Abstract ]
{
	set normalizedName = paramCode
	set tIdx=0
	for {
		set tIdx = $FIND(normalizedName, "-", tIdx) quit:tIdx=0
		set $E(normalizedName, tIdx-1, tIdx) = $ZCVT($E(normalizedName, tIdx), "U")
	}
	quit normalizedName
}

/// @API Create the service.  This method initializes a service for an endpoint
/// including generating any classes or schemas required and registering the configuration for
/// later modification or deletion
Method CreateService(serviceId As %String, ByRef options)
{
	#dim serviceInstance as HS.FHIRServer.ServiceInstance
	set serviceInstance = ##class(HS.FHIRServer.ServiceInstance).GetById(serviceId)
	
	#dim TRANSACTION as HS.Util.Scoped.Transaction = ##class(HS.Util.Scoped.Transaction).Start()
	#dim strategy as HS.FHIRServer.Storage.Json.InteractionsStrategy
	Set strategy = ..CreateStrategy(serviceId)
	
	// Generate the SearchColumn metadata for this strategy (if not already present)
	#dim metaAPI as HS.FHIRMeta.API = ##class(HS.FHIRMeta.API).getInstance(serviceInstance.packageList)

	do ##class(HS.FHIRServer.Storage.Json.SearchColumn).GenerateFromMeta(metaAPI, serviceInstance.parentRepo.%Id(), serviceId)

	#dim builder as HS.FHIRServer.Storage.SearchTableBuilder = ##class(HS.FHIRServer.Storage.SearchTableBuilder).%New(strategy)
	if $G(options("createIndexOnly")) '= 1 {
		Do builder.GenResourceTables()
	}
	Do builder.GenSearchTablesFromSchema(,,0)
	// Add permissions to the new tables
	do ##class(HS.HC.Util.Installer).SetupPermissions($namespace, "")
	w !,"Tables built",!
	
	Do ##class(HS.FHIRServer.ServiceAdmin).SetInstanceEnabled(serviceId, 1)
	if $Get(options("restURL")) '= "" {
		// Remove admin data for the endpoint being removed
		Do ##class(HS.FHIRServer.ServiceAdmin).SetInstanceIdForEndpoint(options("restURL"), serviceId)
	}
	Do TRANSACTION.Commit()
}

/// @API Decommission the service.  This method detaches a service from any REST endpoints, making it inaccessiable for
/// client operations.  The Json strategy deletes the search tables, but preserves all resources and versions.
Method DecommissionService(serviceId As %String, ByRef options)
{
	Set transaction = ##class(HS.Util.Scoped.Transaction).Start()

	Do ##class(HS.FHIRServer.ServiceAdmin).DecommissionInstance(serviceId)

	// Remove the Search Table data for this instance
	set tSC = $system.OBJ.DeletePackage(..repo.searchClassesPackage, "e")
	$$$ThrowOnError(tSC)

	// Remove the search table metadata for this instance
	do ##class(HS.FHIRServer.Storage.Json.SearchColumn).deleteColumnsForService(serviceId)

	Do transaction.Commit()
}

/// @API Delete the service.  This method removes a service.  This includes and FHIR data and
/// associated schema classes as well as registration data.  A decommissioned service cannot be removed.
/// Delete the schema (was ResetFHIRData)
/// options("deleteDataOnly") = 0/1
/// options("verbose") = 0/1
Method DeleteService(serviceId As %String, ByRef options)
{
	Set verbose = $Get(options("verbose"), 0)
	#dim TRANSACTION as HS.Util.Scoped.Transaction = ##class(HS.Util.Scoped.Transaction).Start()

	// Clear all tables in the Index package
	// flag "e" = Delete Extent
	set tFlags = "e"
	
	if $G(options("deleteDataOnly")) {
		for packageName = ..repo.resourceClassesPackage, ..repo.searchClassesPackage, ..repo.versionClassesPackage {
			Set tQuery = "SELECT ID FROM %Dictionary.CompiledClass where ID %StartsWith ?"
			Set tStatement = ##class(%SQL.Statement).%New()
			Set tSC = tStatement.%Prepare(tQuery)
			If $$$ISERR(tSC) {
				Set tText = "%Prepare failed for SQL query for search table reset: "_$System.Status.GetErrorText(tSC)
				If verbose {
					Write !,tText
				}
				$$$ThrowFHIR($$$GeneralError, tText)
			}
			Set tResultSet = tStatement.%Execute(packageName _ ".")
			
			While tResultSet.%Next() {
				Set tClassName = tResultSet.ID
				Set tSC = $ClassMethod(tClassName, "%DeleteExtent")
				If $$$ISERR(tSC) {
					Set tText = "Error in "_tClassName_".%DeleteExtent(): "_$System.Status.GetErrorText(tSC)
					If verbose {
						Write !,tText
					}
					$$$ThrowFHIR($$$GeneralError, tText)
				}
				
			}
		}
		//If ('tKilled)&&(pVerbose) Write !,"No search table data to clean up"
		
	} else {
		/// We delete all classes and data
		// We are deleting the search classes as well as all data
		do ##class(HS.FHIRServer.Storage.Json.SearchColumn).deleteColumnsForService(serviceId)
		
		set tSC = $system.OBJ.DeletePackage(..repo.searchClassesPackage, tFlags)
		$$$ThrowOnError(tSC)
			
		if $G(options("deleteIndexOnly")) '= 1 {
			// Delete the Resource Data
			set tSC = $system.OBJ.DeletePackage(..repo.resourceClassesPackage, tFlags)
			set tSC = $system.OBJ.DeletePackage(..repo.versionClassesPackage, tFlags)
			// Remove any data stored in globals
			kill @..GetGlobalRoot(serviceId)
			kill @..GetGlobalTempRoot(serviceId)
		}
	}		
	
	// Delete all of our data
	do TRANSACTION.Commit()
}

/// @API Update the schema. This method applies changes to an already configured schema (if possible)
/// For example, to add a search parameter including ensuring that the new field is indexed.
/// Handle changes to the schema structure 
/// 	options("packagesToAdd") = $LB(packageId, ...)
/// 	options("verbose") = 0/1
Method UpdateService(serviceId As %String, ByRef options)
{
	Set packageList = $G(options("packagesToAdd"))
	if packageList '= "" {
		// Update the Metadata package set for this service
		#dim instance as HS.FHIRServer.ServiceInstance
		Set instance = ##class(HS.FHIRServer.ServiceInstance).GetById(serviceId)

		Set currentPackageList = instance.packageList
		Set newPackageList = ##class(HS.FHIRMeta.Storage.Package).ResolvePackageList(currentPackageList _ packageList)
		//w "Old packages: ",$LTS(currentPackageList),!
		//w "New packages: ",$LTS(newPackageList),!
		
		#dim TRANSACTION as HS.Util.Scoped.Transaction = ##class(HS.Util.Scoped.Transaction).Start()
		#dim metaAPI as HS.FHIRMeta.API
		set metaAPI = ##class(HS.FHIRMeta.API).getInstance(newPackageList)
		
		set fullPackageList = metaAPI.PackageList
		
		do ##class(HS.FHIRServer.Storage.Json.SearchColumn).GenerateFromMeta(metaAPI, instance.parentRepo.%Id(), serviceId)
		
		#dim strategy as HS.FHIRServer.Storage.Json.InteractionsStrategy = ..CreateStrategy(serviceId)
		#dim builder as HS.FHIRServer.Storage.SearchTableBuilder = ##class(HS.FHIRServer.Storage.SearchTableBuilder).%New(strategy)
		Do builder.GenSearchTablesFromSchema(,,0)
		
		Set instance.metadataSetKey = fullPackageList
		$$$ThrowOnError(instance.%Save())
		
		//Refresh config data to pick up new metadata set
		do ##class(HS.FHIRServer.ServiceAdmin).SetInstanceConfigData(serviceId, ##class(HS.FHIRServer.ServiceAdmin).GetInstanceConfigData(serviceId))
		
		// Create a new FHIRMeta object with the updated package list
		do TRANSACTION.Commit()
	}
}

}
