/// 
Class HS.AU.Message.HI.CreateUnverifiedIHIResponse Extends HS.AU.Message.CommonResponse [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumermessages/CreateUnverifiedIHI/3.0";

Parameter XMLNAME = "createUnverifiedIHIResponse";

Property Result As HS.AU.Message.HI.IHIResult(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumermessages/CreateUnverifiedIHI/3.0", XMLNAME = "createUnverifiedIHIResult", XMLREF = 1);

Storage Default
{
<Data name="CreateUnverifiedIHIResponseDefaultData">
<Subscript>"CreateUnverifiedIHIResponse"</Subscript>
<Value name="1">
<Value>Result</Value>
</Value>
</Data>
<DefaultData>CreateUnverifiedIHIResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
