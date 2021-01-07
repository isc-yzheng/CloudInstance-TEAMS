Include SchemaMap

/// This class will evolve, but was started based on the server side code in 
/// %MPRL.UI.NewWizard, %MPRL.Model.linkageDefinition, and %MPRL.UI.AuditLogDebug, 
/// and DTL classes in the package HS.FHIR.DTL.ToSDA.
Class SchemaMap.Tool.Model.Generate Extends SchemaMap.Tool.Base.Generate [ Abstract ]
{

ClassMethod CreateObject(schema As %String, path As %String, className As %String = "", superClassName As %String = "", stopProperty As %String = "", compile As %Boolean = 1) As %Status
{
}

ClassMethod CreateProperty(schema As %String, path As %String, type As %String, child As %String, childPath As %String, className As %String, superClassName As %String, stopProperty As %String, compile As %Boolean, ByRef sequenceNumber As %Integer) As %Status
{
}

/// Same as CreateProperty but streamlined for FHIR variant fields
ClassMethod CreatePropertyVariant(schema As %String, path As %String, child As %String, childPath As %String, variantType As %String, className As %String, ByRef sequenceNumber As %Integer) As %Status
{
}

ClassMethod CreatePropertyValueType(schema As %String, path As %String, ByRef property As %Dictionary.PropertyDefinition, ByRef unknownValueType As %Boolean) As %Status
{
}

/// Generate base classes in order before attempting to compile any of them;
/// then compile all the generated base classes.
ClassMethod GetModelBase(schema As %String) As %Status
{
}

ClassMethod GetDescriptionForClassDefinition(desc As %String) As %String
{
}

ClassMethod GetModel(schema As %String) As %Status
{
}

}
