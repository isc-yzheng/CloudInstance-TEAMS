/// HS.SDA3.IllnessHistory corresponds to the CDA History of Present Illness section.
Class HS.SDA3.IllnessHistory Extends HS.SDA3.SuperClass
{

Property Extension As HS.Local.SDA3.IllnessHistoryExtension;

/// Length subject to the total streamlet size limit - 3,000,000<br><br>
/// VIEWERLIB: User.HS.PAPastHistCondition(PHISTDesc)<br>
Property NoteText As %String(MAXLEN = "");

/// Code for condition<br><br>
/// SDATableName=PastHistoryCondition, ViewerClass=User.HS.MRCPastHistCondit<br>
/// VIEWERLIB: User.HS.PAPastHistCondition(PHISTPastHistDR)
Property Condition As HS.SDA3.CodeTableDetail.PastHistoryCondition;

/// Clinician involved<br><br>
/// SDATableName=CareProvider, ViewerClass=User.HS.CTCareProv<br>
/// VIEWERLIB: User.HS.PAPastHistCondition(PHISTCTCPDR)<br>
Property Clinician As HS.SDA3.CodeTableDetail.CareProvider;

/// Time history verified<br><br>
/// VIEWERLIB: User.HS.PAPastHistCondition(PHISTVerifiedDate) + User.HS.PAPastHistCondition(PHISTVerifiedTime)
Property VerifiedTime As HS.SDA3.TimeStamp;

/// Streamlet cache:<br>
/// Unlike EncounterNumber, this property may be filled in or updated after the<br>
/// IllnessHistory is initially created, and is not used for matching.<br><br>
/// Viewer cache:<br>
/// The PHISTEncounter field in the Viewer Cache is used for both<br>
/// EncounterNumber and AssociatedEncounter, whichever is present.  If both are<br>
/// present, EncounterNumber is used.<br><br>
/// VIEWERLIB: User.HS.PAPastHistCondition(PHISTEncounter)
Property AssociatedEncounter As %String;

/// Supported values:<br>
/// D = Delete<br>
/// C = Clear/Delete All<br>
/// Any other value = Add or Update<br>
/// See the annotation on the superclass property for more information on how<br>
/// ActionCode is used.<br><br>
/// VIEWERLIB: Not stored
Property ActionCode As %String;

/// SDATableName=User, ViewerClass=User.HS.SSUser<br>
/// VIEWERLIB: User.HS.PAPastHistCondition(PHISTUpdateUserDR)
Property EnteredBy As HS.SDA3.CodeTableDetail.User;

/// SDATableName=Organization, ViewerClass=User.HS.CTHospital<br>
/// VIEWERLIB: User.HS.PAPastHistCondition(PHISTUpdateHospitalDR)
Property EnteredAt As HS.SDA3.CodeTableDetail.Organization;

/// VIEWERLIB: User.HS.PAPastHistCondition(PHISTUpdateDate) + User.HS.PAPastHistCondition(PHISTUpdateTime)
Property EnteredOn As HS.SDA3.TimeStamp;

/// Beginning of period covered<br><br>
/// Viewer cache:<br>
/// Only the date part of FromTime is stored in the Viewer Cache.<br>
/// (PHISTOnsetDate is date-only.)<br><br>
/// VIEWERLIB: User.HS.PAPastHistCondition(PHISTOnsetDate)<br>
Property FromTime As HS.SDA3.TimeStamp;

/// End of period covered<br><br>
/// VIEWERLIB: User.HS.PAPastHistCondition(PHISTDate) + User.HS.PAPastHistCondition(PHISTTime)
Property ToTime As HS.SDA3.TimeStamp;

/// VIEWERLIB: User.HS.PAPastHistCondition(PHISTExternalId)
Property ExternalId As %String(MAXLEN = 220);

/// Viewer cache:<br>
/// The PHISTEncounter field in the Viewer Cache is used for both<br>
/// EncounterNumber and AssociatedEncounter, whichever is present.  If both are<br>
/// present, EncounterNumber is used.<br><br>
/// VIEWERLIB: User.HS.PAPastHistCondition(PHISTEncounter)
Property EncounterNumber As %String(MAXLEN = 220);

/// Not used.
Property ActionScope As %String;

ClassMethod StartXMLList()
{
	Quit "<IllnessHistories>"
}

ClassMethod EndXMLList()
{
	Quit "</IllnessHistories>"
}

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
<Value>FromTime</Value>
</Value>
<Value name="9">
<Value>ToTime</Value>
</Value>
<Value name="10">
<Value>NoteText</Value>
</Value>
<Value name="11">
<Value>Condition</Value>
</Value>
<Value name="12">
<Value>Clinician</Value>
</Value>
<Value name="13">
<Value>VerifiedTime</Value>
</Value>
<Value name="14">
<Value>LinkedEncounterNumber</Value>
</Value>
<Value name="15">
<Value>Deleted</Value>
</Value>
<Value name="16">
<Value>UpdatedOn</Value>
</Value>
<Value name="17">
<Value>CustomPairs</Value>
</Value>
<Value name="18">
<Value>AssociatedEncounter</Value>
</Value>
<Value name="19">
<Value>Extension</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}
