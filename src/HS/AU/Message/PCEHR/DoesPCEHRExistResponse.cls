Class HS.AU.Message.PCEHR.DoesPCEHRExistResponse Extends HS.AU.Message.CommonResponse [ ProcedureBlock ]
{

Parameter NAMESPACE = "http://ns.electronichealth.net.au/pcehr/xsd/interfaces/PCEHRProfile/1.0";

Parameter XMLNAME = "doesPCEHRExistResponse";

Property PCEHRExists As %Boolean;

Property AccessCodeRequired As %String(XMLNAME = "accessCodeRequired");

Storage Default
{
<Data name="DoesPCEHRExistResponseDefaultData">
<Subscript>"DoesPCEHRExistResponse"</Subscript>
<Value name="1">
<Value>PCEHRExists</Value>
</Value>
<Value name="2">
<Value>AccessCodeRequired</Value>
</Value>
</Data>
<DefaultData>DoesPCEHRExistResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
