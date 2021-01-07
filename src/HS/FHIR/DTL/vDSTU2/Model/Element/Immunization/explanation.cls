/// Administration/non-administration reasons.
Class HS.FHIR.DTL.vDSTU2.Model.Element.Immunization.explanation Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// Why immunization occurred.
/// <p>
/// any FHIR2 code may be used; 
/// immunization-reason shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property reason As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "reason", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Why immunization did not occur.
/// <p>
/// any FHIR2 code may be used; 
/// no-immunization-reason shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property reasonNotGiven As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "reasonNotGiven", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Immunization.explanation";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Immunization.explanation";

}
