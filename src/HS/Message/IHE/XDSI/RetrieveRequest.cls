Class HS.Message.IHE.XDSI.RetrieveRequest Extends (HS.Util.EnsRequest, HS.Types.RequestInfo) [ ClassType = persistent, Inheritance = right, ProcedureBlock ]
{

Parameter XMLTYPE = "XDSI-RetrieveRequest";

Parameter RESPONSECLASSNAME = "HS.Message.IHE.XDSI.RetrieveResponse";

Property Studies As list Of HS.Message.IHE.XDSI.StudyRequest;

Property TransferSyntaxes As list Of %String(XMLITEMNAME = "TransferSyntax");

Storage Default
{
<Data name="AdditionalInfo">
<Attribute>AdditionalInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"HS.Message.IHE.XDSI.RetrieveRequest.AdditionalInfo"</Subscript>
</Data>
<Data name="CustomAuditInfo">
<Attribute>CustomAuditInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"HS.Message.IHE.XDSI.RetrieveRequest.CustomAuditInfo"</Subscript>
</Data>
<Data name="RetrieveRequestDefaultData">
<Subscript>"RetrieveRequest"</Subscript>
<Value name="1">
<Value>AuthBy</Value>
</Value>
<Value name="2">
<Value>AuthType</Value>
</Value>
<Value name="3">
<Value>BTGReason</Value>
</Value>
<Value name="4">
<Value>RequestingUser</Value>
</Value>
<Value name="5">
<Value>RequestingUserRoles</Value>
</Value>
<Value name="6">
<Value>RequestingForProxyUserID</Value>
</Value>
<Value name="7">
<Value>RequestingForProxyID</Value>
</Value>
<Value name="8">
<Value>Signature</Value>
</Value>
<Value name="9">
<Value>RequestId</Value>
</Value>
<Value name="10">
<Value>RequestingGateway</Value>
</Value>
<Value name="11">
<Value>Type</Value>
</Value>
<Value name="12">
<Value>SAMLData</Value>
</Value>
<Value name="13">
<Value>BreakTheGlass</Value>
</Value>
<Value name="14">
<Value>ClinicalTypes</Value>
</Value>
<Value name="15">
<Value>Consent</Value>
</Value>
<Value name="16">
<Value>Studies</Value>
</Value>
<Value name="17">
<Value>TransferSyntaxes</Value>
</Value>
</Data>
<DefaultData>RetrieveRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
