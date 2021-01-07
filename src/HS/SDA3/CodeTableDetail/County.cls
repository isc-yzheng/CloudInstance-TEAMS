/// The Viewer Cache table for County, CT_CountyParish, is not constrained to<br>
/// have unique Descriptions, so Description will never have a uniqueness<br>
/// suffix added to it in the Viewer Cache.
Class HS.SDA3.CodeTableDetail.County Extends HS.SDA3.CodeTableDetail
{

Property Extension As HS.Local.SDA3.CodeTableDetail.CountyExtension;

/// VIEWERLIB: User.HS.CTCountyParish(CNTYPARCode)
Property Code As HS.SDA3.StrippedString(MAXLEN = 32000);

/// VIEWERLIB: User.HS.CTCountyParish(CNTYPARDesc)
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
<Value>CodeSystemVersionId</Value>
</Value>
<Value name="6">
<Value>InternalReference</Value>
</Value>
<Value name="7">
<Value>EId</Value>
</Value>
<Value name="8">
<Value>ErrorStatus</Value>
</Value>
<Value name="9">
<Value>Extension</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}
