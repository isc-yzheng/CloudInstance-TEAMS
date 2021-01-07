/// Message Source Application.
Class HS.FHIR.DTL.vDSTU2.Model.Element.MessageHeader.source Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// string
/// <p>
/// Name of system.
Property name As %String(MAXLEN = 1000000, XMLNAME = "name", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Name of software running the system.
Property software As %String(MAXLEN = 1000000, XMLNAME = "software", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Version of software running.
Property version As %String(MAXLEN = 1000000, XMLNAME = "version", XMLPROJECTION = "ATTRIBUTE");

/// ContactPoint
/// <p>
/// Human contact for problems.
Property contact As HS.FHIR.DTL.vDSTU2.Model.Datatype.ContactPoint(XMLNAME = "contact", XMLPROJECTION = "ELEMENT");

/// uri
/// <p>
/// Actual message source address or id.
Property endpoint As %String(MAXLEN = 1000000, XMLNAME = "endpoint", XMLPROJECTION = "ATTRIBUTE") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "MessageHeader.source";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "MessageHeader.source";

}
