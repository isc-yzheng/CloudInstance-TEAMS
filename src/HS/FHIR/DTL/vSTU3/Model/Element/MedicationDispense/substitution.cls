/// Whether a substitution was performed on the dispense.
Class HS.FHIR.DTL.vSTU3.Model.Element.MedicationDispense.substitution Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// boolean
/// <p>
/// Whether a substitution was or was not performed on the dispense.
Property wasSubstituted As %Boolean(XMLNAME = "wasSubstituted", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// CodeableConcept
/// <p>
/// Code signifying whether a different drug was dispensed from what was prescribed.
/// <p>
/// any FHIR3 code may be used; 
/// v3-ActSubstanceAdminSubstitutionCode shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property type As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Why was substitution made.
/// <p>
/// any FHIR3 code may be used; 
/// v3-SubstanceAdminSubstitutionReason shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property reason As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "reason", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Who is responsible for the substitution.
/// <p>
/// Practitioner
Property responsibleParty As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "responsibleParty", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "MedicationDispense.substitution";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "MedicationDispense.substitution";

}
