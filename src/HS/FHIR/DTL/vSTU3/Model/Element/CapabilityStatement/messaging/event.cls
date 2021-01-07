/// Declare support for this event.
Class HS.FHIR.DTL.vSTU3.Model.Element.CapabilityStatement.messaging.event Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Coding
/// <p>
/// Event type.
/// <p>
/// any FHIR3 code may be used; 
/// message-events shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property code As HS.FHIR.DTL.vSTU3.Model.Datatype.Coding(XMLNAME = "code", XMLPROJECTION = "ELEMENT") [ Required ];

/// code
/// <p>
/// Consequence | Currency | Notification
/// <p>
/// message-significance-category is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend message-significance-category and you may NOT use codes from other ValueSets.
Property category As %String(MAXLEN = 1000000, XMLNAME = "category", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// sender | receiver
/// <p>
/// event-capability-mode is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend event-capability-mode and you may NOT use codes from other ValueSets.
Property mode As %String(MAXLEN = 1000000, XMLNAME = "mode", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// code
/// <p>
/// Resource that's focus of message.
/// <p>
/// resource-types is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend resource-types and you may NOT use codes from other ValueSets.
Property focus As %String(MAXLEN = 1000000, XMLNAME = "focus", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Reference
/// <p>
/// Profile that describes the request.
/// <p>
/// StructureDefinition
Property request As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "request", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Profile that describes the response.
/// <p>
/// StructureDefinition
Property response As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "response", XMLPROJECTION = "ELEMENT") [ Required ];

/// string
/// <p>
/// Endpoint-specific event documentation.
Property documentation As %String(MAXLEN = 1000000, XMLNAME = "documentation", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "CapabilityStatement.messaging.event";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "CapabilityStatement.messaging.event";

}
