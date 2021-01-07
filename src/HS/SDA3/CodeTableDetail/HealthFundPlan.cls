/// HealthFundPlan is processed "in-line" in the Viewer Cache in<br>
/// web.SDA3.Encounter:InsertHealthFund since it needs to know about its<br>
/// "parent" HealthFund. A reference to the "parent" HealthFund (as an<br>
/// ARCInsuranceType) is stored in the AUXITInsTypeDR property.<br><br>
/// In the Viewer Cache, HealthFundPlan is matched on Code, SDACodingStandard,<br>
/// and the "parent" HealthFund/ARCInsuranceType. If a match is found where the<br>
/// Description is different, it is updated. Codes and Descriptions are only<br>
/// required to be unique within a parent ARCInsuranceType. They may be reused<br>
/// with a different parent ARCInsuranceType.
Class HS.SDA3.CodeTableDetail.HealthFundPlan Extends HS.SDA3.CodeTableTranslated
{

Property Extension As HS.Local.SDA3.CodeTableDetail.HealthFundPlanExtension;

/// VIEWERLIB: User.HS.ARCAuxilInsurType(AUXITCode)
Property Code As HS.SDA3.StrippedString(MAXLEN = 32000);

/// VIEWERLIB: User.HS.ARCAuxilInsurType(AUXITDesc)
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
