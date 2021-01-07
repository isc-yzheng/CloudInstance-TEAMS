/// One or more sets of investigations (signs, 
/// symptions, 
/// etc.)
Class HS.FHIR.DTL.vDSTU2.Model.Element.ClinicalImpression.investigations Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// A name/code for the set.
/// <p>
/// any FHIR2 code may be used; 
/// investigation-sets shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property code As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "code", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Record of a specific investigation.
/// <p>
/// Observation | QuestionnaireResponse | FamilyMemberHistory | DiagnosticReport
Property item As list Of HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "item", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ClinicalImpression.investigations";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ClinicalImpression.investigations";

}
