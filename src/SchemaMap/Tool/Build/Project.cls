Include SchemaMap

/// Contains utility methods that have been useful throughout the Schema Mapper tool project,
/// for populating data in the archived schema and mapping tables to support needed feature enhancements.
/// This tends to be necessary because the Schema Mapper tool is data-driven. New features mean new data.
/// <p>
/// Often these methods are intended for one-time-only use, but they remain as useful examples
/// of how to write similar methods which are likely to be needed in the future to maintain the tool.
/// Additionally, the project occasionally needs to return to specific methods to re-use them.
/// <p>
/// We do not deprecate or discard the methods, but keep them separate, in this class.
Class SchemaMap.Tool.Build.Project Extends SchemaMap.Tool.Base.Generate [ Abstract ]
{

/// This method is temporarily needed for the project to provide MapIssues and InfoPath column values for existing mapping tables.
/// This method recalculates and resets MapIssues, SourceInfoPath, and TargetInfoPath values for all mapping table rows, correcting any incorrect values.
/// After running this method, to create new mapping table CSV files, export all data for the project.
ClassMethod SetMapIssuesAndInfoForAllPaths(from As %String, to As %String) As %Status
{
}

/// This method sets DataType values for schema table rows, for a class-based schema, that 
/// don't already have a value in that column, and corrects any incorrect values present.
ClassMethod SetSuperclassForAllClassPaths(schema As %String, preview As %Boolean = 1) As %Status
{
}

/// This method adds schema table rows for the SDA3 class-based schema CSV file. 
/// It adds rows for SDA3 properties that are in most classes,
/// but that were not initially considered interesting for mapping to other schemas.
/// The need for mapping these properties to other schemas is now established.
/// <p>
/// This method does not change the SQL table on the current instance.
/// The developer who runs this method must check in the revised schema CSV file to Perforce, 
/// then that developer (and all others) must reinstall the tool by importing the new schema CSV file.
/// The reimport updates the SQL table and tool.
/// <p>
/// The input typeClasses is deprecated (not used in the code, but not removed, to not disrupt the signature).
/// It was intended as a comma-separated list of HS.SDA3 superclass names. 
/// All SDA3 classes with this value in the DataType column will get the properties added to it.
/// The HS.SDA3.SuperClass is the superclass targeted by the current implementation of this method.
/// <p>
/// This is a temporary utility, so it is not fully factored as a reusable API.
/// That is, the names of the properties to add and the specific data to insert into the column entries 
/// for these properties in each new row in the table are not parameterized.
/// They are hardcoded inside this method.
ClassMethod AddSDA3InheritedPropertiesToCSV(dirName As %String = "", typeClass As %String, preview As %Boolean = 1) As %Status
{
}

/// Similar to AddSDA3InheritedPropertiesToCSV in concept, but only adds CustomPairs.
ClassMethod AddSDA3CustomPairsToCSV(dirName As %String = "", preview As %Boolean = 1) As %Status
{
}

ClassMethod ExportSchemaCSVFile(schema As %String = "", dirName As %String = "") As %Status
{
}

ClassMethod WriteListOfPreviouslyReleasedDTL() As %Status
{
}

/// Regenerate all mapping table classes for all currently supported schema pairs.
/// For this to work, an import must have been previously run (the ^SchemaMap.Pairs global must be populated) 
/// while there was an appropriate list of pairs defined in SchemaMap.Import.Run:Setup().
/// <p>
/// The technique, to outsmart Studio source control hooks:
/// <p>
/// In Perforce, check out all the mapping table classes under SchemaMap.Map.
/// Close all Studio instances. At the Terminal run this command:
/// <p>
/// do $system.Status.DisplayError(##class(SchemaMap.Tool.Build.Project).GenerateMapClasses())
/// <p>
/// In Studio, open each mapping table class, do a dummy modification, save, then compile, then close it.
/// Perforce diff to verify changes are correct.
/// Perforce checkin the mapping table classes.
/// <p>
/// MAINTENANCE NOTE: It is important to keep Studio out of this procedure and to use the procedure steps as written.
/// If you said Yes to delete a generated class from Studio (not using this method, but while using Studio)
/// you can inadvertently also click a second Yes to ask Studio source control hooks to delete the class from Perforce.
/// If this happens, a LOGIC message output by SchemaMap.Tool.Base.Generate:CreateObject will say how to fix it.
ClassMethod GenerateMapClasses() As %Status
{
}

/// Regenerate all schema table classes for all currently supported schemas.
/// For instructions see GenerateMapClasses.
ClassMethod GenerateSchemaClasses() As %Status
{
}

/// Temporary method to assist transition between product versions for code tables (such as 1.0.x to latest).
/// If the answer is true, the CodeLookup report from SchemaMap.Tool.Build.Export will highlight this lookup table in the report.
/// From product version to product version, this method will need reworking, but it should be kept around because 
/// it speeds the lookup table expert review process (which is time-consuming on expensive expert resources).
/// <p>
/// MAINTENANCE NOTE: For product release projects for which this method is not needed, or after a project has finished using it,
/// remove or comment out everything inside the try block. 
/// Here is an example of code that might appear inside the try block while this method is in use:
/// </p>
/// <pre>
/// 		set bool = ((from = "FHIR3") && (to = "SDA3")) || 
/// 				((from = "SDA3") && (to = "FHIR3") && 
/// 				(
/// 					((sourceTable = "HS.SDA3.Blob:FileType") && (targetTable = "MimeType RFC 4289")) ||
/// 					((sourceTable = "HS.SDA3.CodeTableDetail.DiagnosisStatus") && (targetTable = "condition-clinical")) ||
/// 					((sourceTable = "HS.SDA3.CodeTableDetail.DocumentCompletionStatus") && (targetTable = "composition-status")) ||
/// 					((sourceTable = "HS.SDA3.CodeTableDetail.DocumentStatus") && (targetTable = "document-reference-status"))
/// 				)
/// 				)
/// </pre>
ClassMethod IsLookupEntryWorthHighlighting(from As %String = "", to As %String = "", sourceTable As %String = "", targetTable As %String = "") As %Boolean
{
}

}
