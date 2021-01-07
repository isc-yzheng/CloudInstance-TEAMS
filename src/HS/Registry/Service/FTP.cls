Class HS.Registry.Service.FTP Extends HS.Registry.Service.FileType
{

Property Host As %String;

Property Port As %Integer;

Property UserCredentialsConfig As %String;

Property SSLConfig As %String;

Property UsePassive As %Boolean [ InitialExpression = 0 ];

Property Info As %String(MAXLEN = 512) [ SqlComputeCode = {	
	Set {*} = {Host}_":"_{Port}
	}, SqlComputed, Transient ];

Storage Default
{
<Data name="FTPDefaultData">
<Subscript>"FTP"</Subscript>
<Value name="1">
<Value>Host</Value>
</Value>
<Value name="2">
<Value>Port</Value>
</Value>
<Value name="3">
<Value>UserCredentialsConfig</Value>
</Value>
<Value name="4">
<Value>SSLConfig</Value>
</Value>
<Value name="5">
<Value>UsePassive</Value>
</Value>
</Data>
<DefaultData>FTPDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
