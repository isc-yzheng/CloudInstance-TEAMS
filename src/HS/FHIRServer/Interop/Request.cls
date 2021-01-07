Class HS.FHIRServer.Interop.Request Extends HS.Util.EnsRequest [ StorageStrategy = "" ]
{

Property Request As HS.FHIRServer.API.Data.Request;

Property QuickStreamId As %String;

Parameter RESPONSECLASSNAME As %String = "HS.FHIRServer.Interop.Response";

Storage Default
{
<Data name="RequestDefaultData">
<Subscript>"Request"</Subscript>
<Value name="1">
<Value>Request</Value>
</Value>
<Value name="2">
<Value>QuickStreamId</Value>
</Value>
</Data>
<DefaultData>RequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
