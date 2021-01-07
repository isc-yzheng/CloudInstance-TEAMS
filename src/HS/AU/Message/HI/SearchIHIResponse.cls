Class HS.AU.Message.HI.SearchIHIResponse Extends HS.AU.Message.CommonResponse [ ClassType = persistent, ProcedureBlock ]
{

Parameter NAMESPACE = "http://ns.electronichealth.net.au/hi/svc/ConsumerSearchIHI/3.0";

Parameter XMLNAME = "searchIHIResponse";

Property Result As HS.AU.Message.HI.SearchIHIResult(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumermessages/SearchIHI/3.0", XMLNAME = "searchIHIResult", XMLREF = 1);

Storage Default
{
<Data name="SearchIHIResponseDefaultData">
<Subscript>"SearchIHIResponse"</Subscript>
<Value name="1">
<Value>Result</Value>
</Value>
</Data>
<DefaultData>SearchIHIResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
