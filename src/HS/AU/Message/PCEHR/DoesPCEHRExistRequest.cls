Class HS.AU.Message.PCEHR.DoesPCEHRExistRequest Extends HS.AU.Message.CommonRequest [ ProcedureBlock ]
{

Parameter XMLNAME = "doesPCEHRExist";

Property SAMLData As HS.AU.PCEHR.SecurityHeader.Data;

Parameter NAMESPACE = "http://ns.electronichealth.net.au/pcehr/xsd/interfaces/PCEHRProfile/1.0";

Parameter RESPONSECLASSNAME = "HS.AU.Message.PCEHR.DoesPCEHRExistResponse";

Storage Default
{
<Data name="AdditionalInfo">
<Attribute>AdditionalInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"HS.AU.Message.PCEHR.DoesPCEHRExistRequest.AdditionalInfo"</Subscript>
</Data>
<Data name="DoesPCEHRExistRequestDefaultData">
<Subscript>"DoesPCEHRExistRequest"</Subscript>
<Value name="1">
<Value>SAMLData</Value>
</Value>
</Data>
<DefaultData>DoesPCEHRExistRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
