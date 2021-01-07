/// 
Class HS.AU.Message.HI.NotifyReplicaIHIResponse Extends HS.AU.Message.CommonResponse [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumermessages/NotifyReplicaIHI/3.2.0";

Parameter XMLNAME = "notifyReplicaIHIResponse";

Property Result As HS.AU.Message.HI.IHIResult(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumermessages/NotifyReplicaIHI/3.2.0", XMLNAME = "notifyReplicaIHIResult", XMLREF = 1);

Storage Default
{
<Data name="NotifyReplicaIHIResponseDefaultData">
<Subscript>"NotifyReplicaIHIResponse"</Subscript>
<Value name="1">
<Value>Result</Value>
</Value>
</Data>
<DefaultData>NotifyReplicaIHIResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
