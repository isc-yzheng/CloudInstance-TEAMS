Include SchemaMap

/// provides utility methods for writing information 
/// out to the mapping data tables: "create, update, delete" for CRUD
Class SchemaMap.Tool.Data.Write [ Abstract ]
{

/// Saves a new row in the mapping table. If <var>autoMapped</var> is true, anything contained within <var>fromPath</var> will also
/// be mapped, if possible. <var>userMessage</var> will return any message for the user, if it's necessary.
ClassMethod SaveRow(from As %String, to As %String, id As %String = "", fromPath As %String = "", sourceValue As %String = "", sourceXF As %String = "", toPath As %String = "", toXF As %String = "", autoMapped As %Boolean = 0, subtransform As %String = "", classMethod As %String = "", defaultValue As %String = "", extension As %String = "", dependsOn As %String = "", mapNotes As %String = "", append As %Boolean = 0, exclude As %String = "", active As %Boolean = 1, Output userMessage As %String = "") As %Status
{
}

/// Adds an empty row in the mapping table.
ClassMethod AddRow(from As %String, to As %String, fromPath As %String = "", sourceValue As %String = "") As %Status
{
}

/// Deletes a row in the mapping table.
ClassMethod DeleteRow(from As %String, to As %String, id As %String) As %Status
{
}

/// Mark a row or rows active or inactive, according to the input status value. 
/// row is a row id value in the mapping table indicated by from and to.
/// row may be a comma-separated list of row id values, or only 1 row id value.
/// row takes precedence over resource if both are supplied.
/// If there is no row value, and there is a resource value, all rows mapped from that source resource will be marked as indicated.
ClassMethod ActiveRow(from As %String, to As %String, status As %Boolean = 1, resource As %String = "", row As %String = "") As %Status
{
}

/// Checks to see if there is a potential subtransform or classmethod that can be used for this transform. If so, they will be
/// returned in <var>subtransform</var> or <var>classMethod</var>. <var>notValid</var> will return true if no such utility can
/// be found and the mapping is determined to need one.
ClassMethod EnsureUtility(from As %String, to As %String, fromPath As %String = "", toPath As %String = "", autoMapped As %Boolean, Output subtransform As %String = "", Output classMethod As %String = "", Output notValid As %Boolean) As %Status
{
}

/// Maps the contents of <var>fromPath</var> to the contents of <var>toPath</var>. It is assumed both paths
/// are objects. It will also attempt to map a field to an extension in the target schema if there is no
/// better matching field.
ClassMethod ObjectToObject(from As %String, to As %String, fromPath As %String, toPath As %String) As %Status
{
}

ClassMethod GenerateExtensionURL(from As %String, fromPath As %String, Output url As %String) As %Status
{
}

/// Returns the rowId for a mapping given the <var>fromPath</var>. Used to determine whether the path needs another
/// mapping. If it already has one, we can skip it.
ClassMethod MappingForPath(from As %String, to As %String, fromPath As %String, Output rowId As %String) As %Status
{
}

/// <var>overwrite</var> returns true when it is safe to overwrite a mapping for an object. It checks
/// to make sure there are no manual mappings within the object at the path.
ClassMethod ShouldOverwrite(from As %String, to As %String, path As %String, Output overwrite As %Boolean) As %Status
{
}

/// Add an element name to the given path, always making sure the format has a ":" between the resource and first
/// level of element, but only "." afterwards.
ClassMethod AddElementToPath(schema As %String, path As %String, element As %String) As %String
{
}

ClassMethod PathFromProperty(classname As %String = "", property As %String) As %String
{
}

ClassMethod CheckMatch(fromClass As %String, toClass As %String, Output exactMatch As %Boolean = 0, level As %Integer = 1) As %Status
{
}

/// Clears out all mappings for a given resource. If clearAll is true, everything for that resource is deleted.
/// If it is false, only those mappings that were auto-mapped will be deleted.
/// During this operation, empty mapping table entries created to support UI operations are also deleted.
ClassMethod ClearResource(from As %String, to As %String, resource As %String, clearAll As %Boolean = 0) As %Status
{
}

/// Remove any empty mapping table rows for the specified mapping table (from and to).
/// If fromPath is supplied and non-empty, only delete rows for the specified fromPath.
/// The fromPath value is exact ONLY.
ClassMethod RemoveEmptyRows(from As %String, to As %String, fromPath As %String = "") As %Status
{
}

/// This will go through the mapping table and clean up any stray mappings that
/// are handled higher up (eg. using a subtransform).
ClassMethod CleanUpMappings(from As %String, to As %String) As %Status
{
}

/// This will go through the mapping table, clear, and re-automap
/// every resource.
ClassMethod ReloadAutoMappings(from As %String, to As %String) As %Status
{
}

/// This will go through the mapping table and see if there are any instances where the
/// newly created transform could replace existing mappings, and will update those entries.
ClassMethod UpdateTableWithNewTransform(from As %String, to As %String, transform As %String) As %Status
{
}

/// This will search the mappings for the given resource, and for each object in that resource see if there are entries in the
/// mapping table with a type that matches the object's type. If there are, it will generate that transform first then update
/// the object's mapping in the given resource to use that subtransform.
ClassMethod ReplaceMappingsWithTransforms(package As %String, from As %String, to As %String, fromResource As %String) As %Status
{
}

ClassMethod NewTransform(from As %String, to As %String, source As %String, target As %String, DTLName As %String) As %Status
{
}

/// Applies the input toXF value to the TargetTransform column for all mapping table rows whose SourcePath indicates the same resource as the fromPath.
/// <var>userMessage</var> will return any message for the user, if it's necessary.
ClassMethod ApplyAllTargetTransform(from As %String, to As %String, id As %String = "", fromPath As %String = "", toXF As %String = "", Output userMessage As %String = "") As %Status
{
}

}
