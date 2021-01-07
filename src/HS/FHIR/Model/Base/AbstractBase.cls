/// Base class for server-side FHIR classes.<br><br>
/// *** <b>THIS CLASS IS DEPRECATED.</b> Please use HS.FHIR.<b>vDSTU2.</b>Model.Base.AbstractBase when working with FHIR DSTU2.
Class HS.FHIR.Model.Base.AbstractBase Extends (%RegisteredObject, HS.JSON.AdaptorFHIR, HS.XML.AdaptorFHIR, HS.FHIR.ReferenceUtils, %XML.Adaptor) [ Abstract, Deprecated ]
{

///  
Parameter JSONTYPEFIELD = "resourceType";

///  
ClassMethod %GetJSONType() As %String
{
	// use short name
	Quit ..%ClassName()
}

}
