Class HS.Message.IHE.XCPDPatient Extends (%SerialObject, HS.Types.Identifier, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

Property HomeCommunityId As %String(MAXLEN = 73);

Property AdditionalInfo As array Of %String(MAXLEN = 1024, XMLPROJECTION = "NONE");

Storage Default
{
<Data name="XCPDPatientState">
<Value name="1">
<Value>HomeCommunityId</Value>
</Value>
<Value name="2">
<Value>AdditionalInfo</Value>
</Value>
<Value name="3">
<Value>Extension</Value>
</Value>
<Value name="4">
<Value>AssigningAuthorityName</Value>
</Value>
<Value name="5">
<Value>Use</Value>
</Value>
<Value name="6">
<Value>Status</Value>
</Value>
<Value name="7">
<Value>Type</Value>
</Value>
<Value name="8">
<Value>Root</Value>
</Value>
</Data>
<State>XCPDPatientState</State>
<StreamLocation>^HS.Message.IHE.XCPDPatientS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
