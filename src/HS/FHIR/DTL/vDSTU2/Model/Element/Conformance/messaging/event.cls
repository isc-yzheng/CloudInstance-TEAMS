/// Declare support for this event.
Class HS.FHIR.DTL.vDSTU2.Model.Element.Conformance.messaging.event Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Coding
/// <p>
/// Event type.
/// <p>
/// message-events is the PREFERRED FHIR2 ValueSet for codes, 
/// but if you need to express meanings not found in message-events, 
/// you may use codes from any ValueSet.
Property code As HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "code", XMLPROJECTION = "ELEMENT") [ Required ];

/// code
/// <p>
/// Consequence | Currency | Notification
/// <p>
/// message-significance-category is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend message-significance-category and you may NOT use codes from other ValueSets.
Property category As %String(MAXLEN = 1000000, XMLNAME = "category", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// sender | receiver
/// <p>
/// message-conformance-event-mode is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend message-conformance-event-mode and you may NOT use codes from other ValueSets.
Property mode As %String(MAXLEN = 1000000, XMLNAME = "mode", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// code
/// <p>
/// Resource that's focus of message.
/// <p>
/// resource-types is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend resource-types and you may NOT use codes from other ValueSets.
Property focus As %String(MAXLEN = 1000000, XMLNAME = "focus", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Reference
/// <p>
/// Profile that describes the request.
/// <p>
/// StructureDefinition
Property request As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "request", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Profile that describes the response.
/// <p>
/// StructureDefinition
Property response As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "response", XMLPROJECTION = "ELEMENT") [ Required ];

/// string
/// <p>
/// Endpoint-specific event documentation.
Property documentation As %String(MAXLEN = 1000000, XMLNAME = "documentation", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Conformance.messaging.event";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Conformance.messaging.event";

}
