/// For all CodeTableDetails that get loaded into the Viewer Cache, the<br>
/// matching logic in the Viewer Cache will match a null inbound Description to<br>
/// anything. For Gender only, an inbound Description that is the same as the<br>
/// inbound Code will also match anything. For example, an inbound Code="M",<br>
/// Desc="M" will match an existing Code="M", Desc="Male".<br>
/// Also, note that unlike most code tables in the Viewer Cache, CTSex is<br>
/// preserved across Access Gateway resets.
Class HS.SDA3.CodeTableDetail.Gender Extends HS.SDA3.CodeTableTranslated
{

Property Extension As HS.Local.SDA3.CodeTableDetail.GenderExtension;

/// VIEWERLIB: User.HS.CTSex(CTSEXCode)
Property Code As HS.SDA3.StrippedString(MAXLEN = 32000);

/// VIEWERLIB: User.HS.CTSex(CTSEXDesc)
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
<Value>EId</Value>
</Value>
<Value name="8">
<Value>OriginalText</Value>
</Value>
<Value name="9">
<Value>PriorCodes</Value>
</Value>
<Value name="10">
<Value>CodeSystemVersionId</Value>
</Value>
<Value name="11">
<Value>Extension</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}
