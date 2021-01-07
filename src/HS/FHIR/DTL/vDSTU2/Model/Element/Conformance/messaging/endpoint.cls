/// A messaging service end-point.
Class HS.FHIR.DTL.vDSTU2.Model.Element.Conformance.messaging.endpoint Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Coding
/// <p>
/// http | ftp | mllp +
/// <p>
/// message-transport is the REQUIRED FHIR2 ValueSet for codes, 
/// but if you need to express meanings not found in message-transport, 
/// you may formally EXTEND message-transport to add codes to it.
Property protocol As HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "protocol", XMLPROJECTION = "ELEMENT") [ Required ];

/// uri
/// <p>
/// Address of end-point.
Property address As %String(MAXLEN = 1000000, XMLNAME = "address", XMLPROJECTION = "ATTRIBUTE") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Conformance.messaging.endpoint";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Conformance.messaging.endpoint";

}
