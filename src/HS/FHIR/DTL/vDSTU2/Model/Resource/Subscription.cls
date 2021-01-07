/// A server push subscription criteria.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.Subscription Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// string
/// <p>
/// Rule for server push criteria.
Property criteria As %String(MAXLEN = 1000000, XMLNAME = "criteria", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// ContactPoint
/// <p>
/// Contact details for source (e.g. 
/// troubleshooting)
Property contact As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.ContactPoint(XMLNAME = "contact", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Description of why this subscription was created.
Property reason As %String(MAXLEN = 1000000, XMLNAME = "reason", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// code
/// <p>
/// requested | active | error | off
/// <p>
/// subscription-status is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend subscription-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// string
/// <p>
/// Latest error note.
Property error As %String(MAXLEN = 1000000, XMLNAME = "error", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// The channel on which to report matches to the criteria.
Property channel As HS.FHIR.DTL.vDSTU2.Model.Element.Subscription.channel(XMLNAME = "channel", XMLPROJECTION = "ELEMENT") [ Required ];

/// instant
/// <p>
/// When to automatically delete the subscription.
Property end As %String(MAXLEN = 1000000, XMLNAME = "end", XMLPROJECTION = "ATTRIBUTE");

/// Coding
/// <p>
/// A tag to add to matching resources.
/// <p>
/// any FHIR2 code may be used; 
/// subscription-tag shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property tag As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "tag", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Subscription";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Subscription";

}
