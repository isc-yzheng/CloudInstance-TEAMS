Class HS.IHE.Common.Services.SOAPServer.RequestLog Extends %Persistent
{

Property ServiceName As %String;

Property RequestDateTime As %TimeStamp;

Property RequestDenied As %Boolean [ InitialExpression = 0 ];

Property UserName As %String;

Property IPAddress As %String;

Index UserNameIndex On (ServiceName, RequestDateTime, UserName) [ Type = index ];

Index IPAddressIndex On (ServiceName, RequestDateTime, IPAddress) [ Type = index ];

Storage Default
{
<Data name="RequestLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ServiceName</Value>
</Value>
<Value name="3">
<Value>RequestDateTime</Value>
</Value>
<Value name="4">
<Value>RequestDenied</Value>
</Value>
<Value name="5">
<Value>UserName</Value>
</Value>
<Value name="6">
<Value>IPAddress</Value>
</Value>
</Data>
<DataLocation>^HS.IHE.Common.SCA00.RequestLogD</DataLocation>
<DefaultData>RequestLogDefaultData</DefaultData>
<IdLocation>^HS.IHE.Common.SCA00.RequestLogD</IdLocation>
<IndexLocation>^HS.IHE.Common.SCA00.RequestLogI</IndexLocation>
<StreamLocation>^HS.IHE.Common.SCA00.RequestLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
