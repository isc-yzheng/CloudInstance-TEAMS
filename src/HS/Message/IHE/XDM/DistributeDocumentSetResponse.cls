Class HS.Message.IHE.XDM.DistributeDocumentSetResponse Extends HS.Message.XMLMessage
{

Property Files As HS.Message.ZipRequest;

Property Status As %Status;

Storage Default
{
<Data name="DistributeDocumentSetResponseDefaultData">
<Subscript>"DistributeDocumentSetResponse"</Subscript>
<Value name="1">
<Value>Files</Value>
</Value>
<Value name="2">
<Value>Status</Value>
</Value>
</Data>
<DefaultData>DistributeDocumentSetResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
