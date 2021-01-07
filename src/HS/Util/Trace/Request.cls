Class HS.Util.Trace.Request Extends HS.Util.EnsRequest
{

Property CurrentClass As %String(MAXLEN = 128);

Property CurrentMethod As %String(MAXLEN = 255);

Property Comment As %String(MAXLEN = 2048);

Property Items As list Of Item;

Storage Default
{
<Data name="RequestDefaultData">
<Subscript>"Request"</Subscript>
<Value name="1">
<Value>Triples</Value>
</Value>
<Value name="2">
<Value>Comment</Value>
</Value>
<Value name="3">
<Value>CurrentClass</Value>
</Value>
<Value name="4">
<Value>CurrentMethod</Value>
</Value>
<Value name="5">
<Value>Items</Value>
</Value>
</Data>
<DefaultData>RequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
