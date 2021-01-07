/// IND	Policies sold and issued directly to individuals (non-group)
/// FCH	Policies sold and issued directly to individuals on a franchise basis
/// GCV	Policies sold and issued directly to individuals as group conversion Policies
/// GS1	Policies sold and issued directly to employers having exactly one employee
/// GS2	Policies sold and issued directly to employers having between two and nine employees
/// GS3	Policies sold and issued directly to employers having between 10 and 25 employees
/// GS4	Policies sold and issued directly to employers having between 26 and 50 employees
/// GLG1	Policies sold and issued directly to employers having between 51 and 99 employees
/// GLG2	Policies sold and issued directly to employers having between 100 and 249 employees
/// GLG3	Policies sold and issued directly to employers having between 250 and 499 employees
/// GLG4	Policies sold and issued directly to employers having 500 or more employees
/// GSA	Policies sold and issued directly to small employers through a qualified association trust
/// OTH	Policies sold to other types of entities. Insurers using this market code shall obtain prior approval.
Class HS.SDA3.CodeTableDetail.MarketCategory Extends HS.SDA3.CodeTableTranslated
{

Property Extension As HS.Local.SDA3.CodeTableDetail.MarketCategoryExtension;

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
