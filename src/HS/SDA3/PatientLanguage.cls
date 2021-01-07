/// PatientLanguage appears in the SDA as a list property (OtherLanguages) of<br>
/// HS.SDA3.Patient. See the annotations on this property for information on<br>
/// how PatientLanguage is matched at the Edge and inserted into the Viewer<br>
/// Cache.<br>
Class HS.SDA3.PatientLanguage Extends HS.SDA3.SuperClass
{

Property Extension As HS.Local.SDA3.PatientLanguageExtension;

/// SDATableName=Language, ViewerClass=User.HS.PACPreferredLanguage<br>
/// VIEWERLIB: User.HS.PAPersonLanguage(LANGLanguageDR)
Property PreferredLanguage As HS.SDA3.CodeTableDetail.Language;

/// What the language should be used for.<br><br>
/// VIEWERLIB: User.HS.PAPersonLanguage(LANGUse)
Property Use As %String(MAXLEN = 220);

/// Note: This property is needed by the Sweden project, do not remove.<br>
/// Prodlog 78545<br><br>
/// VIEWERLIB: Not stored
Property EnteredOn As HS.SDA3.TimeStamp;

/// Not used.
Property ActionCode As %String;

/// Not used.
Property ActionScope As %String;

/// Not used.
Property UpdatedOn As HS.SDA3.TimeStamp;

/// Not used.
Property EncounterNumber As %String(MAXLEN = 220);

/// Not used.
Property ExternalId As %String(MAXLEN = 220);

Storage Default
{
<Data name="PatientLanguageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<Data name="PatientLanguageState">
<Subscript>"PatientLanguage"</Subscript>
<Value name="1">
<Value>PreferredLanguage</Value>
</Value>
<Value name="2">
<Value>Use</Value>
</Value>
<Value name="3">
<Value>ActionCode</Value>
</Value>
<Value name="4">
<Value>EnteredBy</Value>
</Value>
<Value name="5">
<Value>EnteredAt</Value>
</Value>
<Value name="6">
<Value>EnteredOn</Value>
</Value>
<Value name="7">
<Value>ExternalId</Value>
</Value>
<Value name="8">
<Value>ActionScope</Value>
</Value>
<Value name="9">
<Value>EncounterNumber</Value>
</Value>
<Value name="10">
<Value>FromTime</Value>
</Value>
<Value name="11">
<Value>ToTime</Value>
</Value>
<Value name="12">
<Value>Deleted</Value>
</Value>
<Value name="13">
<Value>UpdatedOn</Value>
</Value>
<Value name="14">
<Value>CustomPairs</Value>
</Value>
<Value name="15">
<Value>Extension</Value>
</Value>
</Data>
<DataLocation>^HS.SDA3.PatientLanguageD</DataLocation>
<DefaultData>PatientLanguageDefaultData</DefaultData>
<IdLocation>^HS.SDA3.PatientLanguageD</IdLocation>
<IndexLocation>^HS.SDA3.PatientLanguageI</IndexLocation>
<State>PatientLanguageState</State>
<StreamLocation>^HS.SDA3.PatientLanguageS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
