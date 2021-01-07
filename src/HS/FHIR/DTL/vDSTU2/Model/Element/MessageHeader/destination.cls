/// Message Destination Application(s)
Class HS.FHIR.DTL.vDSTU2.Model.Element.MessageHeader.destination Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// string
/// <p>
/// Name of system.
Property name As %String(MAXLEN = 1000000, XMLNAME = "name", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Particular delivery destination within the destination.
/// <p>
/// Device
Property target As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "target", XMLPROJECTION = "ELEMENT");

/// uri
/// <p>
/// Actual destination address or id.
Property endpoint As %String(MAXLEN = 1000000, XMLNAME = "endpoint", XMLPROJECTION = "ATTRIBUTE") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "MessageHeader.destination";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "MessageHeader.destination";

}
