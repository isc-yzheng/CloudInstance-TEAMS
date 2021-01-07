Class HS.AU.Message.PCEHR.GainPCEHRAccessResponse Extends HS.AU.Message.CommonResponse [ ProcedureBlock ]
{

Parameter NAMESPACE = "http://ns.electronichealth.net.au/pcehr/xsd/interfaces/PCEHRProfile/1.0";

Parameter XMLNAME = "gainPCEHRAccessResponse";

Property ResponseStatus As HS.AU.Types.PCEHR.ResponseStatusType(XMLNAME = "responseStatus");

Property Individual As HS.AU.Types.PCEHR.Individual1(XMLNAME = "individual");

Storage Default
{
<Data name="GainPCEHRAccessResponseDefaultData">
<Subscript>"GainPCEHRAccessResponse"</Subscript>
<Value name="1">
<Value>ResponseStatus</Value>
</Value>
<Value name="2">
<Value>Individual</Value>
</Value>
</Data>
<DefaultData>GainPCEHRAccessResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
