Class HS.FHIRServer.Storage.Json.Tools.Index Extends %RegisteredObject
{

/// @API
/// Updates content of search columns
ClassMethod upgradeServiceMetadata(url As %String)
{
	
	set repoInst = ##class(HS.FHIRServer.ServiceInstance).FindByUrl(url)
	if '$isobject(repoInst) {
		write "Not found, url: ", url, !
		quit
	}
	
	do ..upgradeRepoMDVersion(repoInst.repo.%Id())
}

ClassMethod upgradeRepoMDVersion(repoId As %String)
{
		set tableList = ##class(HS.FHIRServer.Storage.Json.SearchColumn).getChangedTableListForRepoId(repoId)
		for ii=1:1:$ll(tableList) {
			set name = $list(tableList,ii)
			do ..upgradeTableMDVersion(name, repoId)
		}
		
		// Clear the added flag for all of the newly indexed parameters
		do ##class(HS.FHIRServer.Storage.Json.SearchColumn).resetAdded(repoId)

		// Update the CapabilityStatement resource for each service in this Repo
		Set serviceIdList = ##class(HS.FHIRServer.ServiceAdmin).GetServiceIdList(,repoId)
		set lix = 0
		while $ListNext(serviceIdList, lix, serviceId) {
			#dim instance as HS.FHIRServer.ServiceInstance
			Set instance = ##class(HS.FHIRServer.ServiceInstance).GetById(serviceId)
			#dim strategy as HS.FHIRServer.API.InteractionsStrategy = instance.CreateStrategy()
			Set interactions = strategy.NewInteractionsInstance()
			do interactions.SetMetadata( strategy.GetMetadataResource() )
		}
		write "All done",!
}

ClassMethod upgradeTableMDVersion(tableName As %String, repoId As %String)
{
	//temporary fix for finding the corresponding service
	&sql(select top 1 servicekey into :serviceKey from HS_FHIRServer_Storage_Json.SearchColumn where Repokey=:repoId)
	//

	#dim  repoMgr as HS.FHIRServer.API.RepoManager = ##class(HS.FHIRServer.API.RepoManager).getInstance(repoId)
	#dim service as HS.FHIRServer.API.Service = ##class(HS.FHIRServer.Service).EnsureInstance(serviceKey)
	Set package = repoMgr.repo.searchClassesPackage
	Set base = $TR(package,".","_")
	set resourceClassName = repoMgr.GetResourceClassName()
	#dim st as %SQL.Statement = ##class(%SQL.Statement).%New()
	set curMDVersion = ##class(HS.FHIRServer.Storage.Json.SearchTableVersion).getCurrentVer(repoId,tableName)
	set safeName = $S($system.SQL.IsReservedWord(tableName):$C(34)_tableName_$C(34), 1:tableName)
	
	set sql = "select Key FROM "_base_"."_safeName_" where MDVersion is null or MDVersion <> ?"
	set sc = st.%Prepare(.sql)
	$$$ThrowOnError(sc)
	#dim rs as %ResultSet = st.%Execute(curMDVersion)
	write "Processing ",tableName,!
	set count=0
	while (rs.%Next()) {
		set count = count+1
		if count#100=0 {
			write "Processing record # ",count,!
		}
		set obj = $classmethod(resourceClassName,"KeyIdxOpen",rs.%GetData(1))
		if '$isobject(obj) {
			continue
		}
		do service.interactions.IndexResource(obj)
		
	}
	write "table: "_tableName_" is done, ",count, " record(s) processed",!
}

}
