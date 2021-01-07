Include SchemaMap

Class SchemaMap.Tool.SQL.Write Extends SchemaMap.Tool.SQL.Base
{

/// Write data to the mapping table. Can be constrained by providing an optional row ID, path, and/or an additional clause. 
/// If a row ID is provided, this method writes to only that row from the SQL table, and ignores any path or clause input to this method.
/// If there is no row ID provided, the method consults the path and clause for filters to apply to the query.
/// The method searches on the path name exactly as provided, as well as entries that are contained within that path.
ClassMethod Map(from As %String, to As %String, row As %String = "", path As %String = "", clause As %String = "", setColumn As %String, setValue As %String, args...) As %Status
{
}

/// Write data to the schema table. Can be constrained by providing a path and/or an additional clause. <var>order</var> if set to 1 will order based on Path,
/// otherwise it will be sorted by ID. <var>sqlargs</var> can be used to store variables that are used in <var>clause</var>.
ClassMethod Schema(schema As %String, path As %String = "", clause As %String = "", setColumn As %String, setValue As %String, args...) As %Status
{
}

}
