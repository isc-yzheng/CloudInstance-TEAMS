Include SchemaMap

/// Recurses through the flat, static schema data tables to 
/// generate the path-by-path globals needed to drive schema analysis and mapping tools.
/// <p>
/// Use caution when calling macros other than $$$MapLog* macros in this class.
/// This class generates the ^SchemaMap.Paths global upon which most of the macros are based.
Class SchemaMap.Tool.Build.Generate Extends SchemaMap.Tool.Base.Generate [ Abstract ]
{

/// SDA3
ClassMethod GetListCodeTableDetail() As %Status
{
}

/// SDA3
/// Appends to the output value pAll which is a multidimensional list of classes and property names
/// of code table classes that have the potential to be interesting.
ClassMethod GetPropertiesOfCode(pClassName As %String, Output pAll) As %Status
{
}

/// SDA3
/// Re-initializes the output value pAll to empty and then uses it to list the properties of the input class name
ClassMethod GetPropertiesOfNonCode(pClassName As %String, Output pAll) As %Status
{
}

/// SDA3
ClassMethod GetListSDA3() As %Status
{
}

ClassMethod GetListFHIR3()
{
}

ClassMethod GetListFHIR4()
{
}

ClassMethod GetListFHIR(schema As %String)
{
}

/// Trak
ClassMethod GetListTrak() As %Status
{
}

ClassMethod GetPaths(schema As %String) As %Status
{
}

/// Input all 3 arguments from, to, and resource, or none of them. 
/// <p> 
/// If none, the ^SchemaMap.ReferenceField global is killed,
/// every mapping table in the project is examined, and the
/// entire ^SchemaMap.ReferenceField global is regenerated accurately for the project.
/// <p> 
/// If from and to are provided, and the input resource is a path that contains a colon, 
/// only the resource portion of the path is used as input to the method,
/// with the result that all current entries for the parent resource are regenerated.
ClassMethod GlobalReferenceField(package As %String(VALUELIST=",HC,ODS") = "HC", from As %String = "", to As %String = "", resource As %String = "") As %Status
{
}

ClassMethod GlobalReferenceFieldEntry(package As %String(VALUELIST=",HC,ODS") = "HC", from As %String = "", to As %String = "", fromPath As %String = "") As %Status
{
}

ClassMethod GetPathsFields(schema As %String, resource As %String) As %Status
{
}

ClassMethod GetPathsField(schema As %String, prePath As %String, preType As %String, preCard As %String, preDesc As %String) As %Status
{
}

/// For a resource,
/// get raw schema information from the schema table columns and store it in the ^SchemaMap.Paths global, indexed by schema and path.
ClassMethod SetPathsResourceInfo(schema As %String, resource As %String, type As %String, desc As %String = "") As %Status
{
}

/// For an element,
/// get raw schema information from the schema table columns and store it in the ^SchemaMap.Paths global, indexed by schema and path.
/// Calculate and store other useful schema information in the ^SchemaMap.Paths global, indexed by schema and path.
/// For calculating and storing data type information, see SetPathsTypeInfo.
ClassMethod SetPathsElementInfo(schema As %String, path As %String, type As %String, card As %String, desc As %String, isObject As %Boolean, isVariant As %Boolean = 0) As %Status
{
}

/// Calculate and store data type information in the ^SchemaMap.Paths global, indexed by schema and path.
ClassMethod SetPathsTypeInfo(schema As %String, path As %String, type As %String) As %Status
{
}

ClassMethod BuildListFHIRBaseFields(schema As %String) As %Status
{
}

ClassMethod BuildListFHIRQuantityTypes(schema As %String) As %Status
{
}

ClassMethod BuildListsForClassInfo(schema As %String) As %Status
{
}

}
