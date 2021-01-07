/// Request object which will be used with a transformation to produce a valid query for the XDSb.Registry
Class HS.Message.IHE.DSUB.SubscriptionResponse Extends (HS.Util.EnsResponse, HS.Message.XMLMessage) [ ClassType = persistent, Inheritance = right, ProcedureBlock ]
{

Property SubscriptionID As %String(MAXLEN = "");

Property CancellationAddress As %String(MAXLEN = "");

Property TerminationTime As %String;

Property Errors As HS.Types.IHE.Errors;

Storage Default
{
<Data name="AdditionalInfo">
<Attribute>AdditionalInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"HS.Message.IHE.DSUB.SubscriptionResponse.AdditionalInfo"</Subscript>
</Data>
<Data name="CustomAuditInfo">
<Attribute>CustomAuditInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"HS.Message.IHE.DSUB.SubscriptionResponse.CustomAuditInfo"</Subscript>
</Data>
<Data name="SubscriptionResponseDefaultData">
<Subscript>"SubscriptionResponse"</Subscript>
<Value name="1">
<Value>SubscriptionID</Value>
</Value>
<Value name="2">
<Value>CancellationAddress</Value>
</Value>
<Value name="3">
<Value>DocType</Value>
</Value>
<Value name="4">
<Value>Name</Value>
</Value>
<Value name="5">
<Value>ContentStream</Value>
</Value>
<Value name="6">
<Value>StreamCollection</Value>
</Value>
<Value name="7">
<Value>SOAPFault</Value>
</Value>
<Value name="8">
<Value>SAMLData</Value>
</Value>
<Value name="9">
<Value>Errors</Value>
</Value>
<Value name="10">
<Value>UseQuickStream</Value>
</Value>
<Value name="11">
<Value>TerminationTime</Value>
</Value>
</Data>
<DefaultData>SubscriptionResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
