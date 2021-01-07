/// Specification details such as Component Revisions, 
/// or Serial Numbers.
Class HS.FHIR.DTL.vSTU3.Model.Element.DeviceComponent.productionSpecification Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// Type or kind of production specification, 
/// for example serial number or software revision.
/// <p>
/// specification-type is the REQUIRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in specification-type, 
/// you may formally EXTEND specification-type to add codes to it.
Property specType As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "specType", XMLPROJECTION = "ELEMENT");

/// Identifier
/// <p>
/// Internal component unique identification.
Property componentId As HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "componentId", XMLPROJECTION = "ELEMENT");

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
