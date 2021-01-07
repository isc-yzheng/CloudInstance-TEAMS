Class HS.AU.Message.HI.MergeProvisionalIHIResponse Extends HS.AU.Message.CommonResponse [ ProcedureBlock ]
{

Parameter NAMESPACE = "http://ns.electronichealth.net.au/hi/svc/ConsumerMergeProvisionalIHI/3.0";

Parameter XMLNAME = "mergeProvisionalIHIResponse";

Property Result As HS.AU.Message.HI.IHIResult(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumermessages/MergeProvisionalIHI/3.0", XMLNAME = "mergeProvisionalIHIResult", XMLREF = 1);

Storage Default
{
<Data name="MergeProvisionalIHIResponseDefaultData">
<Subscript>"MergeProvisionalIHIResponse"</Subscript>
<Value name="1">
<Value>Result</Value>
</Value>
</Data>
<DefaultData>MergeProvisionalIHIResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
