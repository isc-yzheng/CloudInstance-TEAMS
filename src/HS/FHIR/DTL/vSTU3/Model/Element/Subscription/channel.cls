/// The channel on which to report matches to the criteria.
Class HS.FHIR.DTL.vSTU3.Model.Element.Subscription.channel Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// code
/// <p>
/// rest-hook | websocket | email | sms | message
/// <p>
/// subscription-channel-type is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend subscription-channel-type and you may NOT use codes from other ValueSets.
Property type As %String(MAXLEN = 1000000, XMLNAME = "type", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// uri
/// <p>
/// Where the channel points to.
Property endpoint As %String(MAXLEN = 1000000, XMLNAME = "endpoint", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Mimetype to send, 
/// or omit for no payload.
Property payload As %String(MAXLEN = 1000000, XMLNAME = "payload", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Usage depends on the channel type.
Property header As list Of %String(MAXLEN = 1000000, XMLNAME = "header", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Subscription.channel";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Subscription.channel";

}
