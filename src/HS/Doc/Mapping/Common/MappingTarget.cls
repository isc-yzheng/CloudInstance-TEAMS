Class HS.Doc.Mapping.Common.MappingTarget Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter NAMESPACE = "http://www.intersystems.com/healthshare/mapping";

Parameter SUPPRESSTYPEPREFIX = 1;

// Parameter XMLNAME = "Target";

Property Field As list Of HS.Doc.Mapping.Common.TargetField(XMLPROJECTION = "ELEMENT");

}
