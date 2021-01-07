Include SchemaMap

Class SchemaMap.Tool.Build.Upgrade
{

ClassMethod NewSource(old As %String, new As %String, performUpgrade As %Boolean, renameList As %DynamicObject = "", outputDirectory As %String = "") As %DynamicObject
{
}

/// Generates a report with mappings from SDA to an old schema, attempting to apply them to a new schema. Created for
/// upgrading SDA3->STU3 mappings to SDA3->R4. If <var>performUpgrade</var> is true, any mappings where the target is
/// unchanged, safely changed, or changed but needs review will be copied to the new schema's Map table. Otherwise, only
/// the report will be generated. If <var>outputDirectory</var> is specified, the report will be delivered to that directory
/// as upgrade.json
/// renameList is of the structure:
/// {
/// 	"ProcedureRequest": "ServiceRequest",
/// }
ClassMethod NewTarget(old As %String, new As %String, performUpgrade As %Boolean, renameList As %DynamicObject = "", outputDirectory As %String = "") As %DynamicObject
{
}

ClassMethod Map(oldSource As %String, newSource As %String, oldTarget As %String, newTarget As %String, mapping As %DynamicObject, lastOldVs As %String, lastNewVs As %String)
{
}

/// Populate the "SchemaMap_Map_SDA3."_new table with mappings that the report
/// deems safe to convert.
ClassMethod Upgrade(oldSource As %String, newSource As %String, oldTarget As %String, newTarget As %String, report As %DynamicObject) [ Internal ]
{
}

ClassMethod SafeDatatypeConversion(old As %String, new As %String, oldPath As %String, newPath As %String, Output note As %String) As %Boolean [ Internal ]
{
}

ClassMethod SafeCardinalityConversion(old As %String, new As %String, oldPath As %String, newPath As %String, Output note As %String) As %Boolean [ Internal ]
{
}

/// Returns 1 if every value in oldValue is also present in newValue.
/// Returns 2 when the strings have identical values. Returns 0 if 
/// a value in oldValue doesn't exist in newValue. Assumes the inputs are
/// both strings with " | " as the delimiter. 
ClassMethod IsSubset(oldValue As %String, newValue As %String) As %Boolean [ Internal ]
{
}

}
