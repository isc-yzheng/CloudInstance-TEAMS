/// HS.SDA3.SocialHistory corresponds to the CDA Social History section.
Class HS.SDA3.SocialHistory Extends HS.SDA3.SuperClass
{

Property Extension As HS.Local.SDA3.SocialHistoryExtension;

/// Social habit code<br>
/// Ex: "Smoking"<br><br>
/// Streamlet cache:<br>
/// In the OnValidate method of the Streamlet class, if the SDA does not<br>
/// contain a SocialHabit, and error will be logged and the Streamlet will not<br>
/// be saved.<br><br>
/// SDATableName=SocialHabit, ViewerClass=User.HS.MRCHabits<br>
/// VIEWERLIB: User.HS.PASocHist(SCHHabitsDR)
Property SocialHabit As HS.SDA3.CodeTableDetail.SocialHabit;

/// Quantity associated with social habit<br>
/// Ex: "Two packs per day"<br><br>
/// SDATableName=SocialHabitQty, ViewerClass=User.HS.MRCHabitsQuantity<br>
/// VIEWERLIB: User.HS.PASocHist(SCHHabitsQtyDR)
Property SocialHabitQty As HS.SDA3.CodeTableDetail.SocialHabitQty;

/// Stores coded type of social habit
Property SocialHabitCategory As HS.SDA3.CodeTableDetail.SocialHabitCategory;

/// Length subject to the total streamlet size limit - 3,000,000<br><br>
/// VIEWERLIB: User.HS.PASocHist(SCHDesc)
Property SocialHabitComments As %String(MAXLEN = "");

/// Streamlet cache:<br>
/// In the OnInactivate method of the Streamlet class, if the Status is not<br>
/// already "I", it is set to "I".<br>
/// In the OnValidate method, if the Status is null, it is defaulted to "A" for<br>
/// "Active".<br><br>
/// Viewer cache:<br>
/// A Status of "I" is stored in the viewer cache as "Y". Any other Status is<br>
/// stored as "N".<br><br>
/// VIEWERLIB: User.HS.PASocHist(SCHInActive)<br>
Property Status As %String;

/// SDATableName=User, ViewerClass=User.HS.SSUser<br>
/// VIEWERLIB: User.HS.PASocHist(SCHUpdateUserDR)
Property EnteredBy As HS.SDA3.CodeTableDetail.User;

/// SDATableName=Organization, ViewerClass=User.HS.CTHospital<br>
/// VIEWERLIB: User.HS.PASocHist(SCHUpdateHospitalDR)
Property EnteredAt As HS.SDA3.CodeTableDetail.Organization;

/// VIEWERLIB: User.HS.PASocHist(SCHUpdateDate) + User.HS.PASocHist(SCHUpdateTime)<br>
Property EnteredOn As HS.SDA3.TimeStamp;

/// Beginning of period covered<br><br>
/// Viewer cache:<br>
/// Only the date part of FromTime is stored in the Viewer Cache. (SCHOnsetDate<br>
/// is date-only.)<br><br>
/// VIEWERLIB: User.HS.PASocHist(SCHOnsetDate)<br>
Property FromTime As HS.SDA3.TimeStamp;

/// End of period covered<br><br>
/// VIEWERLIB: User.HS.PASocHist(SCHDate) + User.HS.PASocHist(SCHTime)
Property ToTime As HS.SDA3.TimeStamp;

/// VIEWERLIB: User.HS.PASocHist(SCHExternalId)<br>
Property ExternalId As %String(MAXLEN = 220);

/// Supported values:<br>
/// D = Delete<br>
/// I = Inactivate All (set Status="I")<br>
/// C = Clear/Delete All<br>
/// Any other value = Add or Update<br>
/// See the annotation on the superclass property for more information on how<br>
/// ActionCode is used.<br><br>
/// VIEWERLIB: Not stored
Property ActionCode As %String;

/// Not used.
Property ActionScope As %String;

ClassMethod StartXMLList()
{
	Quit "<SocialHistories>"
}

ClassMethod EndXMLList()
{
	Quit "</SocialHistories>"
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
<Value>SocialHabit</Value>
</Value>
<Value name="11">
<Value>SocialHabitQty</Value>
</Value>
<Value name="12">
<Value>SocialHabitComments</Value>
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
<Value name="18">
<Value>SocialHabitCategory</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}
