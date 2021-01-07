/// A resource that describes a message that is exchanged between systems.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.MessageHeader Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// instant
/// <p>
/// Time that the message was sent.
Property timestamp As %String(MAXLEN = 1000000, XMLNAME = "timestamp", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Coding
/// <p>
/// Code for the event this message represents.
/// <p>
/// message-events is the PREFERRED FHIR2 ValueSet for codes, 
/// but if you need to express meanings not found in message-events, 
/// you may use codes from any ValueSet.
Property event As HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "event", XMLPROJECTION = "ELEMENT") [ Required ];

/// BackboneElement
/// <p>
/// If this is a reply to prior message.
Property response As HS.FHIR.DTL.vDSTU2.Model.Element.MessageHeader.response(XMLNAME = "response", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Message Source Application.
Property source As HS.FHIR.DTL.vDSTU2.Model.Element.MessageHeader.source(XMLNAME = "source", XMLPROJECTION = "ELEMENT") [ Required ];

/// BackboneElement
/// <p>
/// Message Destination Application(s)
Property destination As list Of HS.FHIR.DTL.vDSTU2.Model.Element.MessageHeader.destination(XMLNAME = "destination", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// The source of the data entry.
/// <p>
/// Practitioner
Property enterer As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "enterer", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// The source of the decision.
/// <p>
/// Practitioner
Property author As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "author", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Intended "real-world" recipient for the data.
/// <p>
/// Practitioner | Organization
Property receiver As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "receiver", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Final responsibility for event.
/// <p>
/// Practitioner | Organization
Property responsible As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "responsible", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Cause of event.
/// <p>
/// any FHIR2 code may be used; 
/// message-reason-encounter shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property reason As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "reason", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// The actual content of the message.
/// <p>
/// Any FHIR2 Resource may be indicated by this Reference
Property data As list Of HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "data", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "MessageHeader";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "MessageHeader";

}
