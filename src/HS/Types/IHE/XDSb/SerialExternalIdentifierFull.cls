/// Similar to SerialExternalIdentifier but includes the IdentificationScheme, Title, Comments
Class HS.Types.IHE.XDSb.SerialExternalIdentifierFull Extends HS.Types.IHE.XDSb.SerialExternalIdentifier
{

Property IdentificationScheme As %String(MAXLEN = 256);

Property Names As list Of HS.Types.IHE.XDSb.ValueType(XMLNAME = "Name", XMLPROJECTION = "ELEMENT");

Property Descriptions As list Of HS.Types.IHE.XDSb.ValueType(XMLNAME = "Description", XMLPROJECTION = "ELEMENT");

Storage Default
{
<Data name="SerialExternalIdentifierState">
<Value name="1">
<Value>IID</Value>
</Value>
<Value name="2">
<Value>Value</Value>
</Value>
<Value name="3">
<Value>IdentificationScheme</Value>
</Value>
<Value name="4">
<Value>Names</Value>
</Value>
<Value name="5">
<Value>Descriptions</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}
