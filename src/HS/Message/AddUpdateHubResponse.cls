Class HS.Message.AddUpdateHubResponse Extends HS.Util.EnsResponse
{

Property ErrStatus As %Status;

Property MPIID As %String;

Property Subscriptions As list Of HS.Types.SubscriptionSerialInfo;

/// The patient analytics ID so push processing of analytics filters doesn't need to look it up separately.
/// Only set when there is a subscription with analytics filters.
Property HSAAID As %String(MAXLEN = 220);

Storage Default
{
<Data name="AddUpdateHubResponseDefaultData">
<Subscript>"AddUpdateHubResponse"</Subscript>
<Value name="1">
<Value>Status</Value>
</Value>
<Value name="2">
<Value>ErrStatus</Value>
</Value>
<Value name="3">
<Value>MPIID</Value>
</Value>
<Value name="4">
<Value>Subscriptions</Value>
</Value>
<Value name="5">
<Value>HSAAID</Value>
</Value>
</Data>
<DefaultData>AddUpdateHubResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
