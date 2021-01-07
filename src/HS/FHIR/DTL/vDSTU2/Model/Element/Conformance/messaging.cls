/// If messaging is supported.
Class HS.FHIR.DTL.vDSTU2.Model.Element.Conformance.messaging Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// BackboneElement
/// <p>
/// A messaging service end-point.
Property endpoint As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Conformance.messaging.endpoint(XMLNAME = "endpoint", XMLPROJECTION = "ELEMENT");

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
/// Declare support for this event.
Property event As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Conformance.messaging.event(XMLNAME = "event", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Conformance.messaging";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Conformance.messaging";

}
