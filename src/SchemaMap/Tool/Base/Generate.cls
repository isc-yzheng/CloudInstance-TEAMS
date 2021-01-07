Include SchemaMap

/// This class will evolve, but was started based on the server side code in 
/// %MPRL.UI.NewWizard, %MPRL.Model.linkageDefinition, and %MPRL.UI.AuditLogDebug, 
/// and DTL classes in the package HS.FHIR.DTL.ToSDA.
Class SchemaMap.Tool.Base.Generate [ Abstract ]
{

/// Test if the given class name is valid.
ClassMethod IsClassNameValid(pName As %String) As %Boolean
{
}

/// Delete a class. 
ClassMethod DeleteClass(className As %String) As %Status
{
}

/// If there is a class to be created, get the information required to create it.
/// Tells us which class name to use for the schema and path provided. 
/// Detects any complex data type relationships and reports them in the output argument complexTypeCase.
/// The value of complexTypeCase is an integer defined in SchemaMap.inc such as $$$MapTypeIsChildAncestor.
/// <p>
/// Often, ancestor and parent are left blank. 
/// That is expected. When ancestor and parent are not provided, we make a decision solely based on the path.
/// <p>
/// In some calls to this method from CreateObject, non-empty values are provided for ancestor and/or parent.
/// When this is so, it means CreateObject is inputting the childType (path) corresponding to 
/// a childPath (parent) and path (ancestor) in a 3-level relationship.
/// Such relationships can produce circular or infinitely nested property definitions and subclassing relationships.
/// The cases that cause this are known, and this method detects them. To detect these cases accurately, 
/// this code examines the CreateObject childType (path) in relation to the childPath (parent) and path (ancestor).
/// <p>
/// Sometimes, this examination of relationships looks at the childType (path)'s data type,
/// and the data type of that data type, a 4th and 5th level in the set of relationships.
/// The result of this analysis becomes a flag returned in the output argument complexTypeCase. 
ClassMethod PathToClassNameForModel(schema As %String, ancestor As %String = "", parent As %String = "", path As %String, Output className As %String, Output superClassName As %String, Output complexTypeCase As %Integer, Output stopProperty As %String, Output nestRelationship) As %String
{
}

ClassMethod GetPropertyValueType(schema As %String, path As %String, Output primitiveClassname As %String, Output unknownValueType As %Boolean) As %Status
{
}

/// FHIR string length is limited to 1MB.
ClassMethod AddTypeString(ByRef property As %Dictionary.PropertyDefinition) As %Status
{
}

/// Add this property to the *.Base.Resource classes for FHIR schemas
ClassMethod AddTypeNewResource(schema As %String, path As %String, className As %String) As %Status
{
}

/// Add this property to the *.Base.Resource classes for FHIR schemas
ClassMethod AddTypeNewResourceReference(schema As %String, path As %String, className As %String) As %Status
{
}

/// Add this property to the *.Base.Element and *.Base.Resource classes for FHIR schemas
ClassMethod AddTypePrimitiveExtension(schema As %String, path As %String, className As %String) As %Status
{
}

/// Add this property to the *.Base.Resource classes for FHIR schemas
ClassMethod AddTypeResourceType(schema As %String, path As %String, className As %String) As %Status
{
}

/// Add the necessary XML parameters to a FHIR data model class definition
ClassMethod AddClassParametersXML(schema As %String, path As %String, className As %String, superClassName As %String) As %Status
{
}

}
