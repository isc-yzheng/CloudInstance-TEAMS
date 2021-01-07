Class SchemaMap.Tool.Build.Installer Extends %ZHSLIB.AbstractInstaller
{

Parameter MaintenanceVersion = 1;

Parameter Version = 0.0;

ClassMethod OnConfigureComponent(pNamespace As %String, pVerbose As %Boolean = 0, ByRef pVars) As %Status
{
}

/// Returns a list of packages that need to be mapped for the Schema Mapper to work properly in a different namespace
ClassMethod GetPackages() As %List
{
}

/// Returns a list of globals that need to be mapped for the Schema Mapper to work properly in a different namespace
ClassMethod GetGlobals() As %List
{
}

/// Returns a list of routines that need to be mapped for the Schema Mapper to work properly in a different namespace
ClassMethod GetRoutines() As %List
{
}

}
