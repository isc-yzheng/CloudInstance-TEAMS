Class HS.AU.SMD.eSignature Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://ns.electronichealth.net.au/cdaPackage/xsd/eSignature/2012";

Parameter XMLNAME = "signedPayloadData";

Property ID As %String(XMLNAME = "id", XMLPROJECTION = "ATTRIBUTE");

Property Signature As HS.AU.SMD.eSignatureType(XMLNAME = "eSignature");

}
