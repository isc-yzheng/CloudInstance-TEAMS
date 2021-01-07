Class HS.SDA3.CodeTableDetail.Allergy Extends HS.SDA3.CodeTableTranslated
{

Parameter XMLTYPE = "AllergyCode";

Parameter XMLNAME = "Allergy";

Property Extension As HS.Local.SDA3.CodeTableDetail.AllergyExtension;

/// VIEWERLIB: User.HS.PACAllergy(ALGCode)
Property Code As HS.SDA3.StrippedString(MAXLEN = 32000);

/// VIEWERLIB: User.HS.PACAllergy(ALGDesc)
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
<Value>AllergyCategory</Value>
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
