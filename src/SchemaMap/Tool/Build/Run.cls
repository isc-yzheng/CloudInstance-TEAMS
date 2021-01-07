Include SchemaMap

/// manages import and export to and from CSV for various purposes,
/// related to developer collaboration and Perforce storage of shared work
Class SchemaMap.Tool.Build.Run [ Abstract ]
{

ClassMethod Setup() As %Status
{
}

/// This method deletes and regenerates the following items from imported schema data:
/// Data model classes for FHIR STU3 and FHIR DSTU2,
/// Data that guides Schema Mapper code generation, 
/// Data that controls the Schema Mapper UI,
/// All schema tables,
/// All mapping tables,
/// All lookup tables,
/// All project and tool configuration data.
ClassMethod Install(dirName As %String = "") As %Status
{
}

ClassMethod IsDev() As %Boolean
{
}

/// Ensure EnableEdit is called after JSONDataFiles, which kills the ^SchemaMap.Config global that this method sets.
/// Ensure EnableEdit is called before BuildGlobal, which sets some reference data based on the current BuildMode.
/// <p>
/// If the SchemaMap.Dev module is not available, we use 0 for enableEdit. 
/// <p>
/// This method sets the correct BuildMode based on enableEdit: read-only has Delivery, read-write has Development.
/// Note: when the BuildMode on an instance is set to Development, starting the delivery sequence 
/// temporarily sets the BuildMode to Delivery, then at the end of the sequence resets it to Development. 
ClassMethod EnableEdit(enableEdit As %Boolean = 0) As %Status
{
}

ClassMethod ProjectArchiveDirectory() As %String
{
}

ClassMethod BuildGlobal() As %Status
{
}

ClassMethod BuildModel() As %Status
{
}

/// This method must be called after the ^SchemaMap.Paths global is built and 
/// after the FHIR data model classes are built (after BuildGlobal and BuildModel).
/// After that, the data that BuildHelp requires will be present in the ^SchemaMap.Paths global.
/// This method adds required finishing touches to ^SchemaMap.Paths.
ClassMethod BuildHelp() As %Status
{
}

ClassMethod BuildDTL() As %Status
{
}

}
