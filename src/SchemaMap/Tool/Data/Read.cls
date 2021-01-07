Include SchemaMap

/// This class provides utility methods for getting useful information out of the 
/// schema and mapping data tables and the generated path-by-path globals: 
/// This class supports the "read" in CRUD, as long as it does not directly involve SQL.
/// For the direct SQL API for this code, see the SchemaMap.SQL package.
/// <p>
/// Use caution when calling macros other than $$$MapLog* macros in this class.
/// Methods in this class are called from SchemaMap.Tool.Build.Generate 
/// to generate the ^SchemaMap.Paths global upon which most of the macros are based.
Class SchemaMap.Tool.Data.Read [ Abstract ]
{

/// text is any string, listData is any list (multidimensional variable).
/// This method tests whether text is equal to any member in the list.
ClassMethod InList(text As %String, listData) As %Boolean
{
}

ClassMethod IsAlphaNumeric(char As %String) As %Boolean
{
}

ClassMethod IsAlpha(char As %String) As %Boolean
{
}

ClassMethod IsLowercase(char As %String) As %Boolean
{
}

ClassMethod IsUppercase(char As %String) As %Boolean
{
}

/// This method expects one character as input
ClassMethod IsNumeric(char As %String) As %Boolean
{
}

/// This method expects a string of one or more characters as input
ClassMethod IsValueNumeric(value As %String) As %Boolean
{
}

ClassMethod IsValidPair(pair As %String) As %Boolean
{
}

ClassMethod IsValidFromTo(from As %String, to As %String) As %Boolean
{
}

ClassMethod InPair(pair As %String, schema As %String) As %Boolean
{
}

/// Determines whether or not there is any saved column data in a mapping table row.
/// For example, the row could exist but currently have no useful data in its columns.
ClassMethod IsMapped(from As %String, to As %String, row As %String = "") As %Boolean
{
}

/// Determines whether or not there is any row in the from.to mapping table that is populated from this path.
/// If the row has Active=1 or is excluded from delivery via the ExcludeList value, the return value is 0 (false).
/// Otherwise, a search is done from mapping table entries with this path as the SourcePath.
/// The search is %STARTSWITH in case the mapping populates children of a source path (which would mean true).
/// The targetPath and mapIssues values are output if the return value is 1 (true), to serve further reporting needs.
/// Each output argument is returned as a $listbuild in case there are multiple mappings from this SourcePath.
/// Note that in theory, the TargetPath and/or MapIssues column values may be empty strings while the return value is 1 (true).
ClassMethod IsMappedFrom(from As %String = "", to As %String = "", path As %String = "", package As %String = "HC", Output targetPath = "", Output mapIssues = "") As %Boolean
{
}

/// Determines whether or not there is any row in the from.to mapping table that populates this path.
/// If the row has Active=1 or is excluded from delivery via the ExcludeList value, the return value is 0 (false).
/// Otherwise, a search is done from mapping table entries with this path as the TargetPath.
/// The search is %STARTSWITH in case the mapping is to children of a target path (which would mean true).
/// The sourcePath and mapIssues values are output if the return value is 1 (true), to serve further reporting needs.
/// Each output argument is returned as a $listbuild in case there are multiple mappings to this TargetPath.
/// There is no output argument for sourceValue, as there is no reporting need that it serves, for now.
/// Note that in theory, the SourcePath and/or MapIssues column values may be empty strings while the return value is 1 (true).
ClassMethod IsMappedTo(from As %String = "", to As %String = "", path As %String = "", package As %String = "HC", Output sourcePath, Output mapIssues) As %Boolean
{
}

ClassMethod GetMappingsForLookupEntry(from As %String = "", to As %String = "", sourceTable As %String = "", targetTable As %String = "", Output sourcePath, Output targetPath, Output excludeList) As %Status
{
}

ClassMethod IsClinical(schema As %String = "", path As %String = "") As %Boolean
{
}

/// If the input mapping (fromPath and toPath and dependsOn) has a FHIR extension as the toPath,
/// see if there exists another mapping with the same fromPath and dependsOn, but with a different toPath.
/// If so, examine the data type of that other toPath and see if it is the general type we are interested in, based on the otherTarget flag.
/// otherFlag has a VALUELIST to indicate what kinds of general types we can examine in the other toPath: Numeric, Single, etc.
/// If there are several such mappings, keep trying until either the finding is true or we run out of mappings that match.
ClassMethod IsFHIRExtensionPairedWithOtherTarget(from As %String = "", fromPath As %String = "", to As %String = "", toPath As %String = "", dependsOn As %String = "", exclude As %String = "", otherTarget As %String(VALUELIST=",Numeric,Single") = "") As %Boolean
{
}

/// If the input mapping (fromPath and toPath) has a non-empty sourceValue (a literal value is mapped to the target field),
/// see if there exists another mapping for this resource with the same toPath that is a field-to-field mapping. 
/// If there is any such mapping, return true.
ClassMethod IsSourceValuePairedWithFieldMapping(from As %String = "", fromPath As %String = "", to As %String = "", toPath As %String = "", sourceValue As %String = "") As %Boolean
{
}

/// If the mapping is FHIR (any version) to SDA3,
/// and the input mapping (fromPath and toPath) has a DependsOn condition that does a code lookup
/// that is the same as the code lookup being done by the ClassMethod value of some other mapping in the same table,
/// and the lookup for both mappings is being done on the same lookup table entry,
/// and the SourcePath (fromPath) and TargetPath (toPath) are the same in both mappings, then
/// they are a related pair of mappings for the purpose of handling code lookups. 
/// In that case, return true. Otherwise return false.
/// <p>
/// MAINTENANCE NOTE: if some DependsOn values for this resource and its mappings
/// involve more than just a call to a code lookup method,
/// and there are multiple DependsOn values in the same resource 
/// that are also doing lookups on the same lookup table entry for
/// the same SourcePath and TargetPath combination, 
/// then this method could return false positives,
/// because it is not intended as a full-out condition parser.
/// This limitation does not impact anything (at this time), because
/// The tool is using this method to determine that the mapping 
/// is paired with SOME other mapping for the same resource,
/// not to determine exactly WHICH other mapping it happens to be paired with.
ClassMethod IsCodeMapPairedWithCodeLookup(from As %String = "", fromPath As %String = "", to As %String = "", toPath As %String = "", dependsOn As %String = "") As %Boolean
{
}

/// Typically this method is called when we already know the FHIR path is required, to get more information.
/// However, to make the method more robust, it first verifies that the schema is FHIR and the path is required.
/// Then it checks to see if we are in the special case we wish to check for. It returns true only if:
/// schema is FHIR, the input path is required, its parent is BackboneElement, and the parent is optional.
ClassMethod IsFHIRRequiredWithParentOptional(schema As %String = "", path As %String = "") As %Boolean
{
}

/// This method first verifies that the schema is FHIR and the path is a single value and a Reference.
/// Then it checks to see if we are in the special case we wish to check for. It returns true only if:
/// schema is FHIR, the input path is a single value that is a Reference, its parent is BackboneElement, and the parent is a list.
ClassMethod IsFHIRSingleReferenceWithParentList(schema As %String = "", path As %String = "") As %Boolean
{
}

ClassMethod IsDeFactoRequired(schema As %String = "", path As %String = "") As %Boolean
{
}

/// GetFieldChildren is called any time the caller needs a list of the direct child fields of the path.
/// Note this method does not recurse down levels; it returns only direct child fields of the input path.
/// Omit order, or set it to an empty string, to get the list of fields in alphabetical order.
/// Set order to "spec" to get the results in the same order as in the schema CSV file (for FHIR, this is FHIR spec order).
ClassMethod GetFieldChildren(schema As %String, path As %String, type As %String, order As %String = "", Output fieldList) As %Status
{
}

/// This method returns caseQuantityName to flag a special case for field naming for this variant, according to FHIR naming conventions.
/// The caller first retrieves this flag while calling GetFHIRVariantTypes() to get the list of all types,
/// then uses it as an input to calls to GetVariantFieldPath() to retrieve the individual field names, type by type.
ClassMethod GetFHIRVariantTypes(schema As %String, path As %String, Output typeList, Output caseQuantityName As %Boolean = 0) As %Status
{
}

/// source is a resource name or a path in the source schema.
/// <p>
/// When the type is "target",
/// this method gets a list of the TargetTransform values that the source resource has mappings to 
/// in the schema pair from:to. The method returns this list of names in targets. 
/// <p>
/// The value assigned to each entry in the targets list is the 
/// count of field-to-field mappings from this source whose TargetTransform value is this name.
/// <p>
/// The output argument defaultTarget is the name in targets with the highest count.
/// If there are no mappings for this source resource, defaultTarget is an empty string.
/// <p>
/// When the type is "source", 
/// everything is much the same, except that the results returned in targets and defaultTargets
/// are based on SourceTransform values and are correct to use for SourceTransform choices.
/// <p>
/// See SchemaMap.DTL.Generate:GenerateTransforms.
ClassMethod GetAncestorTransformList(from As %String, to As %String, source As %String, Output targets, Output defaultTarget As %String, type As %String(VALUELIST=",target,source") = "") As %Status
{
}

/// When the type is "target", 
/// This method derives the default TargetTransformation for a source resource,
/// based on existing saved mapping targets for the same source resource.
/// <p>
/// It looks for the most common TargetTransformation among saved mapping targets for this source resource.
/// If no such entries are found, or if the most common TargetTransform is in some way an invalid choice
/// for the input target path supplied, the returned value defaults to the resource within the target path.
/// <p>
/// If there are no mappings for the source resource and the input target value is empty, 
/// an empty string is returned.
/// <p>
/// When the type is "source", 
/// everything is much the same, except that the result returned
/// is based on SourceTransform values and are correct to use for SourceTransform choices.
ClassMethod GetAncestorTransformDefault(from As %String, to As %String, source As %String = "", target As %String = "", type As %String(VALUELIST=",target,source") = "") As %String
{
}

ClassMethod ValidateAncestorTransform(to As %String, toPath As %String = "", toXF As %String = "", type As %String(VALUELIST=",target,source") = "") As %String
{
}

ClassMethod GetDisplayOrder(pair As %String) As %String
{
}

ClassMethod GetClassImportant(schema As %String, Output listClass) As %Status
{
}

ClassMethod IsClassImportant(schema As %String, path As %String) As %Boolean
{
}

ClassMethod IsClassDataType(schema As %String, path As %String) As %Boolean
{
}

ClassMethod IsClassPrimitive(schema As %String, path As %String) As %Boolean
{
}

ClassMethod IsSDA3Important(path) As %Boolean
{
}

ClassMethod GetSDA3Important(Output listSDA3) As %Status
{
}

ClassMethod IsSDA3Resource(path) As %Boolean
{
}

/// includes data type classes only
ClassMethod IsSDA3DataType(path) As %Boolean
{
}

ClassMethod IsSDA3Primitive(path) As %Boolean
{
}

ClassMethod IsSDA3Code(path) As %Boolean
{
}

ClassMethod IsSDA3CodeSimple(path) As %Boolean
{
}

ClassMethod IsSDA3CodeTranslated(path) As %Boolean
{
}

ClassMethod IsSDA3CodeInteresting(path) As %Boolean
{
}

ClassMethod IsFHIR(schema, path) As %Boolean
{
}

ClassMethod IsFHIRCode(schema, path) As %Boolean
{
}

ClassMethod IsFHIRResource(schema, path) As %Boolean
{
}

/// includes both complex and primitive data types
ClassMethod IsFHIRDataType(schema, path) As %Boolean
{
}

ClassMethod IsFHIRMetadata(schema, path) As %Boolean
{
}

/// e.g. Dosage or ElementDefinition - it is an Element, but not a BackboneElement, not a resource, not metadata, and not a data type
ClassMethod IsFHIRStructure(schema, path) As %Boolean
{
}

ClassMethod IsFHIRBase(schema, path) As %Boolean
{
}

ClassMethod IsFHIRPrimitive(schema, path) As %Boolean
{
}

ClassMethod IsFHIRFieldInCodeObject(schema As %String = "", path As %String = "", Output codeAncestorPath As %String = "", Output codeAncestorType As %String = "", Output pathCoding As %String = "", Output pathCodeableConcept As %String = "") As %Boolean
{
}

ClassMethod IsTrakImportant(path) As %Boolean
{
}

ClassMethod GetTrakImportant(Output listTrak) As %Status
{
}

ClassMethod IsTrakResource(path) As %Boolean
{
}

/// includes data type classes only
ClassMethod IsTrakDataType(path) As %Boolean
{
}

ClassMethod IsTrakPrimitive(path) As %Boolean
{
}

ClassMethod IsDocumentedPath(schema As %String, path As %String) As %Boolean
{
}

ClassMethod FHIRBaseFieldList(schema As %String, baseFieldList) As %Status
{
}

ClassMethod IsFHIRInheritedBasePath(schema As %String, path As %String) As %Boolean
{
}

/// Accepts either a full path or a field in the input argument called path.
/// This method needs to be able to be called before the ^SchemaMap.Lists global is populated.
ClassMethod IsSDA3InheritedBasePath(schema As %String, path As %String) As %Boolean
{
}

ClassMethod GetPathsFieldsResultSet(schema As %String, resource As %String, Output result As %SQL.StatementResult, Output isBackbone As %Boolean) As %Status
{
}

/// Omit order, or set it to an empty string, to get the list of fields in alphabetical order.
/// Set order to "spec" to get the results in the same order as in the schema CSV file (for FHIR, this is FHIR spec order).
ClassMethod GetPathsFieldResultSet(schema As %String, path As %String, type As %String, order As %String = "", Output result As %SQL.StatementResult, Output isBackbone As %Boolean) As %Status
{
}

/// DISTINCT in the query would affect capitalization, so de-duplicate results in the calling method.
ClassMethod GetFHIRBaseFieldsResultSet(schema As %String, Output result As %SQL.StatementResult) As %Status
{
}

ClassMethod IsPairInProject(pair As %String = "") As %Boolean
{
}

ClassMethod IsSchemaInProject(schema As %String = "") As %Boolean
{
}

ClassMethod IsReportTypeInProject(schema As %String = "", reportType As %String(VALUELIST=",Clinical,Non-clinical") = "") As %Boolean
{
}

ClassMethod IsResourceInProject(schema As %String = "", resource As %String = "") As %Boolean
{
}

ClassMethod IsResourceMostImportant(schema As %String = "", resource As %String = "") As %Boolean
{
}

ClassMethod IsResourceStrategic(schema As %String = "", resource As %String = "") As %Boolean
{
}

ClassMethod GetUnhandledIssues(mapIssues As %String) As %String
{
}

ClassMethod GetAutoHandledIssues(mapIssues As %String) As %String
{
}

ClassMethod GetMapFlagRoot(flag As %String) As %String
{
}

ClassMethod GetMapIssuesHasRequired(issues As %String) As %Boolean
{
}

/// When you have a schema and an original path (of arbitrary length, either top path or deeper path)  
/// and you need an InfoPath value (a top path that accurately represents this path 
/// and can be used to lookup information about this path in the ^SchemaMap.Paths global),
/// call this method to either retrieve the InfoPath value, or call out to 
/// SchemaMap.Tool.Data.Parse:BuildInfoPath to derive it.
ClassMethod GetInfoPath(schema As %String, path As %String = "") As %String
{
}

ClassMethod LookupInfoPathBoolean(schema As %String, path As %String, node As %String, default As %Boolean = 0) As %Boolean
{
}

ClassMethod LookupInfoPathString(schema As %String, path As %String, node As %String, default As %String = "") As %String
{
}

}
