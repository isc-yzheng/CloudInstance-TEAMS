/// A request for information to be sent to a receiver.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.CommunicationRequest Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Unique identifier.
Property identifier As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Message category.
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property category As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "category", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Message sender.
/// <p>
/// Device | Organization | Patient | Practitioner | RelatedPerson
Property sender As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "sender", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Message recipient.
/// <p>
/// Device | Organization | Patient | Practitioner | RelatedPerson
Property recipient As list Of HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "recipient", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Message payload.
Property payload As list Of HS.FHIR.DTL.vDSTU2.Model.Element.CommunicationRequest.payload(XMLNAME = "payload", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// A channel of communication.
/// <p>
/// any FHIR2 code may be used; 
/// v3-ParticipationMode shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property medium As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "medium", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// An individual who requested a communication.
/// <p>
/// Practitioner | Patient | RelatedPerson
Property requester As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "requester", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// proposed | planned | requested | received | accepted | in-progress | completed | suspended | rejected | failed
/// <p>
/// communication-request-status is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend communication-request-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Encounter leading to message.
/// <p>
/// Encounter
Property encounter As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "encounter", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// When scheduled.
Property scheduledDateTime As %String(MAXLEN = 1000000, XMLNAME = "scheduledDateTime", XMLPROJECTION = "ATTRIBUTE");

/// Period
/// <p>
/// When scheduled.
Property scheduledPeriod As HS.FHIR.DTL.vDSTU2.Model.Datatype.Period(XMLNAME = "scheduledPeriod", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Indication for message.
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property reason As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "reason", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// When ordered or proposed.
Property requestedOn As %String(MAXLEN = 1000000, XMLNAME = "requestedOn", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Focus of message.
/// <p>
/// Patient
Property subject As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "subject", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Message urgency.
/// <p>
/// any FHIR2 code may be used; 
/// diagnostic-order-priority shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property priority As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "priority", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "CommunicationRequest";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "CommunicationRequest";

}
