Include SchemaMap

/// generates an SchemaMap.Map.*.* class for a given pair of schemas; 
/// first * is "from" and second * is "to"
Class SchemaMap.Map.Generate Extends SchemaMap.Tool.Base.Generate [ Abstract ]
{

ClassMethod CreateObject(pFrom As %String, pTo As %String) As %Status
{
}

ClassMethod CreateMethod(classDefinition As %Dictionary.ClassDefinition, pMethodName As %String, pFrom As %String, pTo As %String) As %Status
{
}

ClassMethod WriteImportFileFrom(pMethod As %Dictionary.MethodDefinition, pFrom As %String, pTo As %String) As %Status
{
}

ClassMethod WriteExportFileTo(pMethod As %Dictionary.MethodDefinition) As %Status
{
}

ClassMethod WriteExportToStream(pMethod As %Dictionary.MethodDefinition) As %Status
{
}

ClassMethod WriteOnBeforeSave(pMethod As %Dictionary.MethodDefinition, pFrom As %String, pTo As %String) As %Status
{
}

}
