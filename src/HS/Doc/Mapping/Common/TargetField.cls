Class HS.Doc.Mapping.Common.TargetField Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter NAMESPACE = "http://www.intersystems.com/healthshare/mapping";

Parameter XMLNAME = "Target";

Property Path As %String(MAXLEN = 300);

Property Note As %String(MAXLEN = 4000);

Property Source As list Of HS.Doc.Mapping.Common.SourceField(XMLPROJECTION = "ELEMENT");

Property StructuredMappingRef As %String;

}
