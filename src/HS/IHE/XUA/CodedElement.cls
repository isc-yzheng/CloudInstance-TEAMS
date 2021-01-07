Class HS.IHE.XUA.CodedElement Extends %SAML.AttributeValueElement
{

Parameter XMLFORMAT = "literal";

Parameter NAMESPACE = "urn:hl7-org:v3";

Parameter ELEMENTQUALIFIED = 0;

Parameter XMLPREFIX = "hl7";

Property code As %String(MAXLEN = "", XMLPROJECTION = "attribute");

Property codeSystem As %String(MAXLEN = "", XMLPROJECTION = "attribute");

Property codeSystemName As %String(MAXLEN = "", XMLPROJECTION = "attribute");

Property displayName As %String(MAXLEN = "", XMLPROJECTION = "attribute");

}
