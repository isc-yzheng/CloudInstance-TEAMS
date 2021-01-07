/// PhysExamObsQualifier is processed "in-line" in the Viewer Cache in<br>
/// web.SDA3.PhysicalExam:UpdatePhysicalExam since it needs to know about its<br>
/// "parent" PhysExamObs. PhysExamObs is not a parent of PhysExamObsQualifier<br>
/// in the SDA, but in the Viewer Cache, MRCBodyAreaProblems is the parent of<br>
/// MRCBodyAreaProblemsSubp (relationship SUBPParRef). PhysExamObsQualifier<br>
/// Codes and Descriptions in the Viewer Cache are only required to be unique<br>
/// within the parent PhysExamObs. Codes and Descriptions may be reused with<br>
/// a different parent PhysExamsObs.
Class HS.SDA3.CodeTableDetail.PhysExamObsQualifier Extends HS.SDA3.CodeTableTranslated
{

Property Extension As HS.Local.SDA3.CodeTableDetail.PhysExamObsQualifierExtension;

/// VIEWERLIB: User.HS.MRCBodyAreaProblemsSubp(SUBPCode)
Property Code As HS.SDA3.StrippedString(MAXLEN = 32000);

/// VIEWERLIB: User.HS.MRCBodyAreaProblemsSubp(SUBPDesc)
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
<Value>PhysExam</Value>
</Value>
<Value name="8">
<Value>PhysExamObs</Value>
</Value>
<Value name="9">
<Value>EId</Value>
</Value>
<Value name="10">
<Value>CodeSystemVersionId</Value>
</Value>
<Value name="11">
<Value>Extension</Value>
</Value>
<Value name="12">
<Value>OriginalText</Value>
</Value>
<Value name="13">
<Value>PriorCodes</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}
