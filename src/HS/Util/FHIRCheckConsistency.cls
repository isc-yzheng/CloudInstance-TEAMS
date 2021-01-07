Class HS.Util.FHIRCheckConsistency Extends %RegisteredObject
{

Property resourceTable As %String;

Property resourceClass As %String;

Property strategy As HS.FHIRServer.API.InteractionsStrategy;

/// returns number of missing resources
Method process(fix = 0) As %Integer
{
		set ret = 0
		set statement = ##class(%SQL.Statement).%New()
		set sql = "select ResourceType, key from "_..resourceTable
		set status = statement.%Prepare(sql)
		if $$$ISERR(status) {
			w $system.OBJ.DisplayError(status)
			quit -1
		}
		set rs = statement.%Execute()
		while (rs.%Next()) {
			set type = rs.%GetData(1)
			set className = ..strategy.GetSearchClass(type)
			if ('$classmethod(className, "KeyIdxExists", rs.%GetData(2))) {
				w rs.%GetData(2),!
				set ret = ret+1
				if fix {
					set storageObject = $classmethod(..resourceClass, "KeyIdxOpen", rs.%GetData(2))
					set indexer = ##class(HS.FHIRServer.Storage.Indexer).%New(storageObject.ResourceObject , ..strategy.NewInteractionsInstance())
					d indexer.IndexValues()
				}
			}
		}
		quit ret
}

ClassMethod test()
{
	set obj = ..%New("/csp/healthshare/hsods/fhir/r3")
	w obj.process(1)," inconsistent resources were found",!
}

Method %OnNew(endpoint) As %Status
{
		Set ..strategy = ##class(HS.FHIRServer.API.InteractionsStrategy).GetStrategyForEndpoint(endpoint)
		set ..resourceTable = ..strategy.GetResourceTable("")
		set ..resourceClass = ..strategy.GetResourceClass("")
		quit $$$OK
}

}
