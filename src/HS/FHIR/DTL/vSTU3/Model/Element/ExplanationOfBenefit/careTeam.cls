/// Care Team members.
Class HS.FHIR.DTL.vSTU3.Model.Element.ExplanationOfBenefit.careTeam Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// positiveInt
/// <p>
/// Number to covey order of careteam.
Property sequence As %Integer(XMLNAME = "sequence", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Reference
/// <p>
/// Member of the Care Team.
/// <p>
/// Practitioner | Organization
Property provider As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "provider", XMLPROJECTION = "ELEMENT") [ Required ];

/// boolean
/// <p>
/// Billing practitioner.
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

Parameter XMLNAME = "ExplanationOfBenefit.careTeam";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ExplanationOfBenefit.careTeam";

}
