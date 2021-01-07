/// A formal computable definition of an operation (on the RESTful interface) or a named query (using the search interaction).
Class HS.FHIR.DTL.vSTU3.Model.Resource.MessageDefinition Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// uri
/// <p>
/// Logical URI to reference this message definition (globally unique)
Property url As %String(MAXLEN = 1000000, XMLNAME = "url", XMLPROJECTION = "ATTRIBUTE");

/// Identifier
/// <p>
/// Additional identifier for the message definition.
Property identifier As HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Business version of the message definition.
Property version As %String(MAXLEN = 1000000, XMLNAME = "version", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Name for this message definition (computer friendly)
Property name As %String(MAXLEN = 1000000, XMLNAME = "name", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Name for this message definition (human friendly)
Property title As %String(MAXLEN = 1000000, XMLNAME = "title", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// draft | active | retired | unknown
/// <p>
/// publication-status is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend publication-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// boolean
/// <p>
/// For testing purposes, 
/// not real usage.
Property experimental As %Boolean(XMLNAME = "experimental", XMLPROJECTION = "ATTRIBUTE");

/// dateTime
/// <p>
/// Date this was last changed.
Property date As %String(MAXLEN = 1000000, XMLNAME = "date", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// string
/// <p>
/// Name of the publisher (organization or individual)
Property publisher As %String(MAXLEN = 1000000, XMLNAME = "publisher", XMLPROJECTION = "ATTRIBUTE");

/// ContactDetail
/// <p>
/// Contact details for the publisher.
Property contact As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.ContactDetail(XMLNAME = "contact", XMLPROJECTION = "ELEMENT");

/// markdown
/// <p>
/// Natural language description of the message definition.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

/// UsageContext
/// <p>
/// Context the content is intended to support.
Property useContext As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.UsageContext(XMLNAME = "useContext", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Intended jurisdiction for message definition (if applicable)
/// <p>
/// jurisdiction is the REQUIRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in jurisdiction, 
/// you may formally EXTEND jurisdiction to add codes to it.
Property jurisdiction As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "jurisdiction", XMLPROJECTION = "ELEMENT");

/// markdown
/// <p>
/// Why this message definition is defined.
Property purpose As %String(MAXLEN = 1000000, XMLNAME = "purpose", XMLPROJECTION = "ATTRIBUTE");

/// markdown
/// <p>
/// Use and/or publishing restrictions.
Property copyright As %String(MAXLEN = 1000000, XMLNAME = "copyright", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Definition this one is based on.
/// <p>
/// MessageDefinition
Property base As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "base", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Protocol/workflow this is part of.
/// <p>
/// ActivityDefinition | PlanDefinition
Property parent As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "parent", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Takes the place of.
/// <p>
/// MessageDefinition
Property replaces As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "replaces", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// Event type.
/// <p>
/// any FHIR3 code may be used; 
/// message-events shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property event As HS.FHIR.DTL.vSTU3.Model.Datatype.Coding(XMLNAME = "event", XMLPROJECTION = "ELEMENT") [ Required ];

/// code
/// <p>
/// Consequence | Currency | Notification
/// <p>
/// message-significance-category is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend message-significance-category and you may NOT use codes from other ValueSets.
Property category As %String(MAXLEN = 1000000, XMLNAME = "category", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Resource(s) that are the subject of the event.
Property focus As list Of HS.FHIR.DTL.vSTU3.Model.Element.MessageDefinition.focus(XMLNAME = "focus", XMLPROJECTION = "ELEMENT");

/// boolean
/// <p>
/// Is a response required?
Property responseRequired As %Boolean(XMLNAME = "responseRequired", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Responses to this message.
Property allowedResponse As list Of HS.FHIR.DTL.vSTU3.Model.Element.MessageDefinition.allowedResponse(XMLNAME = "allowedResponse", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "MessageDefinition";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "MessageDefinition";

}
