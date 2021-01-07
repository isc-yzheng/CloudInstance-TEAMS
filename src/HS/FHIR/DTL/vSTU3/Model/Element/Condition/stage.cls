/// Stage/grade, 
/// usually assessed formally.
Class HS.FHIR.DTL.vSTU3.Model.Element.Condition.stage Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// Simple summary (disease specific)
/// <p>
/// any FHIR3 code may be used; 
/// condition-stage shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property summary As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "summary", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Formal record of assessment.
/// <p>
/// ClinicalImpression | DiagnosticReport | Observation
Property assessment As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "assessment", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Condition.stage";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Condition.stage";

}
