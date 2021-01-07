Class HS.Doc.Mapping.Common.StructuredMapping Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter NAMESPACE = "http://www.intersystems.com/healthshare/mapping";

Parameter SUPPRESSTYPEPREFIX = 1;

Property id As %String(MAXLEN = 4000, XMLPROJECTION = "ATTRIBUTE");

Property TargetStructure As HS.Doc.Mapping.Common.TargetStructure(XMLPROJECTION = "ELEMENT");

Property Note As %String(MAXLEN = 4000);

}
