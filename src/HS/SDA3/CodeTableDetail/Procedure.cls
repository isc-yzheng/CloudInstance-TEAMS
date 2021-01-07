Class HS.SDA3.CodeTableDetail.Procedure Extends HS.SDA3.CodeTableTranslated
{

Property Extension As HS.Local.SDA3.CodeTableDetail.ProcedureExtension;

Parameter XMLTYPE = "ProcedureCode";

Parameter XMLNAME = "Procedure";

/// VIEWERLIB: User.HS.ORCOperation(OPERCode)
Property Code As HS.SDA3.StrippedString(MAXLEN = 32000);

/// VIEWERLIB: User.HS.ORCOperation(OPERDesc)
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
