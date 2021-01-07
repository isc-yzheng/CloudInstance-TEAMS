/// This class is obsolete and can be removed, it is replaced with new metadata loading
/// 
Class HS.FHIRServer.Tools.FHIRMetadataSetLoader [ Abstract ]
{

ClassMethod bootstrap(force As %Boolean = 0) [ Deprecated ]
{
	do ##class(HS.FHIRMeta.API).bootstrapMetadataSets(force)
}

ClassMethod BuildGlobals(key As %String, force As %Boolean = 0) As HS.FHIRMeta.API [ Deprecated ]
{
	#dim mdapi as HS.FHIRMeta.API = ##class(HS.FHIRMeta.API).getInstance(key)
	if force {
		do mdapi.Load()
	}
	return mdapi
}

}
