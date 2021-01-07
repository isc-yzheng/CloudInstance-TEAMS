Class HS.FHIRServer.Interop.Response Extends HS.Util.EnsResponse [ StorageStrategy = "" ]
{

Property Response As HS.FHIRServer.API.Data.Response;

Property QuickStreamId As %String;

Property CharSet As %String;

Property ContentType As %String;

Storage Default
{
<Data name="ResponseDefaultData">
<Subscript>"Response"</Subscript>
<Value name="1">
<Value>Response</Value>
</Value>
<Value name="2">
<Value>QuickStreamId</Value>
</Value>
<Value name="3">
<Value>CharSet</Value>
</Value>
<Value name="4">
<Value>ContentType</Value>
</Value>
</Data>
<DefaultData>ResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
