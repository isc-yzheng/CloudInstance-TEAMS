/// 
Class HS.AU.SMD.eSignatureType Extends HS.AU.SMD.SignedPayloadData [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://ns.electronichealth.net.au/cdaPackage/xsd/eSignature/2012";

Parameter XMLNAME = "eSignatureType";

Property ID As %String(XMLNAME = "id", XMLPROJECTION = "ATTRIBUTE");

Property Signature As HS.AU.SMD.eSignatureDataType(XMLNAME = "eSignature");

}
