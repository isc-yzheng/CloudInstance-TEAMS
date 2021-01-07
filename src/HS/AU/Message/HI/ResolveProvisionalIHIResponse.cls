Class HS.AU.Message.HI.ResolveProvisionalIHIResponse Extends HS.AU.Message.CommonResponse [ ProcedureBlock ]
{

Parameter NAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumermessages/ResolveProvisionalIHI/3.0";

Parameter XMLNAME = "resolveProvisionalIHIResponse";

Property Result As HS.AU.Message.HI.IHIResult(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumermessages/ResolveProvisionalIHI/3.0", XMLNAME = "resolveProvisionalIHIResult", XMLREF = 1);

Storage Default
{
<Data name="ResolveProvisionalIHIResponseDefaultData">
<Subscript>"ResolveProvisionalIHIResponse"</Subscript>
<Value name="1">
<Value>Result</Value>
</Value>
</Data>
<DefaultData>ResolveProvisionalIHIResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
