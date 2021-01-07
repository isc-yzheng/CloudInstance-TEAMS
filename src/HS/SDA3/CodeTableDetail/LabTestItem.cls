/// The Viewer Cache table for LabTestItem, CT_TestCode, is not constrained to<br>
/// have unique Descriptions, so Description will never have a uniqueness<br>
/// suffix added to it in the Viewer Cache.<br><br>
/// Note that in addition to the other reserved characters (documented in the<br>
/// CodeTableDetail class), LabTestItem Codes and Descriptions may not contain<br>
/// backslash characters ("\") in the Viewer Cache only. In the Viewer Cache,<br>
/// backslashes will be replaced with underscores ("_").<br><br>
/// lab.HS.CTAntibiotics is for antibiotic sensitivities only. See<br>
/// HS.SDA3.LabResultItem:TestItemCode for more info.<br><br>
/// Also note that the matching of LabTestItem CodeTableDetails in the SDA to<br>
/// CTTestCodes in the Viewer Cache can optionally use the ResultValueUnits<br>
/// of the containing LabResultItem as a match property. See<br>
/// HS.SDA3.LabResultItem:ResultValueUnits for more details.
Class HS.SDA3.CodeTableDetail.LabTestItem Extends HS.SDA3.CodeTableTranslated
{

Property Extension As HS.Local.SDA3.CodeTableDetail.LabTestItemExtension;

/// VIEWERLIB: User.HS.CTTestCode(CTTCCode)
/// VIEWERLIB: lab.HS.CTAntibiotics(CTANTCode)<br>
Property Code As HS.SDA3.StrippedString(MAXLEN = 32000);

/// VIEWERLIB: User.HS.CTTestCode(CTTCDesc)
/// VIEWERLIB: lab.HS.CTAntibiotics(CTANTName)<br>
Property Description As HS.SDA3.StrippedString(MAXLEN = 32000);

/// Whether this test item is numeric.<br><br>
/// Viewer cache:<br>
/// The CTTCShowInCummulative property and the ARCIMDisplayCumulative property of the ARCItmMast 
/// for the current order will always be set to "Y", regardless of IsNumeric.<br>
/// VIEWERLIB: Not stored<br>
Property IsNumeric As HS.SDA3.Boolean;

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
<Value>IsNumeric</Value>
</Value>
<Value name="8">
<Value>EId</Value>
</Value>
<Value name="9">
<Value>PriorCodes</Value>
</Value>
<Value name="10">
<Value>OriginalText</Value>
</Value>
<Value name="11">
<Value>CodeSystemVersionId</Value>
</Value>
<Value name="12">
<Value>Extension</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}
