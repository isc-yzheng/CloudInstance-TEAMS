Class HS.Message.GatewayRegistrationRequest Extends (HS.Util.EnsRequest, HS.Types.GatewayInfo) [ ClassType = persistent, Inheritance = right, ProcedureBlock ]
{

/// Default response class
Parameter RESPONSECLASSNAME As %String = "HS.Message.GatewayRegistrationResponse";

Property SYNCINFO As %String(MAXLEN = "") [ InitialExpression = {$namespace_"."_##class(%SYS.System).InstanceGUID()} ];

Storage Default
{
<Data name="GatewayRegistrationRequestDefaultData">
<Subscript>"GatewayRegistrationRequest"</Subscript>
<Value name="1">
<Value>EndPoint</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Status</Value>
</Value>
<Value name="4">
<Value>RegistrationTime</Value>
</Value>
<Value name="5">
<Value>OID</Value>
</Value>
<Value name="6">
<Value>Type</Value>
</Value>
<Value name="7">
<Value>SYNCINFO</Value>
</Value>
<Value name="8">
<Value>ConsumeAndForward</Value>
</Value>
<Value name="9">
<Value>CacheType</Value>
</Value>
<Value name="10">
<Value>FeedAnalytics</Value>
</Value>
<Value name="11">
<Value>Version</Value>
</Value>
</Data>
<DefaultData>GatewayRegistrationRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
