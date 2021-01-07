Class HS.AU.Types.SMD.TransportResponseMetadataType Extends (%SerialObject, %XML.Adaptor)
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://ns.electronichealth.net.au/smd/xsd/TransportResponse/2010";

Parameter XMLNAME = "TransportResponseMetadataType";

Parameter XMLSEQUENCE = 1;

Property TransportResponseTime As %TimeStamp(XMLNAME = "transportResponseTime");

Property ResponseId As %xsd.anyURI(XMLNAME = "responseId");

Property SourceOrganisation As %xsd.anyURI(XMLNAME = "sourceOrganisation");

Property ServiceCategory As %xsd.anyURI(XMLNAME = "serviceCategory");

Property InvocationId As %xsd.anyURI(XMLNAME = "invocationId");

Property ReceiverOrganisation As %xsd.anyURI(XMLNAME = "receiverOrganisation");

Property SenderOrganisation As %xsd.anyURI(XMLNAME = "senderOrganisation");

Property OtherTransportMetadata As list Of HS.AU.Types.SMD.OtherTransportMetadataEntryType(XMLNAME = "otherTransportMetadata", XMLPROJECTION = "ELEMENT");

Storage Default
{
<Data name="TransportResponseMetadataTypeState">
<Value name="1">
<Value>TransportResponseTime</Value>
</Value>
<Value name="2">
<Value>ResponseId</Value>
</Value>
<Value name="3">
<Value>SourceOrganisation</Value>
</Value>
<Value name="4">
<Value>ServiceCategory</Value>
</Value>
<Value name="5">
<Value>InvocationId</Value>
</Value>
<Value name="6">
<Value>ReceiverOrganisation</Value>
</Value>
<Value name="7">
<Value>SenderOrganisation</Value>
</Value>
<Value name="8">
<Value>OtherTransportMetadata</Value>
</Value>
</Data>
<State>TransportResponseMetadataTypeState</State>
<StreamLocation>^HS.AU.TypesB46.TransportReDAB7S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
