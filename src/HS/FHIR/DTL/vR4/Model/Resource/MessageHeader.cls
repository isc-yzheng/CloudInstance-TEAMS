/// A resource that describes a message that is exchanged between systems.
Class HS.FHIR.DTL.vR4.Model.Resource.MessageHeader Extends HS.FHIR.DTL.vR4.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Coding
/// <p>
/// Code for the event this message represents or link to event definition.
/// <p>
/// any FHIR4 code may be used; 
/// message-events shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property eventCoding As HS.FHIR.DTL.vR4.Model.Datatype.Coding(XMLNAME = "eventCoding", XMLPROJECTION = "ELEMENT") [ Required ];

/// uri
/// <p>
/// Code for the event this message represents or link to event definition.
Property eventUri As %String(MAXLEN = 1000000, XMLNAME = "eventUri", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// BackboneElement
/// <p>
/// Message destination application(s)
Property destination As list Of HS.FHIR.DTL.vR4.Model.Element.MessageHeader.destination(XMLNAME = "destination", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Real world sender of the message.
/// <p>
/// Practitioner | PractitionerRole | Organization
Property sender As HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "sender", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// The source of the data entry.
/// <p>
/// Practitioner | PractitionerRole
Property enterer As HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "enterer", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// The source of the decision.
/// <p>
/// Practitioner | PractitionerRole
Property author As HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "author", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Message source application.
Property source As HS.FHIR.DTL.vR4.Model.Element.MessageHeader.source(XMLNAME = "source", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Final responsibility for event.
/// <p>
/// Practitioner | PractitionerRole | Organization
Property responsible As HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "responsible", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Cause of event.
/// <p>
/// any FHIR4 code may be used; 
/// message-reason-encounter shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property reason As HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "reason", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// If this is a reply to prior message.
Property response As HS.FHIR.DTL.vR4.Model.Element.MessageHeader.response(XMLNAME = "response", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// The actual content of the message.
/// <p>
/// Any FHIR4 Resource may be indicated by this Reference
Property focus As list Of HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "focus", XMLPROJECTION = "ELEMENT");

/// canonical
/// <p>
/// Link to the definition for this message.
/// <p>
/// TO DO: Unrecognized value type for the FHIR4 model
Property definition As %String(MAXLEN = 1000000, XMLNAME = "definition", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "MessageHeader";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "MessageHeader";

}
