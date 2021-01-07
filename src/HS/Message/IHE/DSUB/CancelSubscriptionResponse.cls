Class HS.Message.IHE.DSUB.CancelSubscriptionResponse Extends (HS.Util.EnsResponse, HS.Message.XMLMessage) [ ClassType = persistent, Inheritance = right, ProcedureBlock ]
{

Property Errors As HS.Types.IHE.Errors;

Storage Default
{
<Data name="AdditionalInfo">
<Attribute>AdditionalInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"HS.Message.IHE.DSUB.CancelSubscriptionResponse.AdditionalInfo"</Subscript>
</Data>
<Data name="CancelSubscriptionResponseDefaultData">
<Subscript>"CancelSubscriptionResponse"</Subscript>
<Value name="1">
<Value>Errors</Value>
</Value>
<Value name="2">
<Value>DocType</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>ContentStream</Value>
</Value>
<Value name="5">
<Value>StreamCollection</Value>
</Value>
<Value name="6">
<Value>SOAPFault</Value>
</Value>
<Value name="7">
<Value>SAMLData</Value>
</Value>
<Value name="8">
<Value>UseQuickStream</Value>
</Value>
</Data>
<Data name="CustomAuditInfo">
<Attribute>CustomAuditInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"HS.Message.IHE.DSUB.CancelSubscriptionResponse.CustomAuditInfo"</Subscript>
</Data>
<DefaultData>CancelSubscriptionResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
