Class HS.SDA3.CodeTableDetail.CareProviderType Extends HS.SDA3.CodeTableDetail
{

Property Extension As HS.Local.SDA3.CodeTableDetail.CareProviderTypeExtension;

/// VIEWERLIB: User.HS.CTCarPrvTp(CTCPTCode)
Property Code As HS.SDA3.StrippedString(MAXLEN = 32000);

/// VIEWERLIB: User.HS.CTCarPrvTp(CTCPTDesc)
Property Description As HS.SDA3.StrippedString(MAXLEN = 32000);

Storage Default
{
<Data name="CodeTableDetailState">
<Value name="1">
<Value>SDATableName</Value>
</Value>
<Value name="2">
<Value>SDACodingStandard</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
<Value name="5">
<Value>InternalReference</Value>
</Value>
<Value name="6">
<Value>ErrorStatus</Value>
</Value>
<Value name="7">
<Value>Factor</Value>
</Value>
<Value name="8">
<Value>EId</Value>
</Value>
<Value name="9">
<Value>CodeSystemVersionId</Value>
</Value>
<Value name="10">
<Value>Extension</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}
