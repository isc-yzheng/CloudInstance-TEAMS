Class HS.Doc.Mapping.Common.DocumentType Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter NAMESPACE = "http://www.intersystems.com/healthshare/mapping";

Parameter SUPPRESSTYPEPREFIX = 1;

Property docType As %String(XMLPROJECTION = "ATTRIBUTE");

Property cdaType As %String(XMLPROJECTION = "ELEMENT");

}
