Class HS.Doc.Mapping.SDA.MappingTarget Extends HS.Doc.Mapping.Common.MappingTarget
{

Parameter NAMESPACE = "http://www.intersystems.com/healthshare/mapping";

Parameter XMLTYPE = "SDAPath";

Property Streamlet As %String;

Property Root As %String;

Property Note As %String(MAXLEN = 4000);

Property Source As list Of HS.Doc.Mapping.Common.SourceField(XMLPROJECTION = "ELEMENT");

Property FieldStructure As %String;

Property Path As %String;

Property XPath As %String(MAXLEN = 32000);

}
