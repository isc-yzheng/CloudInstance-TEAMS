Class HS.Doc.Mapping.HL7.DocumentType Extends HS.Doc.Mapping.Common.DocumentType
{

Parameter XMLTYPE = "HL7";

Property Version As %String;

Property MessageType As list Of %String(XMLPROJECTION = "ELEMENT");

}
