Class HS.Doc.Mapping.CDA.MappingTarget Extends HS.Doc.Mapping.Common.MappingTarget
{

Parameter NAMESPACE = "http://www.intersystems.com/healthshare/mapping";

Parameter XMLTYPE = "CDAPath";

Property Source As list Of HS.Doc.Mapping.Common.SourceField(XMLPROJECTION = "ELEMENT");

Property Path As %String(MAXLEN = 32000);

Property Note As %String(MAXLEN = 32000);

}
