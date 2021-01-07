Class HS.SDA3.CodeTableDetail.Duration Extends HS.SDA3.CodeTableTranslated
{

Property Extension As HS.Local.SDA3.CodeTableDetail.DurationExtension;

/// VIEWERLIB: User.HS.PHCDuration(PHCDUCode)
Property Code As HS.SDA3.StrippedString(MAXLEN = 32000);

/// VIEWERLIB: User.HS.PHCDuration(PHCDUDesc1)
Property Description As HS.SDA3.StrippedString(MAXLEN = 32000);

/// Number of days<br><br>
/// Viewer cache:<br>
/// On add or update, if +[Factor]=0 and +[PHCDUFactor]=0, then PHCDUFactor is<br>
/// set to 1. If an inbound Duration matches an existing PHCDuration on Code,<br>
/// Description, and SDACodingStandard, then if +[Factor] does not match<br>
/// PHCDUFactor, PHCDUFactor will be set to the value of Factor.<br><br>
/// VIEWERLIB: User.HS.PHCDuration(PHCDUFactor)
Property Factor As %String(MAXLEN = 32000);

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
<Value name="12">
<Value>Factor</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}
