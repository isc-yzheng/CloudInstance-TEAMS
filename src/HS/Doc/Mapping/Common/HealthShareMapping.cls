Class HS.Doc.Mapping.Common.HealthShareMapping Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter NAMESPACE = "http://www.intersystems.com/healthshare/mapping";

Property name As %String(MAXLEN = 300, XMLPROJECTION = "ATTRIBUTE");

Property Source As HS.Doc.Mapping.Common.DocumentType;

Property Target As HS.Doc.Mapping.Common.DocumentType;

Property Mappings As list Of HS.Doc.Mapping.Common.Mapping;

Property StructuredMappings As list Of HS.Doc.Mapping.Common.StructuredMapping;

}
