/// Who's involved in plan?
Class HS.FHIR.DTL.vDSTU2.Model.Element.CarePlan.participant Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// Type of involvement.
/// <p>
/// any FHIR2 code may be used; 
/// participant-role shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property role As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "role", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Who is involved.
/// <p>
/// Practitioner | RelatedPerson | Patient | Organization
Property member As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "member", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "CarePlan.participant";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "CarePlan.participant";

}
