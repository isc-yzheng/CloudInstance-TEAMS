/// If messaging is supported.
Class HS.FHIR.DTL.vR4.Model.Element.CapabilityStatement.messaging Extends HS.FHIR.DTL.vR4.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// BackboneElement
/// <p>
/// Where messages should be sent.
Property endpoint As list Of HS.FHIR.DTL.vR4.Model.Element.CapabilityStatement.messaging.endpoint(XMLNAME = "endpoint", XMLPROJECTION = "ELEMENT");

/// unsignedInt
/// <p>
/// Reliable Message Cache Length (min)
Property reliableCache As %Integer(XMLNAME = "reliableCache", XMLPROJECTION = "ATTRIBUTE");

/// markdown
/// <p>
/// Messaging interface behavior details.
Property documentation As %String(MAXLEN = 1000000, XMLNAME = "documentation", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Messages supported by this system.
Property supportedMessage As list Of HS.FHIR.DTL.vR4.Model.Element.CapabilityStatement.messaging.supportedMessage(XMLNAME = "supportedMessage", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "CapabilityStatement.messaging";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "CapabilityStatement.messaging";

}
