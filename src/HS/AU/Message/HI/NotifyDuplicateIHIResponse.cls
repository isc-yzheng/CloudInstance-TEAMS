Class HS.AU.Message.HI.NotifyDuplicateIHIResponse Extends HS.AU.Message.CommonResponse [ ProcedureBlock ]
{

// 

Parameter NAMESPACE = "http://ns.electronichealth.net.au/hi/svc/ConsumerNotifyDuplicateIHI/3.2.0";

Parameter XMLNAME = "notifyDuplicateIHIResponse";

Property Result As HS.AU.Message.HI.NotifyDuplicateIHIResult(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumermessages/NotifyDuplicateIHI/3.2.0", XMLNAME = "notifyDuplicateIHIResult", XMLREF = 1);

Storage Default
{
<Data name="NotifyDuplicateIHIResponseDefaultData">
<Subscript>"NotifyDuplicateIHIResponse"</Subscript>
<Value name="1">
<Value>Result</Value>
</Value>
</Data>
<DefaultData>NotifyDuplicateIHIResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
