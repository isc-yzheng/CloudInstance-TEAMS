Class HS.FHIRMeta.Load.ExtensionType Extends Type
{

Property fixedUri As %String;

Property isValueAllowed As %Boolean;

Property noExtensionAllowed As %Boolean;

Method %OnNew(id As %String, url As %String, kind As %String = "extension-type", fixedUri As %String, noExtensionAllowed As %Boolean, isValueAllowed As %Boolean) As %Status
{
	do ##super(id, url, kind)
	Set ..fixedUri = fixedUri
	Set ..isValueAllowed = isValueAllowed
	Set ..noExtensionAllowed = noExtensionAllowed
	return $$$OK
}

Method asString() As %String
{
	Set str = "[x: " _ ..id 
	if ' ..isValueAllowed {
		set str = str _ ", NoVal"
	}
	if ..noExtensionAllowed {
		set str = str _ ", NoExtn"
	}
	if ..fixedUri '= "" {
		set str = str _ ", uri=" _ ..fixedUri
	}
	return str _ "]"
}

}
