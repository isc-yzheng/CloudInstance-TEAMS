Class HS.Registry.Service.TCP Extends HS.Registry.Service.Abstract
{

Property Host As %String(MAXLEN = 150);

Property Port As %Integer;

Property SSLConfig As %String;

/// [Previously notinheritable]
Property StayConnected As %Boolean;

Property Info As %String(MAXLEN = 512) [ SqlComputeCode = {	
	Set {*} = {Host}_":"_{Port}
	}, SqlComputed, Transient ];

Storage Default
{
<Data name="TCPDefaultData">
<Subscript>"TCP"</Subscript>
<Value name="1">
<Value>Host</Value>
</Value>
<Value name="2">
<Value>Port</Value>
</Value>
<Value name="3">
<Value>SSLConfig</Value>
</Value>
<Value name="4">
<Value>StayConnected</Value>
</Value>
</Data>
<DefaultData>TCPDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
