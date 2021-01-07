Class HS.Registry.Service.UDP Extends HS.Registry.Service.Abstract
{

Property Host As %String(MAXLEN = 150);

Property Port As %Integer;

Property UDPSenderCommand As %String;

Property Info As %String(MAXLEN = 512) [ SqlComputeCode = {	
	Set {*} = {Host}_":"_{Port}
	}, SqlComputed, Transient ];

Storage Default
{
<Data name="UDPDefaultData">
<Subscript>"UDP"</Subscript>
<Value name="1">
<Value>Host</Value>
</Value>
<Value name="2">
<Value>Port</Value>
</Value>
<Value name="3">
<Value>UDPSenderCommand</Value>
</Value>
</Data>
<DefaultData>UDPDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
