Class HS.AU.Message.HI.MergeProvisionalIHIRequest Extends HS.AU.Message.CommonRequest [ ProcedureBlock ]
{

Parameter XMLNAME = "mergeProvisionalIHI";

Parameter NAMESPACE = "http://ns.electronichealth.net.au/hi/svc/ConsumerMergeProvisionalIHI/3.0";

Parameter RESPONSECLASSNAME = "HS.AU.Message.HI.MergeProvisionalIHIResponse";

Property IHINumber As list Of %String(MAXLEN = "", MINLEN = 1, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumercore/ConsumerCoreElements/3.0", XMLNAME = "ihiNumber", XMLPROJECTION = "element", XMLREF = 1);

Storage Default
{
<Data name="MergeProvisionalIHIRequestDefaultData">
<Subscript>"MergeProvisionalIHIRequest"</Subscript>
<Value name="1">
<Value>IHINumber</Value>
</Value>
</Data>
<DefaultData>MergeProvisionalIHIRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
