/// ASW	self-funded plans that are administered by a third-party administrator, where the employer has purchased stop-loss, or group excess, insurance coverage
/// ASO	self-funded plans that are administered by a third-party administrator, where the employer has not purchased stop-loss, or group excess, insurance coverage
/// STN	short-term, non-renewable health insurance
/// UND	plans underwritten by the insurer
/// OTH	Any other plan. Insurers using this code shall obtain prior approval.
Class HS.SDA3.CodeTableDetail.CoverageType Extends HS.SDA3.CodeTableTranslated
{

Property Extension As HS.Local.SDA3.CodeTableDetail.CoverageTypeExtension;

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
