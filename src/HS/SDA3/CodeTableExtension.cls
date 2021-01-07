/// Base for extending code table classes
/// While identical to HS.SDA3.DataType, we use this to resolve XML name conflicts
Class HS.SDA3.CodeTableExtension Extends (%SerialObject, %XML.Adaptor, HS.SDA3.QuickXML) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

/// Ignore all nulls (i.e. don't store $C(0)), but do not export empty tags
Parameter XMLIGNORENULL = "inputonly";

Storage Default
{
<StreamLocation>^HS.SDA3.CodeTableExtensionS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
