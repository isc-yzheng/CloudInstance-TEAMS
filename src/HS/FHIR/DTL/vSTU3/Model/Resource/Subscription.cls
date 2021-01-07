/// The subscription resource is used to define a push based subscription from a server to another system. 
/// Once a subscription is registered with the server, 
/// the server checks every resource that is created or updated, 
/// and if the resource matches the given criteria, 
/// it sends a message on the defined channel" so that another system is able to take an appropriate action."
Class HS.FHIR.DTL.vSTU3.Model.Resource.Subscription Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// code
/// <p>
/// requested | active | error | off
/// <p>
/// subscription-status is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend subscription-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// ContactPoint
/// <p>
/// Contact details for source (e.g. 
/// troubleshooting)
Property contact As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.ContactPoint(XMLNAME = "contact", XMLPROJECTION = "ELEMENT");

/// instant
/// <p>
/// When to automatically delete the subscription.
Property end As %String(MAXLEN = 1000000, XMLNAME = "end", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Description of why this subscription was created.
Property reason As %String(MAXLEN = 1000000, XMLNAME = "reason", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// string
/// <p>
/// Rule for server push criteria.
Property criteria As %String(MAXLEN = 1000000, XMLNAME = "criteria", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// string
/// <p>
/// Latest error note.
Property error As %String(MAXLEN = 1000000, XMLNAME = "error", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// The channel on which to report matches to the criteria.
Property channel As HS.FHIR.DTL.vSTU3.Model.Element.Subscription.channel(XMLNAME = "channel", XMLPROJECTION = "ELEMENT") [ Required ];

/// Coding
/// <p>
/// A tag to add to matching resources.
/// <p>
/// any FHIR3 code may be used; 
/// subscription-tag shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property tag As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Coding(XMLNAME = "tag", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Subscription";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Subscription";

}
