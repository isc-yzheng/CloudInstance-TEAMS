/// 
Class HS.AU.SMD.eSignatureDataType Extends HS.AU.SMD.SignedPayloadData [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLFORMAT = "literal";

Parameter NAMESPACE = "http://ns.electronichealth.net.au/cdaPackage/xsd/eSignature/2012";

Parameter XMLNAME = "eSignature";

Parameter XMLSEQUENCE = 1;

Property Manifest As HS.AU.SMD.ManifestType(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://www.w3.org/2000/09/xmldsig#", XMLNAME = "Manifest", XMLREF = 1) [ Required ];

Property SigningTime As %TimeStamp(XMLNAME = "signingTime") [ Required ];

Property Approver As HS.AU.SMD.ApproverType(XMLNAME = "approver") [ Required ];

Property Any As list Of %XML.String(XMLNAME = "any", XMLPROJECTION = "ANY") [ SqlFieldName = _any ];

}
