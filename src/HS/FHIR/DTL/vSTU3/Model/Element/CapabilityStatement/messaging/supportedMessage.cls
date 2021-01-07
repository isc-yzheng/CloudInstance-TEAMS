/// Messages supported by this system.
Class HS.FHIR.DTL.vSTU3.Model.Element.CapabilityStatement.messaging.supportedMessage Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// code
/// <p>
/// sender | receiver
/// <p>
/// event-capability-mode is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend event-capability-mode and you may NOT use codes from other ValueSets.
Property mode As %String(MAXLEN = 1000000, XMLNAME = "mode", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Reference
/// <p>
/// Message supported by this system.
/// <p>
/// MessageDefinition
Property definition As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "definition", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "CapabilityStatement.messaging.supportedMessage";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "CapabilityStatement.messaging.supportedMessage";

}
