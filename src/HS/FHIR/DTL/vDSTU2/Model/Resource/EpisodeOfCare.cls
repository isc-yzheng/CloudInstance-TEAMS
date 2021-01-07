/// An association of a Patient with an Organization and  Healthcare Provider(s) for a period of time that the Organization assumes some level of responsibility.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.EpisodeOfCare Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Identifier(s) for the EpisodeOfCare.
Property identifier As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// planned | waitlist | active | onhold | finished | cancelled
/// <p>
/// episode-of-care-status is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend episode-of-care-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// BackboneElement
/// <p>
/// Past list of status codes.
Property statusHistory As list Of HS.FHIR.DTL.vDSTU2.Model.Element.EpisodeOfCare.statusHistory(XMLNAME = "statusHistory", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Type/class  - e.g. 
/// specialist referral, 
/// disease management.
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property type As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Conditions/problems/diagnoses this episode of care is for.
/// <p>
/// Condition
Property condition As list Of HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "condition", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Patient for this episode of care.
/// <p>
/// Patient
Property patient As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "patient", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Organization that assumes care.
/// <p>
/// Organization
Property managingOrganization As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "managingOrganization", XMLPROJECTION = "ELEMENT");

/// Period
/// <p>
/// Interval during responsibility is assumed.
Property period As HS.FHIR.DTL.vDSTU2.Model.Datatype.Period(XMLNAME = "period", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Originating Referral Request(s)
/// <p>
/// ReferralRequest
Property referralRequest As list Of HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "referralRequest", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Care manager/care co-ordinator for the patient.
/// <p>
/// Practitioner
Property careManager As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "careManager", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Other practitioners facilitating this episode of care.
Property careTeam As list Of HS.FHIR.DTL.vDSTU2.Model.Element.EpisodeOfCare.careTeam(XMLNAME = "careTeam", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "EpisodeOfCare";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "EpisodeOfCare";

}
