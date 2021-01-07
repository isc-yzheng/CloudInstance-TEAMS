/// Base for serial (embedded) SDA objects
Class HS.SDA3.DataType Extends (%SerialObject, %XML.Adaptor, HS.SDA3.QuickXML) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

/// Ignore all nulls (i.e. don't store $C(0)), but do not export empty tags
Parameter XMLIGNORENULL = "inputonly";

Storage Default
{
<StreamLocation>^HS.SDA3.DataTypeS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
