/// HS.SDA3.FamilyHistory corresponds to the CDA Family History section.
Class HS.SDA3.FamilyHistory Extends HS.SDA3.SuperClass
{

Property Extension As HS.Local.SDA3.FamilyHistoryExtension;

/// Family member covered<br><br>
/// Streamlet cache:<br>
/// In the OnValidate method of the Streamlet class, if no FamilyMember is<br>
/// defined in the SDA, an error will be logged and the streamlet will not<br>
/// be saved.<br><br>
/// SDATableName=FamilyMember, ViewerClass=User.HS.CTRelation<br>
/// VIEWERLIB: User.HS.PAFamily(FAMRelationDR)
Property FamilyMember As HS.SDA3.CodeTableDetail.FamilyMember;

/// Diagnosis on family member<br><br>
/// SDATableName=Diagnosis, ViewerClass=User.HS.MRCICDDx<br>
/// VIEWERLIB: User.HS.PAFamily(FAMMRCICDDR)
Property Diagnosis As HS.SDA3.CodeTableDetail.Diagnosis;

/// Length subject to the total streamlet size limit - 3,000,000<br><br>
/// VIEWERLIB: User.HS.PAFamily(FAMDesc)<br>
Property NoteText As %String(MAXLEN = "");

/// Streamlet cache:<br>
/// In the OnValidate method of the Streamlet class, if Status is null, it is<br>
/// defaulted to "A" for "Active".<br>
/// Deactivating the streamlet via ActionCode="I" will set Status to "I".<br><br>
/// Viewer cache:<br>
/// The stored value will be "Y" if Status is "I", and "N" otherwise.<br><br>
/// VIEWERLIB: User.HS.PAFamily(FAMInActive)<br>
Property Status As %String;

/// Supported values:<br>
/// D = Delete<br>
/// I = Inactivate All (set Status="I")<br>
/// C = Clear/Delete All<br>
/// Any other value = Add or Update<br>
/// See the annotation on the superclass property for more information on how<br>
/// ActionCode is used.<br><br>
/// VIEWERLIB: Not stored
Property ActionCode As %String;

/// SDATableName=User, ViewerClass=User.HS.SSUser<br>
/// VIEWERLIB: User.HS.PAFamily(FAMUpdateUserDR)
Property EnteredBy As HS.SDA3.CodeTableDetail.User;

/// SDATableName=Organization, ViewerClass=User.HS.CTHospital<br>
/// VIEWERLIB: User.HS.PAFamily(FAMUpdateHospitalDR)
Property EnteredAt As HS.SDA3.CodeTableDetail.Organization;

/// VIEWERLIB: User.HS.PAFamily(FAMUpdateDate) + User.HS.PAFamily(FAMUpdateTime)<br>
Property EnteredOn As HS.SDA3.TimeStamp;

/// Beginning of period covered<br><br>
/// Viewer cache:<br>
/// Only the date part of the FromTime is stored in the Viewer Vache.<br>
/// (FAMOnsetDate is date-only.)<br><br>
/// VIEWERLIB: User.HS.PAFamily(FAMOnsetDate)
Property FromTime As HS.SDA3.TimeStamp;

/// End of period covered<br><br>
/// VIEWERLIB: User.HS.PAFamily(FAMDate) + User.HS.PAFamily(FAMTime)
Property ToTime As HS.SDA3.TimeStamp;

/// Identifier used by systems outside HealthShare<br><br>
/// VIEWERLIB: User.HS.PAFamily(FAMExternalId)<br>
Property ExternalId As %String(MAXLEN = 220);

/// Not used.
Property ActionScope As %String;

ClassMethod StartXMLList()
{
	Quit "<FamilyHistories>"
}

ClassMethod EndXMLList()
{
	Quit "</FamilyHistories>"
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
<Value>FamilyMember</Value>
</Value>
<Value name="11">
<Value>Diagnosis</Value>
</Value>
<Value name="12">
<Value>NoteText</Value>
</Value>
<Value name="13">
<Value>Status</Value>
</Value>
<Value name="14">
<Value>Deleted</Value>
</Value>
<Value name="15">
<Value>UpdatedOn</Value>
</Value>
<Value name="16">
<Value>CustomPairs</Value>
</Value>
<Value name="17">
<Value>Extension</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}
