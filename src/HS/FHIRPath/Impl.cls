/// This is an internal class. Method should never be called directly.  All FHIRPath
/// functionality is accessible through an instance of the HS.FHIRPath.API class.
Class HS.FHIRPath.Impl Extends (Engine, Runtime, Datatype)
{

Method %OnNew(metaAPI As HS.FHIRMeta.API, trace As %Boolean = 0) As %Status
{
	Set ..schema = metaAPI
	Set ..trace = trace
	Do ..initEngine()
	Do ..initRuntime()
	Do ..initDatatype()
	return $$$OK
}

Method setTraceLevel(traceLevel As %Integer)
{
	set ..trace = traceLevel
}

}
