Class HS.AU.Message.HI.UpdateIHIResponse Extends HS.AU.Message.CommonResponse [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumermessages/UpdateIHI/3.2.0";

Parameter XMLNAME = "notifyReplicaIHIResponse";

Property Result As HS.AU.Message.HI.IHIResult(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumermessages/UpdateIHI/3.2.0", XMLNAME = "updateIHIResult", XMLREF = 1);

Storage Default
{
<Data name="UpdateIHIResponseDefaultData">
<Subscript>"UpdateIHIResponse"</Subscript>
<Value name="1">
<Value>Result</Value>
</Value>
</Data>
<DefaultData>UpdateIHIResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
