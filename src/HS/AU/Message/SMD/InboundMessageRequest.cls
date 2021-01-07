/// This class represents a message that has been Received through the SMD messaging gateway
/// 
Class HS.AU.Message.SMD.InboundMessageRequest Extends Ens.Request
{

/// This property is for incoming messages only
Property ReceivedTime As %TimeStamp [ InitialExpression = {$zdt($h,3)} ];

/// This is the payload extracted from the inbound message
Property PayloadStream As %Stream.GlobalBinary;

Property Synchronous As %Boolean [ InitialExpression = 0 ];

Property Status As %String;

Property Metadata As HS.AU.Types.SMD.MessageMetadataType(XMLNAME = "metadata") [ Required ];

Property EncryptedPayload As HS.AU.SMD.EncryptedPayloadType(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/xsp/xsd/EncryptedPayload/2010", XMLNAME = "encryptedPayload", XMLREF = 1) [ Required ];

Property DigestValue As %xsd.base64Binary;

Property X509Credentials As %String(MAXLEN = "");

Index InvocationIdIndex On (Metadata.InvocationId, Metadata.CreationTime, Metadata.ExpiryTime);

Storage Default
{
<Data name="InboundMessageRequestDefaultData">
<Subscript>"InboundMessageRequest"</Subscript>
<Value name="1">
<Value>ReceivedTime</Value>
</Value>
<Value name="2">
<Value>PayloadStream</Value>
</Value>
<Value name="3">
<Value>Synchronous</Value>
</Value>
<Value name="4">
<Value>Status</Value>
</Value>
<Value name="5">
<Value>Metadata</Value>
</Value>
<Value name="6">
<Value>EncryptedPayload</Value>
</Value>
<Value name="7">
<Value>Signatures</Value>
</Value>
<Value name="8">
<Value>DigestValue</Value>
</Value>
<Value name="9">
<Value>X509Credentials</Value>
</Value>
</Data>
<DefaultData>InboundMessageRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
