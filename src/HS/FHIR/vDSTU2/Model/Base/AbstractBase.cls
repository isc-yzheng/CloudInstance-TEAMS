/// Base class for server-side FHIR classes.
Class HS.FHIR.vDSTU2.Model.Base.AbstractBase Extends (%RegisteredObject, HS.JSON.AdaptorFHIR, HS.XML.AdaptorFHIR, HS.FHIR.ReferenceUtils, %XML.Adaptor) [ Abstract ]
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
