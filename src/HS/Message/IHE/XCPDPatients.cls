Class HS.Message.IHE.XCPDPatients Extends (HS.Util.EnsResponse, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

Property Patients As list Of HS.Message.IHE.XCPDPatient;

Storage Default
{
<Data name="XCPDPatientsDefaultData">
<Subscript>"XCPDPatients"</Subscript>
<Value name="1">
<Value>Patients</Value>
</Value>
</Data>
<DefaultData>XCPDPatientsDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
