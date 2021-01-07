/// Details for all kinds of technology-mediated contact points for a person or organization, 
/// including telephone, 
/// email, 
/// etc.
Class HS.FHIR.DTL.vSTU3.Model.Datatype.ContactPoint Extends HS.FHIR.DTL.vSTU3.Model.Base.Element [ Not ProcedureBlock ]
{

/// code
/// <p>
/// phone | fax | email | pager | url | sms | other
/// <p>
/// contact-point-system is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend contact-point-system and you may NOT use codes from other ValueSets.
Property system As %String(MAXLEN = 1000000, XMLNAME = "system", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// The actual contact point details.
Property value As %String(MAXLEN = 1000000, XMLNAME = "value", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// home | work | temp | old | mobile - purpose of this contact point
/// <p>
/// contact-point-use is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend contact-point-use and you may NOT use codes from other ValueSets.
Property use As %String(MAXLEN = 1000000, XMLNAME = "use", XMLPROJECTION = "ATTRIBUTE");

/// positiveInt
/// <p>
/// Specify preferred order of use (1 = highest)
Property rank As %Integer(XMLNAME = "rank", XMLPROJECTION = "ATTRIBUTE");

/// Period
/// <p>
/// Time period when the contact point was/is in use.
Property period As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "period", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ContactPoint";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ContactPoint";

}
