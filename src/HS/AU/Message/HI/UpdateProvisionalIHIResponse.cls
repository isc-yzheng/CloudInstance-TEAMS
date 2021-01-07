Class HS.AU.Message.HI.UpdateProvisionalIHIResponse Extends HS.AU.Message.CommonResponse [ ProcedureBlock ]
{

Parameter NAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumermessages/UpdateProvisionalIHI/3.0";

Parameter XMLNAME = "updateProvisionalIHIResponse";

Property Result As HS.AU.Message.HI.IHIResult(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumermessages/UpdateProvisionalIHI/3.0", XMLNAME = "updateProvisionalIHIResult", XMLREF = 1);

Storage Default
{
<Data name="UpdateProvisionalIHIResponseDefaultData">
<Subscript>"UpdateProvisionalIHIResponse"</Subscript>
<Value name="1">
<Value>Result</Value>
</Value>
</Data>
<DefaultData>UpdateProvisionalIHIResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
