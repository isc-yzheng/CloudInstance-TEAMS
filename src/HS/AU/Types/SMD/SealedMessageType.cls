Class HS.AU.Types.SMD.SealedMessageType Extends (%SerialObject, %XML.Adaptor)
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "SealedMessageType";

Parameter XMLSEQUENCE = 1;

Property Metadata As HS.AU.Types.SMD.MessageMetadataType(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/smd/xsd/SealedMessage/2010", XMLNAME = "metadata", XMLREF = 1);

Property EncryptedPayload As HS.AU.SMD.EncryptedPayloadType(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/xsp/xsd/EncryptedPayload/2010", XMLNAME = "encryptedPayload", XMLREF = 1);

Storage Default
{
<Data name="SealedMessageTypeState">
<Value name="1">
<Value>Metadata</Value>
</Value>
<Value name="2">
<Value>EncryptedPayload</Value>
</Value>
</Data>
<State>SealedMessageTypeState</State>
<StreamLocation>^HS.AU.TypesB46.SealedMessa2F4DS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
