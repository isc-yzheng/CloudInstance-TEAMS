/// Deals with substitution of one medicine for another.
Class HS.FHIR.DTL.vDSTU2.Model.Element.MedicationDispense.substitution Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// Type of substitution.
/// <p>
/// any FHIR2 code may be used; 
/// v3-ActSubstanceAdminSubstitutionCode shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property type As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT") [ Required ];

/// CodeableConcept
/// <p>
/// Why was substitution made.
/// <p>
/// any FHIR2 code may be used; 
/// v3-SubstanceAdminSubstitutionReason shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property reason As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "reason", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Who is responsible for the substitution.
/// <p>
/// Practitioner
Property responsibleParty As list Of HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "responsibleParty", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "MedicationDispense.substitution";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "MedicationDispense.substitution";

}
