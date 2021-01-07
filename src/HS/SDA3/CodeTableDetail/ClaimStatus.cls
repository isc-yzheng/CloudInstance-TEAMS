/// 01	Processed as primary
/// 02	Processed as secondary
/// 03	Processed as tertiary
/// 04	Denied
/// 19	Processed as primary, forwarded to additional payer(s)
/// 20	Processed as secondary, forwarded to additional payer(s)
/// 21	Processed as tertiary, forwarded to additional payer(s)
/// 22	Reversal of previous payment
Class HS.SDA3.CodeTableDetail.ClaimStatus Extends HS.SDA3.CodeTableTranslated
{

Property Extension As HS.Local.SDA3.CodeTableDetail.ClaimStatusExtension;

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
