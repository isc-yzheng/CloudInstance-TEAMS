/// Unit of measure<br>
/// UoM has several uses, such as the units of the amount of a medication<br>
/// prescribed, and the units of an observation value.<br>
/// For every other type of CodeTableDetail, a Code or Description that<br>
/// consists only of punctuation will not be saved to the Streamlet Cache, and<br>
/// will not be exported via ToQuickXML. For UoM only, there is one exception<br>
/// to this: Code and/or Description = "%" will be saved to the Streamlet Cache<br>
/// and will be exported via ToQuickXML.
Class HS.SDA3.CodeTableDetail.UoM Extends HS.SDA3.CodeTableTranslated
{

Property Extension As HS.Local.SDA3.CodeTableDetail.UoMExtension;

/// VIEWERLIB: User.HS.CTUOM(CTUOMCode)
Property Code As HS.SDA3.StrippedString(MAXLEN = 32000);

/// VIEWERLIB: User.HS.CTUOM(CTUOMDesc)
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
