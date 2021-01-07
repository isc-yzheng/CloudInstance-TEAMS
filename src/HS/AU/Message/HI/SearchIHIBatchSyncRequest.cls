Class HS.AU.Message.HI.SearchIHIBatchSyncRequest Extends HS.AU.Message.CommonRequest [ ProcedureBlock ]
{

Parameter RESPONSECLASSNAME = "HS.AU.Message.HI.SearchIHIBatchSyncResponse";

Parameter XMLTYPE = "searchIHIBatchSync";

Parameter NAMESPACE = "http://ns.electronichealth.net.au/hi/svc/ConsumerSearchIHIBatchSyncRequest/3.0";

Property BatchIdentifier As %String(MAXLEN = 36, MINLEN = 36, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumermessages/SearchIHIBatch/3.0", XMLNAME = "batchIdentifier");

Property SearchIHIBatchRequest As list Of HS.AU.Types.HI.SearchIHIRequestType(REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumermessages/SearchIHIBatch/3.0", STORAGEDEFAULT = "array", XMLNAME = "searchIHIBatchRequest", XMLPROJECTION = "ELEMENT", XMLREF = 1);

Storage Default
{
<Data name="SearchIHIBatchRequest">
<Attribute>SearchIHIBatchRequest</Attribute>
<Structure>subnode</Structure>
<Subscript>"HS.AU.Message.HI.SearchIHIBatchSyncRequest.SearchIHIBatchRequest"</Subscript>
</Data>
<Data name="SearchIHIBatchSyncRequestDefaultData">
<Subscript>"SearchIHIBatchSyncRequest"</Subscript>
<Value name="1">
<Value>BatchIdentifier</Value>
</Value>
</Data>
<DefaultData>SearchIHIBatchSyncRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
