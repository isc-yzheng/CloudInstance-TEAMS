Class HS.Registry.Document.SerialExternalIdentifier Extends (%SerialObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Property IID As %String;

Property Value As %String(MAXLEN = 256);

Storage Default
{
<Data name="SerialExternalIdentifierState">
<Value name="1">
<Value>IID</Value>
</Value>
<Value name="2">
<Value>Value</Value>
</Value>
</Data>
<State>SerialExternalIdentifierState</State>
<StreamLocation>^HS.Registr50B9.SerialExterEB19S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
