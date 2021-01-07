/// This class provides utility code that a delivery instance needs, in order to
/// run code that was generated and delivered to it from the Schema Mapper tool.
/// By design, every method in this class is safe to run on a delivery instance
/// but also works correctly on a developer instance.
/// <p>
/// NOTE: To be safe to run on a delivery instance, 
/// code in Lib and Gen packages must not use: SchemaMap.inc, 
/// class packages other than SchemaMap.Lib and SchemaMap.Gen,
/// $$$Map macros, or globals other than those delivered via 
/// product installation (the dev_healthshare/XF folder).
Class SchemaMap.Lib.Util.Package
{

/// Supported values are "Development" or "Delivery", default is "Development".
ClassMethod SetBuildMode(mode As %String = "Development")
{
}

ClassMethod GetBuildMode() As %String
{
}

/// Find out the delivery schema name from a development schema name
ClassMethod GetConfiguredSchemaName(schema As %String = "") As %String
{
}

/// Find out development mode schema name from a configured schema name
ClassMethod GetMapperSchemaName(schema As %String = "") As %String
{
}

/// Find out the delivery schema name from a generated object model full class name
ClassMethod GetConfiguredSchemaFromClassname(className As %String = "") As %String
{
}

/// Find out the development schema name from a generated object model full class name
ClassMethod GetMapperSchemaFromClassname(className As %String = "") As %String
{
}

ClassMethod GetConfiguredProjectName() As %String
{
}

ClassMethod GetConfiguredPackageName(package As %String = "") As %String
{
}

ClassMethod GetConfiguredPackageModelName(schema As %String = "") As %String
{
}

}
