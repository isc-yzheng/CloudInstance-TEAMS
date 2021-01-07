/// If messaging is supported.
Class HS.FHIR.DTL.vSTU3.Model.Element.CapabilityStatement.messaging Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// BackboneElement
/// <p>
/// Where messages should be sent.
Property endpoint As list Of HS.FHIR.DTL.vSTU3.Model.Element.CapabilityStatement.messaging.endpoint(XMLNAME = "endpoint", XMLPROJECTION = "ELEMENT");

/// unsignedInt
/// <p>
/// Reliable Message Cache Length (min)
Property reliableCache As %Integer(XMLNAME = "reliableCache", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Messaging interface behavior details.
Property documentation As %String(MAXLEN = 1000000, XMLNAME = "documentation", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Messages supported by this system.
Property supportedMessage As list Of HS.FHIR.DTL.vSTU3.Model.Element.CapabilityStatement.messaging.supportedMessage(XMLNAME = "supportedMessage", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Declare support for this event.
Property event As list Of HS.FHIR.DTL.vSTU3.Model.Element.CapabilityStatement.messaging.event(XMLNAME = "event", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "CapabilityStatement.messaging";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "CapabilityStatement.messaging";

}
