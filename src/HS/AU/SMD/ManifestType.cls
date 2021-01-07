/// Created from: http://www.w3.org/TR/xmldsig-core/xmldsig-core-schema.xsd
Class HS.AU.SMD.ManifestType Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://www.w3.org/2000/09/xmldsig#";

Parameter XMLNAME = "ManifestType";

Parameter XMLSEQUENCE = 1;

Property Reference As list Of %XML.Security.Reference(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://www.w3.org/2000/09/xmldsig#", XMLNAME = "Reference", XMLPROJECTION = "ELEMENT", XMLREF = 1) [ Required ];

Property Id As %String(MAXLEN = "", XMLNAME = "Id", XMLPROJECTION = "ATTRIBUTE");

}
