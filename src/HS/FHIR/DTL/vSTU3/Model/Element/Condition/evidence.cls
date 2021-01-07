/// Supporting evidence.
Class HS.FHIR.DTL.vSTU3.Model.Element.Condition.evidence Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// Manifestation/symptom.
/// <p>
/// any FHIR3 code may be used; 
/// manifestation-or-symptom shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property code As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "code", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Supporting information found elsewhere.
/// <p>
/// Any FHIR3 Resource may be indicated by this Reference
Property detail As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "detail", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Condition.evidence";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Condition.evidence";

}
