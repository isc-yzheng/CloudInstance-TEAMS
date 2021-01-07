Class HS.AU.SMD.SignedPayloadContentStream Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLFORMAT = "literal";

Parameter XMLNAME = "signedPayloadData";

Parameter NAMESPACE = "http://ns.electronichealth.net.au/xsp/xsd/SignedPayload/2010";

Parameter XMLPREFIX = "sp";

Property Content As %Stream.GlobalCharacter(CONTENT = "MIXED", XMLPROJECTION = "CONTENT");

Property ID As %String(XMLNAME = "id", XMLPROJECTION = "attribute");

}
