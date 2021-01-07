/// Base class for server-side FHIR classes.
Class HS.FHIR.vSTU3.Model.Base.AbstractBase Extends (%RegisteredObject, HS.JSON.AdaptorFHIR, HS.XML.AdaptorFHIR, HS.FHIR.ReferenceUtils, %XML.Adaptor) [ Abstract, Inheritance = right, ProcedureBlock ]
{

/// Type property name for JSON export.
Parameter JSONTYPEFIELD = "resourceType";

/// Return the value to be used within the JSONTYPEFIELD.
ClassMethod %GetJSONType() As %String
{
	// use short name
	Quit ..%ClassName()
}

}
