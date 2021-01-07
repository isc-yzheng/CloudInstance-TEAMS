Class HS.AU.Message.SMD.DeliveryRequestBase Extends (Ens.Request, HS.Types.RequestInfo)
{

/// Identity of the target HPI-O - http://ns.electronichealth.net.au/id/hi/hpio/1.0/8003620000030515
Property Target As %String(MAXLEN = 250) [ Required ];

/// Identity of the sender HPI-O - http://ns.electronichealth.net.au/id/hi/hpio/1.0/8003620000030515
Property Sender As %String(MAXLEN = 250) [ Required ];

/// Service category (type of message)
Property ServiceCategory As %String(MAXLEN = 250) [ Required ];

Property PayloadObject As %Persistent(CLASSNAME = 1) [ Required ];

/// Optional Field:  Used as supporting information only
Property SenderIndividual As %String(MAXLEN = "");

/// Optional Field:  Used as supporting information only
Property ReceiverIndividual As %String(MAXLEN = "");

Property CreationTime As %TimeStamp [ InitialExpression = {$zdt($h,3,1)} ];

Property ExpiryTime As %TimeStamp [ InitialExpression = {$System.SQL.DATEADD("mi",5,$zdt($h,3,1))} ];

Property InvocationId As %String(MAXLEN = "") [ InitialExpression = {##class(%SOAP.Addressing.Properties).GetUniqueMessageId()} ];

Property Status As %String(VALUELIST = ",Pending,Acknowledged") [ InitialExpression = "Pending" ];

Index SendingInvocationIdIndex On (InvocationId, CreationTime, ExpiryTime);

Index SendingStatusIndex On Status [ Type = bitmap ];

Storage Default
{
<Data name="AdditionalInfo">
<Attribute>AdditionalInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"HS.AU.Message.SMD.DeliveryRequestBase.AdditionalInfo"</Subscript>
</Data>
<Data name="CustomAuditInfo">
<Attribute>CustomAuditInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"HS.AU.Message.SMD.DeliveryRequestBase.CustomAuditInfo"</Subscript>
</Data>
<Data name="DeliveryRequestBaseDefaultData">
<Subscript>"DeliveryRequestBase"</Subscript>
<Value name="1">
<Value>Target</Value>
</Value>
<Value name="2">
<Value>Sender</Value>
</Value>
<Value name="3">
<Value>ServiceCategory</Value>
</Value>
<Value name="4">
<Value>PayloadObject</Value>
</Value>
<Value name="5">
<Value>SenderIndividual</Value>
</Value>
<Value name="6">
<Value>ReceiverIndividual</Value>
</Value>
<Value name="7">
<Value>BreakTheGlass</Value>
</Value>
<Value name="8">
<Value>AuthBy</Value>
</Value>
<Value name="9">
<Value>AuthType</Value>
</Value>
<Value name="10">
<Value>BTGReason</Value>
</Value>
<Value name="11">
<Value>RequestingUserRoles</Value>
</Value>
<Value name="12">
<Value>RequestingForProxyUserID</Value>
</Value>
<Value name="13">
<Value>RequestingForProxyID</Value>
</Value>
<Value name="14">
<Value>Signature</Value>
</Value>
<Value name="15">
<Value>RequestId</Value>
</Value>
<Value name="16">
<Value>RequestingGateway</Value>
</Value>
<Value name="17">
<Value>Type</Value>
</Value>
<Value name="18">
<Value>SAMLData</Value>
</Value>
<Value name="19">
<Value>ClinicalTypes</Value>
</Value>
<Value name="20">
<Value>Consent</Value>
</Value>
<Value name="21">
<Value>RequestingUser</Value>
</Value>
<Value name="22">
<Value>CreationTime</Value>
</Value>
<Value name="23">
<Value>ExpiryTime</Value>
</Value>
<Value name="24">
<Value>InvocationId</Value>
</Value>
<Value name="25">
<Value>Status</Value>
</Value>
</Data>
<DefaultData>DeliveryRequestBaseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
