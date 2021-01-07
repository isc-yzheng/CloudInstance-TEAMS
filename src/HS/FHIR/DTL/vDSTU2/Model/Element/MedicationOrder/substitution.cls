/// Any restrictions on medication substitution.
Class HS.FHIR.DTL.vDSTU2.Model.Element.MedicationOrder.substitution Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// generic | formulary +
/// <p>
/// any FHIR2 code may be used; 
/// v3-ActSubstanceAdminSubstitutionCode shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property type As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT") [ Required ];

/// CodeableConcept
/// <p>
/// Why should (not) substitution be made.
/// <p>
/// any FHIR2 code may be used; 
/// v3-SubstanceAdminSubstitutionReason shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property reason As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "reason", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "MedicationOrder.substitution";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "MedicationOrder.substitution";

}
