/// Any restrictions on medication substitution.
Class HS.FHIR.DTL.vSTU3.Model.Element.MedicationRequest.substitution Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// boolean
/// <p>
/// Whether substitution is allowed or not.
Property allowed As %Boolean(XMLNAME = "allowed", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// CodeableConcept
/// <p>
/// Why should (not) substitution be made.
/// <p>
/// any FHIR3 code may be used; 
/// v3-SubstanceAdminSubstitutionReason shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property reason As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "reason", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "MedicationRequest.substitution";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "MedicationRequest.substitution";

}
