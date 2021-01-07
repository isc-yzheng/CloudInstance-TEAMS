/// The ContactDetail structure defines general contact details.
Class HS.FHIR.DTL.vSTU3.Model.Datatype.ContactDetail Extends HS.FHIR.DTL.vSTU3.Model.Base.Element [ Not ProcedureBlock ]
{

/// string
/// <p>
/// Name of an individual to contact.
Property name As %String(MAXLEN = 1000000, XMLNAME = "name", XMLPROJECTION = "ATTRIBUTE");

/// ContactPoint
/// <p>
/// Contact details for individual or organization.
Property telecom As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.ContactPoint(XMLNAME = "telecom", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ContactDetail";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ContactDetail";

}
