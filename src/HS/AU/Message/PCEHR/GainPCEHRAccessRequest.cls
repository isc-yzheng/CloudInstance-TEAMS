Class HS.AU.Message.PCEHR.GainPCEHRAccessRequest Extends HS.AU.Message.CommonRequest [ ProcedureBlock ]
{

Parameter XMLNAME = "gainPCEHRAccess";

Property SAMLData As HS.AU.PCEHR.SecurityHeader.Data;

Parameter NAMESPACE = "http://ns.electronichealth.net.au/pcehr/xsd/interfaces/PCEHRProfile/1.0";

Parameter RESPONSECLASSNAME = "HS.AU.Message.PCEHR.GainPCEHRAccessResponse";

Property PCEHRRecord As HS.AU.Types.PCEHR.PersonRecord;

Storage Default
{
<Data name="AdditionalInfo">
<Attribute>AdditionalInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"HS.AU.Message.PCEHR.GainPCEHRAccessRequest.AdditionalInfo"</Subscript>
</Data>
<Data name="GainPCEHRAccessRequestDefaultData">
<Subscript>"GainPCEHRAccessRequest"</Subscript>
<Value name="1">
<Value>SAMLData</Value>
</Value>
<Value name="2">
<Value>PCEHRRecord</Value>
</Value>
<Value name="3">
<Value>HSCoreVersion</Value>
</Value>
<Value name="4">
<Value>HSMinVersion</Value>
</Value>
</Data>
<DefaultData>GainPCEHRAccessRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
