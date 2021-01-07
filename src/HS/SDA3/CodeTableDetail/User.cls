/// Note that unlike most code tables in the Viewer Cache, SSUser is preserved<br>
/// across Access Gateway resets.
Class HS.SDA3.CodeTableDetail.User Extends HS.SDA3.CodeTableDetail
{

Property Extension As HS.Local.SDA3.CodeTableDetail.UserExtension;

/// Viewer cache:<br>
/// If Code is not null, it will be inserted into SSUSRInitials, else the first<br>
/// character of Description will be inserted into SSUSRInitials.<br><br>
/// VIEWERLIB: User.HS.SSUser(SSUSRInitials)
Property Code As HS.SDA3.StrippedString(MAXLEN = 32000);

/// Viewer cache:<br>
/// If Code is not null, it will be inserted into SSUSRInitials, else the first<br>
/// character of Description will be inserted into SSUSRInitials.<br><br>
/// VIEWERLIB: User.HS.SSUser(SSUSRName)<br>
/// VIEWERLIB: User.HS.SSUser(SSUSRInitials)
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
