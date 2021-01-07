Class HS.AU.Message.HI.CreateProvisionalIHIResponse Extends HS.AU.Message.CommonResponse [ ProcedureBlock ]
{

Parameter NAMESPACE = "http://ns.electronichealth.net.au/hi/svc/ConsumerCreateProvisionalIHI/3.0";

Parameter XMLNAME = "createProvisionalIHIResponse";

Property Result As HS.AU.Message.HI.IHIResult(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumermessages/CreateProvisionalIHI/3.0", XMLNAME = "createProvisionalIHIResult", XMLREF = 1);

Storage Default
{
<Data name="CreateProvisionalIHIResponseDefaultData">
<Subscript>"CreateProvisionalIHIResponse"</Subscript>
<Value name="1">
<Value>Result</Value>
</Value>
</Data>
<DefaultData>CreateProvisionalIHIResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
