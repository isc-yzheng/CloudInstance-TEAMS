/// Used to record and send details about a request for referral service or transfer of a patient to the care of another provider or provider organization.
Class HS.FHIR.DTL.vSTU3.Model.Resource.ReferralRequest Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Business identifier.
Property identifier As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Instantiates protocol or definition.
/// <p>
/// ActivityDefinition | PlanDefinition
Property definition As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "definition", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Request fulfilled by this request.
/// <p>
/// ReferralRequest | CarePlan | ProcedureRequest
Property basedOn As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "basedOn", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Request(s) replaced by this request.
/// <p>
/// ReferralRequest
Property replaces As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "replaces", XMLPROJECTION = "ELEMENT");

/// Identifier
/// <p>
/// Composite request this is part of.
Property groupIdentifier As HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "groupIdentifier", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// draft | active | suspended | cancelled | completed | entered-in-error | unknown
/// <p>
/// request-status is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend request-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// code
/// <p>
/// Distinguishes the "level" of authorization/demand implicit in this request.
/// <p>
/// request-intent is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend request-intent and you may NOT use codes from other ValueSets.
Property intent As %String(MAXLEN = 1000000, XMLNAME = "intent", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// CodeableConcept
/// <p>
/// Referral/Transition of care request type.
/// <p>
/// any FHIR3 code may be used; 
/// referral-type shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property type As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// Urgency of referral / transfer of care request.
/// <p>
/// request-priority is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend request-priority and you may NOT use codes from other ValueSets.
Property priority As %String(MAXLEN = 1000000, XMLNAME = "priority", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Actions requested as part of the referral.
/// <p>
/// any FHIR3 code may be used; 
/// c80-practice-codes shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property serviceRequested As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "serviceRequested", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Patient referred to care or transfer.
/// <p>
/// Patient | Group
Property subject As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "subject", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Originating encounter.
/// <p>
/// Encounter | EpisodeOfCare
Property context As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "context", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// When the service(s) requested in the referral should occur.
Property occurrenceDateTime As %String(MAXLEN = 1000000, XMLNAME = "occurrenceDateTime", XMLPROJECTION = "ATTRIBUTE");

/// Period
/// <p>
/// When the service(s) requested in the referral should occur.
Property occurrencePeriod As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "occurrencePeriod", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// Date of creation/activation.
Property authoredOn As %String(MAXLEN = 1000000, XMLNAME = "authoredOn", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Who/what is requesting service.
Property requester As HS.FHIR.DTL.vSTU3.Model.Element.ReferralRequest.requester(XMLNAME = "requester", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// The clinical specialty (discipline) that the referral is requested for.
/// <p>
/// any FHIR3 code may be used; 
/// practitioner-specialty shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property specialty As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "specialty", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Receiver of referral / transfer of care request.
/// <p>
/// Practitioner | Organization | HealthcareService
Property recipient As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "recipient", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Reason for referral / transfer of care request.
/// <p>
/// any FHIR3 code may be used; 
/// clinical-findings shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property reasonCode As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "reasonCode", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Why is service needed?
/// <p>
/// Condition | Observation
Property reasonReference As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "reasonReference", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// A textual description of the referral.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Additonal information to support referral or transfer of care request.
/// <p>
/// Any FHIR3 Resource may be indicated by this Reference
Property supportingInfo As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "supportingInfo", XMLPROJECTION = "ELEMENT");

/// Annotation
/// <p>
/// Comments made about referral request.
Property note As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Annotation(XMLNAME = "note", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Key events in history of request.
/// <p>
/// Provenance
Property relevantHistory As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "relevantHistory", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ReferralRequest";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ReferralRequest";

}
