/// Where messages should be sent.
Class HS.FHIR.DTL.vSTU3.Model.Element.CapabilityStatement.messaging.endpoint Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Coding
/// <p>
/// http | ftp | mllp +
/// <p>
/// message-transport is the REQUIRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in message-transport, 
/// you may formally EXTEND message-transport to add codes to it.
Property protocol As HS.FHIR.DTL.vSTU3.Model.Datatype.Coding(XMLNAME = "protocol", XMLPROJECTION = "ELEMENT") [ Required ];

/// uri
/// <p>
/// Network address or identifier of the end-point.
Property address As %String(MAXLEN = 1000000, XMLNAME = "address", XMLPROJECTION = "ATTRIBUTE") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "CapabilityStatement.messaging.endpoint";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "CapabilityStatement.messaging.endpoint";

}
