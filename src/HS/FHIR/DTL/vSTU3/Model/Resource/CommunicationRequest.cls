/// A request to convey information; 
/// e.g. 
/// the CDS system proposes that an alert be sent to a responsible provider, 
/// the CDS system proposes that the public health agency be notified about a reportable condition.
Class HS.FHIR.DTL.vSTU3.Model.Resource.CommunicationRequest Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Unique identifier.
Property identifier As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Fulfills plan or proposal.
/// <p>
/// Any FHIR3 Resource may be indicated by this Reference
Property basedOn As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "basedOn", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Request(s) replaced by this request.
/// <p>
/// CommunicationRequest
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

/// CodeableConcept
/// <p>
/// Message category.
/// <p>
/// any FHIR3 code may be used; 
/// communication-category shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property category As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "category", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// Message urgency.
/// <p>
/// request-priority is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend request-priority and you may NOT use codes from other ValueSets.
Property priority As %String(MAXLEN = 1000000, XMLNAME = "priority", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// A channel of communication.
/// <p>
/// any FHIR3 code may be used; 
/// v3-ParticipationMode shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property medium As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "medium", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Focus of message.
/// <p>
/// Patient | Group
Property subject As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "subject", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Message recipient.
/// <p>
/// Device | Organization | Patient | Practitioner | RelatedPerson | Group | CareTeam
Property recipient As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "recipient", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Focal resources.
/// <p>
/// Any FHIR3 Resource may be indicated by this Reference
Property topic As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "topic", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Encounter or episode leading to message.
/// <p>
/// Encounter | EpisodeOfCare
Property context As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "context", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Message payload.
Property payload As list Of HS.FHIR.DTL.vSTU3.Model.Element.CommunicationRequest.payload(XMLNAME = "payload", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
///  When scheduled.
Property occurrenceDateTime As %String(MAXLEN = 1000000, XMLNAME = "occurrenceDateTime", XMLPROJECTION = "ATTRIBUTE");

/// Period
/// <p>
///  When scheduled.
Property occurrencePeriod As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "occurrencePeriod", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// When request transitioned to being actionable.
Property authoredOn As %String(MAXLEN = 1000000, XMLNAME = "authoredOn", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Message sender.
/// <p>
/// Device | Organization | Patient | Practitioner | RelatedPerson
Property sender As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "sender", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Who/what is requesting service.
Property requester As HS.FHIR.DTL.vSTU3.Model.Element.CommunicationRequest.requester(XMLNAME = "requester", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Why is communication needed?
/// <p>
/// any FHIR3 code may be used; 
/// v3-ActReason shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property reasonCode As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "reasonCode", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Why is communication needed?
/// <p>
/// Condition | Observation
Property reasonReference As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "reasonReference", XMLPROJECTION = "ELEMENT");

/// Annotation
/// <p>
/// Comments made about communication request.
Property note As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Annotation(XMLNAME = "note", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "CommunicationRequest";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "CommunicationRequest";

}
