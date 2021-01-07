/// Members of the care team.
Class HS.FHIR.DTL.vSTU3.Model.Element.Claim.careTeam Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// positiveInt
/// <p>
/// Number to covey order of careTeam.
Property sequence As %Integer(XMLNAME = "sequence", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Reference
/// <p>
/// Provider individual or organization.
/// <p>
/// Practitioner | Organization
Property provider As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "provider", XMLPROJECTION = "ELEMENT") [ Required ];

/// boolean
/// <p>
/// Billing provider.
Property responsible As %Boolean(XMLNAME = "responsible", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Role on the team.
/// <p>
/// any FHIR3 code may be used; 
/// claim-careteamrole shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property role As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "role", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Type, 
/// classification or Specialization.
/// <p>
/// any FHIR3 code may be used; 
/// provider-qualification shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property qualification As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "qualification", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Claim.careTeam";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Claim.careTeam";

}
