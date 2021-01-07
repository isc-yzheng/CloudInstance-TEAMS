Include SchemaMap

Class SchemaMap.Tool.SQL.Read Extends SchemaMap.Tool.SQL.Base
{

/// Fetch data from the mapping table. Can be constrained by providing an optional row ID, path, and/or an additional clause. 
/// If a row ID is provided, this method returns only that row from the SQL table, and ignores any path or clause input to this method.
/// If there is no row ID provided, the method consults the path and clause for filters to apply to the query.
/// The method searches on the path name exactly as provided, as well as entries that are contained within that path.
/// <p>
/// The %SQL.StatementResult returned by this query is used often, and for various purposes.
/// Among these purposes is to send an object, with certain values from a mapping table row,
/// into the SchemaMap.Tool.Validate.Mapping:GetInfo method to calculate a new MapIssues value for the row.
/// This is done sometimes for an existing row, and sometimes as a preview for a potential row.
/// <p>
/// To assist the preview of MapIssues for a potential row, 
/// callers can use SchemaMap.Tool.Data.Parse:FormMapResultObjectFromValues to create a %DynamicObject that 
/// has the same properties as the %SQL.StatementResult from this Map method. Note that whenever the result properties
/// from Map change, developers should check whether FormMapResultObjectFromValues needs to be updated, 
/// or calls to GetInfo that use FormMapResultObjectFromValues could break.
ClassMethod Map(from As %String, to As %String, Output result As %SQL.StatementResult, row As %String = "", path As %String = "", contained As %Boolean = 0, clause As %String = "", args...) As %Status
{
}

/// Determines whether or not there is any useful data in the properties of a result object
/// from a call to the Map() method in this class. If there is, returns 1 (true).
ClassMethod Mapped(result As %SQL.StatementResult) As %Boolean
{
}

/// Fetch data from the schema table. Can be constrained by providing a path and/or an additional clause. <var>order</var> if set to 1 will order based on Path,
/// otherwise it will be sorted by ID. <var>sqlargs</var> can be used to store variables that are used in <var>clause</var>.
/// <p>
/// This SQL query assigns names to properties in the result object that it returns.
/// These result object property names are NOT necessarily the same as the SQL column names.
/// Property names returned by this method are expected by the code that uses the result object. 
/// They are:
/// <p>
/// ID, Path, DataType,
/// Cardinality, Description 
/// <p>
/// Plus, for FHIR-based schemas only, these properties: 
/// <p>
/// Mod, Category
ClassMethod Schema(schema As %String, Output result As %SQL.StatementResult, path As %String = "", contained As %Boolean = 0, clause As %String = "", order As %Boolean = 0, args...) As %Status
{
}

}
