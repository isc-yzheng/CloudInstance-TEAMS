/// A record of information transmitted from a sender to a receiver.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.Communication Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
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
/// Device | Organization | Patient | Practitioner | RelatedPerson | Group
Property recipient As list Of HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "recipient", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Message payload.
Property payload As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Communication.payload(XMLNAME = "payload", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// A channel of communication.
/// <p>
/// any FHIR2 code may be used; 
/// v3-ParticipationMode shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property medium As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "medium", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// in-progress | completed | suspended | rejected | failed
/// <p>
/// communication-status is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend communication-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Encounter leading to message.
/// <p>
/// Encounter
Property encounter As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "encounter", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// When sent.
Property sent As %String(MAXLEN = 1000000, XMLNAME = "sent", XMLPROJECTION = "ATTRIBUTE");

/// dateTime
/// <p>
/// When received.
Property received As %String(MAXLEN = 1000000, XMLNAME = "received", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Indication for message.
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property reason As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "reason", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Focus of message.
/// <p>
/// Patient
Property subject As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "subject", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// CommunicationRequest producing this message.
/// <p>
/// CommunicationRequest
Property requestDetail As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "requestDetail", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Communication";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Communication";

}
