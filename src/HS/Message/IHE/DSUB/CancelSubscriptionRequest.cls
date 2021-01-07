Class HS.Message.IHE.DSUB.CancelSubscriptionRequest Extends (HS.Util.EnsRequest, HS.Types.RequestInfo)
{

Property SubscriptionID As %String(MAXLEN = 255);

Storage Default
{
<Data name="AdditionalInfo">
<Attribute>AdditionalInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"HS.Message.IHE.DSUB.CancelSubscriptionRequest.AdditionalInfo"</Subscript>
</Data>
<Data name="CancelSubscriptionRequestDefaultData">
<Subscript>"CancelSubscriptionRequest"</Subscript>
<Value name="1">
<Value>BreakTheGlass</Value>
</Value>
<Value name="2">
<Value>AuthBy</Value>
</Value>
<Value name="3">
<Value>AuthType</Value>
</Value>
<Value name="4">
<Value>BTGReason</Value>
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
<Value>ClinicalTypes</Value>
</Value>
<Value name="14">
<Value>Consent</Value>
</Value>
<Value name="15">
<Value>RequestingUser</Value>
</Value>
<Value name="16">
<Value>SubscriptionID</Value>
</Value>
</Data>
<Data name="CustomAuditInfo">
<Attribute>CustomAuditInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"HS.Message.IHE.DSUB.CancelSubscriptionRequest.CustomAuditInfo"</Subscript>
</Data>
<DefaultData>CancelSubscriptionRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
