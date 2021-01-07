Class HS.Doc.Mapping.Common.Mapping Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter NAMESPACE = "http://www.intersystems.com/healthshare/mapping";

Property Target As list Of HS.Doc.Mapping.Common.MappingTarget(XMLPROJECTION = "ELEMENT");

Property id As %String(MAXLEN = 4000, XMLPROJECTION = "ATTRIBUTE");

}
