Class HS.Doc.Mapping.Common.TargetStructure Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter NAMESPACE = "http://www.intersystems.com/healthshare/mapping";

Parameter SUPPRESSTYPEPREFIX = 1;

Property SourceStructure As HS.Doc.Mapping.Common.SourceStructure;

Property Field As list Of HS.Doc.Mapping.Common.TargetField(XMLPROJECTION = "ELEMENT");

}
