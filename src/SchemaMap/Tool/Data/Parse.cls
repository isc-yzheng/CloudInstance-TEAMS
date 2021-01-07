Include SchemaMap

/// Provides utility methods for taking apart path strings and putting them back together.
/// Many of these methods were originally in SchemaMap.Data.Read, but all do more than simply read data.
/// <p>
/// Use caution when calling macros other than $$$MapLog* macros in this class.
/// Methods in this class are called from SchemaMap.Tool.Build.Generate 
/// to generate the ^SchemaMap.Paths global upon which most of the macros are based.
Class SchemaMap.Tool.Data.Parse [ Abstract ]
{

ClassMethod ReversePair(pair As %String) As %String
{
}

ClassMethod SetPairFrom(pair As %String, schema As %String) As %String
{
}

/// Input argument type is a full data type string (from a schema table DataType column) which may contain punctuation.
/// <p>
/// typeShortName is just the data type name without any modifiers that might appear after it in the type string.
/// <p>
/// simpleType is a returned string which tells us which simple type it is: 
/// "IsString" "IsInteger", "IsDecimal", "IsBoolean", "IsTime", "IsBinary".
/// <p>
/// If simpleType is non-empty, generalType is "IsPrimitive".
/// If simpleType is empty, generalType is one of these:
/// "IsCode", "IsReference", "IsBackbone", "IsVariantRoot", or "IsComplex" (the default if not any of the others). 
/// <p>
/// If this method is unable to determine generalType or typeShortName, it sets all of the output values to "".
/// The caller should check for this. There is no valid case where typeShortName or generalType is empty.
/// simpleType may be empty, as above, when no simple type applies.
/// <p>
/// codeStatus and valueSet apply only if the schema is a FHIR type and the generalType is "IsCode".
/// codeStatus indicates how flexible FHIR is about the value set:
/// "IsPreferred", "IsRequired", "IsExtensible", "IsExample";
/// valueSet is the name of the value set, or "*" for any value set.
/// <p>
/// if generalType is "IsReference" then valueSet is a list of the resources that Reference can point to.
/// <p>
/// if generalType is "IsVariantRoot" then valueSet is a list of the data types the field can have.
/// <p>
/// For accuracy, for any combination of schema, path, and type input to GetDataTypeInfoFromColumn,
/// SetPathsElementInfo or SetPathsElementInfo must first be called, immediately prior to calling GetDataTypeInfoFromColumn.
ClassMethod GetDataTypeInfoFromColumn(schema As %String, path As %String, type As %String, Output typeShortName As %String = "", Output simpleType As %String = "", Output generalType As %String = "", Output codeType = "", Output codeValue As %String = "", Output codeStatus = "", Output valueSet = "") As %Status
{
}

/// Input argument type is a data type string which may contain names of SDA3 classes that are data types.
ClassMethod GetSDA3DataTypeInfoFromColumn(schema As %String, type As %String, Output typeShortName As %String, Output simpleType As %String, Output generalType As %String, Output codeType As %String, Output codeStatus As %String, Output valueSet As %String) As %Status
{
}

/// FHIR3 FHIR2
ClassMethod GetFHIRDataTypeInfoFromColumn(schema As %String, path As %String, type As %String, Output typeShortName As %String, Output simpleType As %String, Output generalType As %String, Output codeType As %String, Output codeValue As %String, Output codeStatus As %String, Output valueSet As %String) As %Status
{
}

/// The type argument is a string found in a schema table DataType column.
/// <p>
/// This method parses the raw value in type to store various information in the ^SchemaMap.Paths global.
/// <p>
/// The multiple Output arguments serve various purposes for the caller:
/// codeValue is the part of the type string that contains either the value set name and symbols in parentheses;
/// valueSet is the value set for the code in codeValue (if there is one), without any parentheses or symbols;
/// codeValue may be (*) and valueSet may be * which indicates that any value set is fine.
/// <p>
/// For the FHIR data types code and Coding, this method seeks a Coding or CodeableConcept ancestor for the input path, to determine
/// which is really the correct value set limitation (if any), because the code or Coding object definition simply uses * (no specific value set)
ClassMethod GetFHIRCodeValue(schema As %String, path As %String, type As %String, Output codeValue As %String, Output codeStatus, Output valueSet) As %Status
{
}

/// If the schema is FHIR and the input path is a field within Coding or CodeableConcept,
/// record in the Paths global that the field is a subfield within a code object.
/// <p>
/// If the field is also type code or Coding, get the FHIR value set restriction from the parent (or grandparent) object,
/// Store the modified type in the DataType node of the Paths global and return it as the method value.
/// Also store the ancestor field Description in the Description node of the Paths global for the input path.
/// <p>
/// In all other cases, return the input argument type unchanged, and leave the Paths global unchanged.
ClassMethod GetTypeWithValueSetForCode(schema As %String = "", path As %String = "", type As %String = "") As %String
{
}

/// SDA3, Trak
/// Analyze 
/// <p>
/// The type argument is a string found in the schema table data type column.
/// This method parses the raw value in type, to return various information.
/// <p>
/// The type string is expected to possibly contain ObjectScript class parameters that constrain the type.
/// The input argument param identifies the class parameter we are looking for in the type string.
/// <p>
/// This method parses type to find param, and if found, returns the value of param to the caller in two forms:
/// text: a text value, and (when applicable) number: the same value as text, as a numeric value.
/// The caller should know which of these values it needs.
/// <p>
/// Currently the ObjectScript types this method handles are %String and %Numeric
/// and the ObjectScript class parameters for constraining data types that this method handles are
/// VALUELIST, DISPLAYLIST, MAXLEN, SCALE.
/// <p>
/// TO DO: Other types and parameters might be needed (but these cover a lot of the cases we need).
ClassMethod GetClassParameterIfAny(param As %String, type As %String, Output text As %String, Output number As %Integer) As %Status
{
}

/// Given a path that begins with a resource (and optionally also has a colon separator and field path separated by zero or more dots), 
/// find the longest parent path within this path (beginning at left) that matches a Path column entry in the schema table.
/// That is: the longest documented path that is a parent of this path.
/// <p>
/// The result might be the same as the input path, but could be a parent of the input path.
/// <p>
/// The resulting path might only consist of the resource (left of the colon).
/// <p>
/// Every documented path is a top path, but many top paths are not documented paths.
/// Top paths (in the ^SchemaMap.Paths global) are derived at import time, based on documented paths (in the schema table).
ClassMethod GetLongestDocumentedPath(schema As %String, path As %String) As %String
{
}

/// This method returns the next IMMEDIATE parent of the input path. It does not skip levels.
/// It does not check whether this parent is a documented path vs. a subpath. It just gets the parent.
/// <p>
/// Expects a full path including resource name, colon separator, and field path with dot separators, and possibly [n] in it.
/// <p>
/// If the input path string has no colon separator, return "" (indicating that we are already at the top resource).
/// <p>
/// Otherwise, parse the input path string to the right of the colon, to get the next level up in the path 
/// (working around the [n] convention for collection members). 
/// If the path to the right of the colon only had one node (has no dot separators), 
/// return the parent resource (left of the colon separator) without the colon (just the resource name).
ClassMethod ParseParentFromPath(path As %String) As %String
{
}

/// The input argument path is expected to be a full path, but it may be
/// resource or resource:element or resource:field.field.field or element or field.field.field -
/// The result is the rightmost "leaf" field in the path, 
/// or the resource if there is no : (colon) in the path.
ClassMethod ParseLeafFromPath(path As %String) As %String
{
}

ClassMethod PathStartsWith(path As %String, startsWith As %String, Output compareLength As %Integer) As %Boolean
{
}

ClassMethod ParseFieldFromPathStartsWith(path As %String, startsWith As %String) As %String
{
}

/// Given a path within a particular schema, append a child field to that path.
/// Check if the path is a list and if so insert that indicator "[n]" in the path.
/// Check if the path is a resource and if so use ":" as a connector instead of "."
/// <p>
/// Uses several $$$Map macros, which means it can invoke GetInfoPath. Also see ComposePathFromChildPaths.
ClassMethod ComposePathFromChild(schema As %String, path As %String, child As %String) As %String
{
}

/// This safer verison of ComposePathFromChild avoids use of $$$Map macros where that might induce circular calls to GetPathInfo. 
/// Instead it uses the ^SchemaMap.Paths global, or calls only those $$$Map macros that it trusts to simply parse paths as strings.
ClassMethod ComposePathFromChildPaths(schema As %String, path As %String, child As %String) As %String
{
}

/// variantRoot gives a documented FHIR path that is a variant root (ending in "*")
/// and typeName is one of the documented FHIR data types for this variant root.
/// This method returns the correct field name for this variant, according to FHIR naming conventions.
ClassMethod GetVariantFieldPath(schema As %String, variantRoot As %String, typeName As %String, caseQuantityName As %Boolean = 0) As %String
{
}

ClassMethod PathContainsSubFields(path As %String, field As %String, verbose As %Boolean = 0) As %Boolean
{
}

/// This method uses $$$MapIs macros as shortcuts, so is not accurate until after the Paths global has been generated by importing CSV files.
/// If needed before that, the method could be rewritten using logic that doesn't use the Paths global.
ClassMethod IsPathChildTypeCircular(schema As %String, path As %String, childType As %String) As %Boolean
{
}

ClassMethod GetNextChildFromRemainderPath(schema As %String = "", typePath As %String = "", ByRef childPath As %String = "", ByRef remainderPath As %String = "") As %Status
{
}

/// The method is used when forming <fromSchema>InfoPath column values for deeper paths.
/// Appends the leaf field to the input path. Applies cardinality appropriately to the resulting path.
/// If the input path is not a top path, this method will return an empty string without executing (will not be useful).
/// <p>
/// Note: since all input paths that are accepted for consideration are top paths, 
/// macros that call *Lookup* methods may be (and should be) avoided in this code.
/// Such macros call GetInfoPath, and so will cause <FRAMESTACK> errors when this method is used during BuildInfoPath.
ClassMethod FormPathFromParts(schema As %String, path As %String, leaf As %String) As %String
{
}

/// The method is used to get a sort order index value for FHIR inherited base fields,
/// which do not have rows in the schema table.
/// <p>
/// sortOrder is "spec" for FHIR spec order, or empty string for the default alphabetical.
/// <p>
/// When sortOrder = "spec" the UI sorts the list of fields in a resource 
/// using schema table row ID value for each field. When this is true
/// this method generates simulated schema table row ID values that place FHIR inherited base fields 
/// together at the bottom of each resource display table, after all the other fields.
/// <p>
/// For alphabetical order, the resulting index guarantees the same UI behavior,
/// but using a slightly different convention, to cause the indexes to sort at the end alphabetically.
ClassMethod GetFHIRSortOrderIndexValue(sortOrder As %String = "", resourceType As %String, field As %String) As %String
{
}

/// TO DO: For a class-based schema, when sorting display rows for resources that are subclasses of other resources 
/// (such as for HS.SDA3.CodeTableDetail.* under HS.SDA3.CodeTableDetail)
/// ensure that paths higher up in the package hierarchy appear near the top of the table.
/// Sorting alphabetically by path places these rows near the bottom of the table.
ClassMethod GetClassBasedIndexValue(schema As %String, path As %String) As %String
{
}

/// If there is a list indicator suffix [n] on the end of the input path, 
/// this method removes the suffix [n] and returns the path without the suffix.
/// Otherwise it simply returns the path, unchanged.
ClassMethod RemoveListSuffixIfAny(path As %String = "") As %String
{
}

/// Do not call this method directly; call SchemaMap.Tool.Data.Read:GetInfoPath
/// which will call this method if it needs to, after looking up a stored InfoPath fails.
/// <p>
/// A top path is a path that is directly documented in one of the FHIR schema definitions from HL7.org. 
/// It therefore appears in a schema CSV file and contains information in the ^SchemaMap.Paths global.
/// <p>
/// The InfoPath for a top path is itself. 
/// <p>
/// A deeper path, alternatively called a subpath, is a longer, but still valid path in a FHIR schema.
/// It is not directly documented in the schema definition or in the schema CSV file
/// because that would be redundant, when the FHIR schema definition hierarchy can be navigated
/// from parent to child easily, by clicking online links on HL7.org or in the SchemaMap UI.
/// <p>
/// The InfoPath for a deeper path is some top path within its own schema.
/// <p>
/// If this method cannot determine an InfoPath, it returns an empty string.
/// <p>
/// This method walks up and down path segments, pivoting on path types
/// and BackboneElement types when needed. In the process, when reforming paths, it consults
/// the schema definition, for example regarding cardinality (should there be a [n] in the path).
/// <p>
/// This method detects if its path walking has become circular, by detecting when its
/// processing has produced an exact repeat of the original path that was input to it,
/// without also finding a solution for that path. 
/// <p> 
/// Since it is not possible to anticipate and evade all possible
/// variations on malformed input paths as the value of the original argument,
/// this method also counts its cycles. It stops if it reaches a limit (currently 1000 cycles).
/// In this case it outputs a LOGIC message to ^SchemaMap.Log.
ClassMethod BuildInfoPath(schema As %String = "", original As %String = "") As %String
{
}

ClassMethod PivotTop(schema As %String = "", ByRef tryPath As %String = "", ByRef tryType As %String = "", ByRef remainder As %String = "", ByRef found As %Boolean = 0) As %Status
{
}

ClassMethod StripExcessChildRepeats(schema As %String = "", ByRef tryPath As %String = "", ByRef tryType As %String = "", ByRef remainder As %String = "") As %Status
{
}

ClassMethod PathUp(ByRef path As %String, ByRef remainder As %String) As %Status
{
}

ClassMethod PathDown(schema As %String, ByRef path As %String, ByRef remainder As %String) As %Status
{
}

ClassMethod PivotType(schema As %String, path As %String, ByRef type As %String, ByRef remainder As %String) As %Status
{
}

/// Compare the current path of primary interest to the UI
/// (such as the resource or FHIR BackboneElement whose mapping table we are viewing)
/// with a subpath that we have encountered in the data
/// (a longer path which starts from this path).
/// <p> 
/// schema is the "from" schema for the current view. It must be FHIR.
/// If the subpath is too long (more than 1 level below the current level) 
/// we wish to exclude it from display. In this case we return true.
/// <p>
/// Note: the UI offers the grid icon where needed to navigate down levels in the table.
ClassMethod SkipFHIRDeepSubpath(schema As %String = "", path As %String = "", subpath As %String = "") As %Boolean
{
}

/// This method assists a preview of MapIssues for a potential row in a mapping table.
/// <p>
/// The method creates a %ZEN.proxyObject that has the same properties as 
/// the %SQL.StatementResult that would be returned from the 
/// SchemaMap.Tool.SQL.Read:Map method, if such a row existed in the mapping table. 
/// <p>
/// The caller can send this %ZEN.proxyObject into SchemaMap.Tool.Validate.Datatype:GetInfo 
/// to find out what the resulting MapIssues would be, if the row existed.
/// This is handy for SchemaMap.Tool.UI.Edit and for other cases in SchemaMap.Tool.
/// It is also used in each mapping table %OnBeforeSave method, to calculate a MapIssues value.
/// <p>
/// %DynamicObject doesn't let code access properties on both objects the same way, so did not use it.
/// <p>
/// Only those properties of the SchemaMap.Tool.SQL.Read:Map %SQL.StatementResult that are 
/// actually useful as inputs to GetInfo are supported as input values to this method. 
/// These are properties that have some effect on calculating the MapIssues value for a row:
/// SourcePath, SourceValue, SourceTransform, TargetPath, TargetTransform
/// AutoMapped, SubTransform, ClassMethod, DefaultValue, Extension, DependsOn,
/// MapNotes, Append, ExcludeList, Active
/// <p>
/// Note that whenever the result properties from the Map method change, developers need to see if
/// FormMapResultObjectFromValues needs to be updated, or calls to GetInfo (that depend on it) could break.
ClassMethod FormMapResultObjectFromValues(Output result As %ZEN.proxyObject, fromPath As %String = "", sourceValue As %String = "", sourceXF As %String = "", toPath As %String = "", toXF As %String = "", autoMapped As %Boolean = 0, classMethod As %String = "", subTransform As %String = "", defaultValue As %String = "", extension As %String = "", dependsOn As %String = "", notes As %String = "", append As %Boolean = 0, exclude As %String = "", active As %Boolean = 1) As %Status
{
}

/// Piece together the parts of a DTL class name based on the input arguments, and return the name.
ClassMethod GetDTLClassname(package As %String, from As %String, to As %String, source As %String, target As %String) As %String
{
}

/// The returned schema names will be in delivery form, as if returned from $$$MapGenSchemaPackage(schema), that is "vSTU3".
/// To use them for typical SchemaMap.Tool calls, that is "FHIR3", first convert them using $$$MapGenSchemaMapper(schema).
ClassMethod GetLookupNamesFromClassMethodValue(toUtil As %String = "", Output sourceLookupName As %String = "", Output targetLookupName As %String = "", Output sourceSchemaName As %String = "", Output targetSchemaName As %String = "") As %Status
{
}

}
