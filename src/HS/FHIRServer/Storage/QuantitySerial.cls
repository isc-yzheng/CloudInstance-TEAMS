Class HS.FHIRServer.Storage.QuantitySerial Extends %SerialObject
{

Property value As %Numeric;

Property valueHigh As %Numeric;

Property unit As %String(MAXLEN = 128);

Storage Default
{
<Data name="QuantitySerialState">
<Value name="1">
<Value>value</Value>
</Value>
<Value name="2">
<Value>unit</Value>
</Value>
<Value name="3">
<Value>valueHigh</Value>
</Value>
</Data>
<State>QuantitySerialState</State>
<StreamLocation>^HS.FHIRServ87EB.QuantitySerialS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
