Class HS.AU.Types.SMD.MessageMetadataType Extends (%SerialObject, %XML.Adaptor)
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://ns.electronichealth.net.au/smd/xsd/SealedMessage/2010";

Parameter XMLNAME = "MessageMetadataType";

Parameter XMLSEQUENCE = 1;

Property CreationTime As %TimeStamp(XMLNAME = "creationTime");

Property ExpiryTime As %TimeStamp(XMLNAME = "expiryTime");

Property InvocationId As %String(MAXLEN = "", XMLNAME = "invocationId");

Property ReceiverIndividual As %xsd.anyURI(XMLNAME = "receiverIndividual");

Property ReceiverOrganisation As %xsd.anyURI(XMLNAME = "receiverOrganisation");

Property SenderIndividual As %xsd.anyURI(XMLNAME = "senderIndividual");

Property SenderOrganisation As %xsd.anyURI(XMLNAME = "senderOrganisation");

Property ServiceCategory As %xsd.anyURI(XMLNAME = "serviceCategory");

Property ServiceInterface As %xsd.anyURI(XMLNAME = "serviceInterface");

Property RouteRecord As list Of HS.AU.Types.SMD.RouteRecordEntryType(XMLNAME = "routeRecord", XMLPROJECTION = "ELEMENT");

Property OtherTransportMetadata As list Of HS.AU.Types.SMD.OtherTransportMetadataEntryType(XMLNAME = "otherTransportMetadata", XMLPROJECTION = "ELEMENT");

Storage Default
{
<Data name="MessageMetadataTypeState">
<Value name="1">
<Value>CreationTime</Value>
</Value>
<Value name="2">
<Value>ExpiryTime</Value>
</Value>
<Value name="3">
<Value>InvocationId</Value>
</Value>
<Value name="4">
<Value>ReceiverIndividual</Value>
</Value>
<Value name="5">
<Value>ReceiverOrganisation</Value>
</Value>
<Value name="6">
<Value>SenderIndividual</Value>
</Value>
<Value name="7">
<Value>SenderOrganisation</Value>
</Value>
<Value name="8">
<Value>ServiceCategory</Value>
</Value>
<Value name="9">
<Value>ServiceInterface</Value>
</Value>
<Value name="10">
<Value>RouteRecord</Value>
</Value>
<Value name="11">
<Value>OtherTransportMetadata</Value>
</Value>
</Data>
<State>MessageMetadataTypeState</State>
<StreamLocation>^HS.AU.TypesB46.MessageMeta8BCES</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
