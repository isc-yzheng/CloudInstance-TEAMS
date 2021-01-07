Class HS.AU.Types.SMD.OtherTransportMetadataEntryType Extends (%SerialObject, %XML.Adaptor)
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://ns.electronichealth.net.au/smd/xsd/SealedMessage/2010";

Parameter XMLNAME = "OtherTransportMetadataEntryType";

Parameter XMLSEQUENCE = 1;

Property MetadataType As %xsd.anyURI(XMLNAME = "metadataType");

Property MetadataValue As %String(MAXLEN = "", XMLNAME = "metadataValue");

Storage Default
{
<Data name="OtherTransportMetadataEntryTypeState">
<Value name="1">
<Value>MetadataType</Value>
</Value>
<Value name="2">
<Value>MetadataValue</Value>
</Value>
</Data>
<State>OtherTransportMetadataEntryTypeState</State>
<StreamLocation>^HS.AU.TypesB46.OtherTransp55E9S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
