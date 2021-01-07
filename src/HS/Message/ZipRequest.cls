Class HS.Message.ZipRequest Extends (HS.Util.EnsRequest, HS.Types.Zip)
{

Parameter RESPONSECLASSNAME = "HS.Message.ZipResponse";

Storage Default
{
<Data name="ZipRequestDefaultData">
<Subscript>"ZipRequest"</Subscript>
<Value name="1">
<Value>Items</Value>
</Value>
<Value name="2">
<Value>File</Value>
</Value>
<Value name="3">
<Value>Operation</Value>
</Value>
</Data>
<DefaultData>ZipRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
