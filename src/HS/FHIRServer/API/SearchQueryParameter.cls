Class HS.FHIRServer.API.SearchQueryParameter Extends %RegisteredObject
{

Property searchParam;

Property name As %String;

Property value As %String;

Property modifier As %String;

Property nextInChain As HS.FHIRServer.API.SearchQueryParameter;

Property nextInRevChain As HS.FHIRServer.API.SearchQueryParameter;

Method %OnNew(name As %String, value As %String, modifier As %String = "", searchParam As HS.FHIRServer.SearchParam = "") As %Status
{
		//w name,modifier,value,!

		Set ..name = name
		Set ..searchParam = searchParam
		Set ..value = value
		Set ..modifier = modifier
		
		return $$$OK
}

Method AsString()
{
	Set param = $this
	Set str = ""	
	if param.nextInRevChain '= "" {
		// Reverse chain as represented in param is a specialized structure that
		// does not lend itself to the remaining logic in this method.
		// TODO: Nested reverse chain, such as
		// _has:Observation:patient:_has:AuditEvent:entity:agent-name=MyUserId
		// is not represented intuitively in param, and is not properly parsed
		// to string at this time.
		Set str = str _ "=" _ $ZConvert(param.value, "O", "URL")
		while param.nextInRevChain '="" {
			Set str = "_has:" _ param.searchParam.resourceType _ ":" _ param.nextInRevChain.name _":" _ param.name _ str
			Set param = param.nextInRevChain
		}
		
		return str
	}
	while param.nextInChain '= "" {
		Set str = str _ param.name _ ":" _ param.modifier _ "."
		Set param = param.nextInChain
	}
	Set str = str _ param.name
	if param.modifier '= "" {
		Set str = str _ ":" _ param.modifier
	}
	Set str = str _ "=" _ $ZConvert(param.value,"O","URL")
	return str
}

}
