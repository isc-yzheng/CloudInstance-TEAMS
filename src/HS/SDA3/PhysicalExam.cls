Class HS.SDA3.PhysicalExam Extends HS.SDA3.SuperClass
{

Property Extension As HS.Local.SDA3.PhysicalExamExtension;

/// Time of exam<br><br>
/// VIEWERLIB: User.HS.MRPhysExamination(PHYSDate) + User.HS.MRPhysExamination(PHYSTime)
Property PhysExamTime As HS.SDA3.TimeStamp;

/// Code for part of exam<br><br>
/// Streamlet cache:<br>
/// In the OnValidate method of the Streamlet class, if the PhysicalExam has no<br>
/// PhysExamCode, then an error will be logged and the Streamlet will not be<br>
/// saved.<br><br>
/// SDATableName=PhysExam, ViewerClass=User.HS.MRCBodyArea<br>
/// VIEWERLIB: User.HS.MRPhysExamination(PHYSBodyAreaDR)
Property PhysExamCode As HS.SDA3.CodeTableDetail.PhysExam;

/// Code for observation<br><br>
/// SDATableName=PhysExamObs, ViewerClass=User.HS.MRCBodyAreaProblems<br>
/// VIEWERLIB: User.HS.MRPhysExamination(PHYSMRCBodyAreProbDR)
Property PhysExamObs As HS.SDA3.CodeTableDetail.PhysExamObs;

/// Code for observation qualifier<br><br>
/// Streamlet cache:<br>
/// In the OnBeforeMatch method of the Streamlet class, if the PhysicalExam has<br>
/// a PhysExamObsQualifier but no PhysExamObs, an alert will be logged and the<br>
/// PhysExamObsQualifier will be removed from the SDA.<br><br>
/// SDATableName=PhysExamObsQualifier, ViewerClass=User.HS.MRCBodyAreaProblemsSubp<br>
/// VIEWERLIB: User.HS.MRPhysExamination(PHYSMRCBodyAreaProbSubDR)
Property PhysExamObsQualifier As HS.SDA3.CodeTableDetail.PhysExamObsQualifier;

/// Code for observation value<br><br>
/// SDATableName=PhysExamObsValue, ViewerClass=User.HS.MRCBodySystemProbStatus<br>
/// VIEWERLIB: User.HS.MRPhysExamination(PHYSBodyProbStatDR)
Property PhysExamObsValue As HS.SDA3.CodeTableDetail.PhysExamObsValue;

/// Length subject to the total streamlet size limit - 3,000,000<br><br>
/// VIEWERLIB: User.HS.MRPhysExamination(PHYSDesc)<br>
Property NoteText As %String(MAXLEN = "");

/// Supported values:<br>
/// D = Delete<br>
/// C = Clear/Delete All<br>
/// Any other value = Add or Update<br>
/// See the annotation on the superclass property for more information on how<br>
/// ActionCode is used.<br><br>
/// VIEWERLIB: Not stored
Property ActionCode As %String;

/// SDATableName=User, ViewerClass=User.HS.SSUser<br>
/// VIEWERLIB: User.HS.MRPhysExamination(PHYSUpdateUserDR)
Property EnteredBy As HS.SDA3.CodeTableDetail.User;

/// SDATableName=Organization, ViewerClass=User.HS.CTHospital<br>
/// VIEWERLIB: User.HS.MRPhysExamination(PHYSUpdateHospitalDR)
Property EnteredAt As HS.SDA3.CodeTableDetail.Organization;

/// VIEWERLIB: User.HS.MRPhysExamination(PHYSUpdateDate) + User.HS.MRPhysExamination(PHYSUpdateTime)
Property EnteredOn As HS.SDA3.TimeStamp;

/// Not used.
Property ActionScope As %String;

Storage Default
{
<Data name="SuperClassState">
<Subscript>"SuperClass"</Subscript>
<Value name="1">
<Value>ActionCode</Value>
</Value>
<Value name="2">
<Value>ActionScope</Value>
</Value>
<Value name="3">
<Value>EnteredBy</Value>
</Value>
<Value name="4">
<Value>EnteredAt</Value>
</Value>
<Value name="5">
<Value>EnteredOn</Value>
</Value>
<Value name="6">
<Value>ExternalId</Value>
</Value>
<Value name="7">
<Value>EncounterNumber</Value>
</Value>
<Value name="8">
<Value>PhysExamTime</Value>
</Value>
<Value name="9">
<Value>PhysExamCode</Value>
</Value>
<Value name="10">
<Value>PhysExamObs</Value>
</Value>
<Value name="11">
<Value>PhysExamObsQualifier</Value>
</Value>
<Value name="12">
<Value>PhysExamObsValue</Value>
</Value>
<Value name="13">
<Value>NoteText</Value>
</Value>
<Value name="14">
<Value>FromTime</Value>
</Value>
<Value name="15">
<Value>ToTime</Value>
</Value>
<Value name="16">
<Value>Deleted</Value>
</Value>
<Value name="17">
<Value>UpdatedOn</Value>
</Value>
<Value name="18">
<Value>CustomPairs</Value>
</Value>
<Value name="19">
<Value>Extension</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}
