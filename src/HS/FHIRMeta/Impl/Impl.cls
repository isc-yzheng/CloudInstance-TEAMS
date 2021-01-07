Class HS.FHIRMeta.Impl.Impl Extends (HS.FHIRMeta.Impl.TypeInfo, HS.FHIRMeta.Impl.SearchInfo, HS.FHIRMeta.Impl.MetaRsrcInfo)
{

Property %FHIRPathAPI As HS.FHIRPath.API [ Private ];

Method %OnNew(mdsKey As %String, globalRoot As %String = "") As %Status [ Private ]
{
	Do ##super(##class(HS.FHIRMeta.Storage.Package).ResolvePackageList(mdsKey), globalRoot)
	do ..initTypeInfo()
	do ..initSearch()
	Quit $$$OK
}

Method FHIRPathAPIGet() As HS.FHIRPath.API
{
	if '$IsObject(..%FHIRPathAPI) {
		Set ..%FHIRPathAPI = ##class(HS.FHIRPath.API).%New($this)
	}
	return ..%FHIRPathAPI
}

}
