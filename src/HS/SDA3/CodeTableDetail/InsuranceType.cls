/// 09	Self-pay
/// 10	Central Certification
/// 11	Other Non-Federal Programs
/// 12	Preferred Provider Organization (PPO)
/// 13	Point of Service (POS)
/// 14	Exclusive Provider Organization (EPO)
/// 15	Indemnity Insurance
/// 16	Health Maintenance Organization (HMO) Medicare Risk
/// AM	Automobile Medical
/// BL	Blue Cross / Blue Shield
/// CC	Commonwealth Care
/// CE	Commonwealth Choice 
/// CH	Champus
/// CI	Commercial Insurance Co.
/// DS	Disability
/// HM	Health Maintenance Organization
/// LI	Liability
/// LM	Liability Medical
/// MA	Medicare Part A
/// MB	Medicare Part B
/// MC	Medicaid
/// OF	Other Federal Program
/// TV	Title V
/// VA	Veterans Administration Plan
/// WC	Workers' Compensation
Class HS.SDA3.CodeTableDetail.InsuranceType Extends HS.SDA3.CodeTableTranslated
{

Property Extension As HS.Local.SDA3.CodeTableDetail.InsuranceTypeExtension;

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
