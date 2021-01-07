/// Must extend HS.AU.SMD.BaseDataType first, otherwise correlate for signedPayloadData will fail
Class HS.AU.Message.SMD.MessageType Extends (%Persistent, HS.AU.SMD.BaseDataType, %XML.Adaptor)
{

Parameter XMLNAME = "MessageType";

Parameter XMLSEQUENCE = 1;

Property Data As %GlobalBinaryStream(XMLNAME = "data") [ Required ];

Storage Default
{
<Data name="MessageTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Data</Value>
</Value>
</Data>
<DataLocation>^HS.AU.Message.SMD.MessageTypeD</DataLocation>
<DefaultData>MessageTypeDefaultData</DefaultData>
<IdLocation>^HS.AU.Message.SMD.MessageTypeD</IdLocation>
<IndexLocation>^HS.AU.Message.SMD.MessageTypeI</IndexLocation>
<StreamLocation>^HS.AU.Message.SMD.MessageTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
