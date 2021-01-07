/// Production specification of the component.
Class HS.FHIR.DTL.vDSTU2.Model.Element.DeviceComponent.productionSpecification Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// Specification type.
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property specType As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "specType", XMLPROJECTION = "ELEMENT");

/// Identifier
/// <p>
/// Internal component unique identification.
Property componentId As HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "componentId", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// A printable string defining the component.
Property productionSpec As %String(MAXLEN = 1000000, XMLNAME = "productionSpec", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "DeviceComponent.productionSpecification";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "DeviceComponent.productionSpecification";

}
