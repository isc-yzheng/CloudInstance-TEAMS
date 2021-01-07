Class HS.AU.Message.HI.SearchIHIBatchSyncResponse Extends HS.AU.Message.CommonResponse [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://ns.electronichealth.net.au/hi/svc/ConsumerSearchIHIBatchSyncRequest/3.0";

Parameter XMLNAME = "searchIHIBatchResponse";

Property Result As list Of HS.AU.Types.HI.SearchIHIResponseType(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/svc/ConsumerSearchIHIBatchSyncRequest/3.0", STORAGEDEFAULT = "array", XMLNAME = "searchIHIBatchResult", XMLPROJECTION = "ELEMENT", XMLREF = 1);

Property BatchIdentifier As %String(MAXLEN = 36, MINLEN = 36, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumermessages/SearchIHIBatch/3.0", XMLNAME = "batchIdentifier", XMLREF = 1);

Storage Default
{
<Data name="Result">
<Attribute>Result</Attribute>
<Structure>subnode</Structure>
<Subscript>"HS.AU.Message.HI.SearchIHIBatchSyncResponse.Result"</Subscript>
</Data>
<Data name="SearchIHIBatchSyncResponseDefaultData">
<Subscript>"SearchIHIBatchSyncResponse"</Subscript>
<Value name="1">
<Value>BatchIdentifier</Value>
</Value>
<Value name="2">
<Value>XXX</Value>
</Value>
</Data>
<DefaultData>SearchIHIBatchSyncResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
