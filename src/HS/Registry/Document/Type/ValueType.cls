Class HS.Registry.Document.Type.ValueType Extends (%SerialObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = 1;

Property ValueText As %String(MAXLEN = "");

Property Charset As %String;

Property Lang As %String;

Storage Default
{
<Data name="ValueTypeState">
<Value name="1">
<Value>ValueText</Value>
</Value>
<Value name="2">
<Value>Charset</Value>
</Value>
<Value name="3">
<Value>Lang</Value>
</Value>
</Data>
<State>ValueTypeState</State>
<StreamLocation>^HS.Registry.DocuDF40.ValueTypeS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
