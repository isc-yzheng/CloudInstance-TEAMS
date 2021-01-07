/// An occurrence of information being transmitted; 
/// e.g. 
/// an alert that was sent to a responsible provider, 
/// a public health agency was notified about a reportable condition.
Class HS.FHIR.DTL.vSTU3.Model.Resource.Communication Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Unique identifier.
Property identifier As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Instantiates protocol or definition.
/// <p>
/// PlanDefinition | ActivityDefinition
Property definition As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "definition", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Request fulfilled by this communication.
/// <p>
/// Any FHIR3 Resource may be indicated by this Reference
Property basedOn As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "basedOn", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Part of this action.
/// <p>
/// Any FHIR3 Resource may be indicated by this Reference
Property partOf As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "partOf", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// preparation | in-progress | suspended | aborted | completed | entered-in-error
/// <p>
/// event-status is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend event-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// boolean
/// <p>
/// Communication did not occur.
Property notDone As %Boolean(XMLNAME = "notDone", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Why communication did not occur.
/// <p>
/// any FHIR3 code may be used; 
/// communication-not-done-reason shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property notDoneReason As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "notDoneReason", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Message category.
/// <p>
/// any FHIR3 code may be used; 
/// communication-category shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property category As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "category", XMLPROJECTION = "ELEMENT");

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
/// Device | Organization | Patient | Practitioner | RelatedPerson | Group
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

/// dateTime
/// <p>
/// When sent.
Property sent As %String(MAXLEN = 1000000, XMLNAME = "sent", XMLPROJECTION = "ATTRIBUTE");

/// dateTime
/// <p>
/// When received.
Property received As %String(MAXLEN = 1000000, XMLNAME = "received", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Message sender.
/// <p>
/// Device | Organization | Patient | Practitioner | RelatedPerson
Property sender As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "sender", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Indication for message.
/// <p>
/// any FHIR3 code may be used; 
/// clinical-findings shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property reasonCode As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "reasonCode", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Why was communication done?
/// <p>
/// Condition | Observation
Property reasonReference As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "reasonReference", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Message payload.
Property payload As list Of HS.FHIR.DTL.vSTU3.Model.Element.Communication.payload(XMLNAME = "payload", XMLPROJECTION = "ELEMENT");

/// Annotation
/// <p>
/// Comments made about the communication.
Property note As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Annotation(XMLNAME = "note", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Communication";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Communication";

}
