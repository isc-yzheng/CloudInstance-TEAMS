/// An association between a patient and an organization / healthcare provider(s) during which time encounters may occur. 
/// The managing organization assumes a level of responsibility for the patient during this time.
Class HS.FHIR.DTL.vSTU3.Model.Resource.EpisodeOfCare Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Business Identifier(s) relevant for this EpisodeOfCare.
Property identifier As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// planned | waitlist | active | onhold | finished | cancelled | entered-in-error
/// <p>
/// episode-of-care-status is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend episode-of-care-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// BackboneElement
/// <p>
/// Past list of status codes (the current status may be included to cover the start date of the status)
Property statusHistory As list Of HS.FHIR.DTL.vSTU3.Model.Element.EpisodeOfCare.statusHistory(XMLNAME = "statusHistory", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Type/class  - e.g. 
/// specialist referral, 
/// disease management.
/// <p>
/// any FHIR3 code may be used; 
/// episodeofcare-type shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property type As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// The list of diagnosis relevant to this episode of care.
Property diagnosis As list Of HS.FHIR.DTL.vSTU3.Model.Element.EpisodeOfCare.diagnosis(XMLNAME = "diagnosis", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// The patient who is the focus of this episode of care.
/// <p>
/// Patient
Property patient As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "patient", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Organization that assumes care.
/// <p>
/// Organization
Property managingOrganization As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "managingOrganization", XMLPROJECTION = "ELEMENT");

/// Period
/// <p>
/// Interval during responsibility is assumed.
Property period As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "period", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Originating Referral Request(s)
/// <p>
/// ReferralRequest
Property referralRequest As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "referralRequest", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Care manager/care co-ordinator for the patient.
/// <p>
/// Practitioner
Property careManager As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "careManager", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Other practitioners facilitating this episode of care.
/// <p>
/// CareTeam
Property team As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "team", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// The set of accounts that may be used for billing for this EpisodeOfCare.
/// <p>
/// Account
Property account As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "account", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "EpisodeOfCare";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "EpisodeOfCare";

}
