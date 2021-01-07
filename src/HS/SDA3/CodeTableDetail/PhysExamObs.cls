/// PhysExamObs is processed "in-line" in the Viewer Cache in<br>
/// web.SDA3.PhysicalExam:UpdatePhysicalExam since it needs to know about its<br>
/// "parent" PhysExam. PhysExam is not a parent of PhysExamObs in the SDA,<br>
/// but in the Viewer Cache, MRCBodyArea is the parent of MRCBodyAreaProblems<br>
/// (relationship PROBParRef). PhysExamObs Codes and Descriptions in the Viewer<br>
/// Cache are only required to be unique within the parent PhysExam. Codes and<br>
/// Descriptions may be reused with different parent PhysExams.
Class HS.SDA3.CodeTableDetail.PhysExamObs Extends HS.SDA3.CodeTableTranslated
{

Property Extension As HS.Local.SDA3.CodeTableDetail.PhysExamObsExtension;

/// VIEWERLIB: User.HS.MRCBodyAreaProblems(PROBCode)
Property Code As HS.SDA3.StrippedString(MAXLEN = 32000);

/// VIEWERLIB: User.HS.MRCBodyAreaProblems(PROBDesc)
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
