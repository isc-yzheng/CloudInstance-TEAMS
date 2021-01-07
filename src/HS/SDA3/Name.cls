/// This class holds an extended name, data structure XPN in HL7v2<br>
/// For example: "Dr. Adam A. J. van Everyman III PhD,VC"<br>
/// XPN: |Everyman&van^Adam^A. J.^III^Dr.^^^^^^^^^PHD,VC|<br>
/// FamilyName: Everyman<br>
/// FamilyNamePrefix: van<br>
/// NamePrefix: Dr.<br>
/// NameSuffix: III<br>
/// GivenName: Adam<br>
/// MiddleName: A. J.<br>
/// ProfessionalSuffix: PHD,VC
Class HS.SDA3.Name Extends HS.SDA3.DataType
{

Property Extension As HS.Local.SDA3.NameExtension;

/// The main part of the FamilyName, for sorting, etc.
Property FamilyName As %String(MAXLEN = 80);

/// The prefix for the FamilyName, e.g. "van der"
Property FamilyNamePrefix As %String(MAXLEN = 220);

/// The prefix for the name, e.g. "Dr."
Property NamePrefix As %String(MAXLEN = 220);

/// The suffix for the name, e.g. "Jr", "III"
Property NameSuffix As %String(MAXLEN = 220);

/// The (first) given name
Property GivenName As %String(MAXLEN = 60);

/// The (other) given names or initials<br>
///  e.g. "John J", "William James", "A. T."
Property MiddleName As %String(MAXLEN = 220);

/// The professional credentials, e.g. "MD", "PhD"
Property ProfessionalSuffix As %String(MAXLEN = 220);

/// Type of name for distinguishing a person's name from his/her birth name
/// VALUELIST taken from EntitynaepartQuaifier of HL7 2.16.840.1.113883.5.43
/// Same as in HS.Types.PersonName property Type
Property Type As %String(DISPLAYLIST = ",Alias,Adopted Name,Name At Birth,Display Name,Legal Name,Licensing Name,Maiden Name,Nickname,Previous,Indigenous/Tribal,Unspecified", MAXLEN = "", VALUELIST = ",Alias,Adopted,Birth,Display,Legal,License,Maiden,Nickname,Previous,Tribal,Unknown");

/// The name the person is usually known by other than the first name.
Property PreferredName As %String(MAXLEN = 220);

/// The patient's date of birth, when this Name is used as a patient alias.<br>
/// This property should not be populated by a data provider.  It is copied<br>
/// here from the Patient BirthTime as records are aggregated at the Access<br>
/// Gateway so that this Name, as an Alias, can be displayed in the Clinical<br>
/// Viewer with the DOB of the record from which it originated.  This property<br>
/// is not saved as part of the Patient Streamlet.
Property DOB As HS.SDA3.TimeStamp(XMLIO = "SKIP");

/// The patient's medical record number, when this Name is used as a patient<br>
/// alias. This property should not be populated by a data provider.  It is<br>
/// copied here from the PatientNumber with NumberType="MRN" as records are<br>
/// aggregated at the Access Gateway so that this Name, as an Alias, can be<br>
/// displayed in the Clinical Viewer with the MRN of the record from which it<br>
/// originated.  This property is not saved as part of the Patient Streamlet.
Property MRN As %String(XMLIO = "SKIP");

Storage Default
{
<Data name="NameState">
<Subscript>"Name"</Subscript>
<Value name="1">
<Value>FamilyName</Value>
</Value>
<Value name="2">
<Value>FamilyNamePrefix</Value>
</Value>
<Value name="3">
<Value>NamePrefix</Value>
</Value>
<Value name="4">
<Value>NameSuffix</Value>
</Value>
<Value name="5">
<Value>GivenName</Value>
</Value>
<Value name="6">
<Value>MiddleName</Value>
</Value>
<Value name="7">
<Value>ProfessionalSuffix</Value>
</Value>
<Value name="8">
<Value>PreferredName</Value>
</Value>
<Value name="9">
<Value>DOB</Value>
</Value>
<Value name="10">
<Value>MRN</Value>
</Value>
<Value name="11">
<Value>Extension</Value>
</Value>
<Value name="12">
<Value>FamilyNameQualifier</Value>
</Value>
<Value name="13">
<Value>GivenNameQualifier</Value>
</Value>
<Value name="14">
<Value>MiddleNameQualifier</Value>
</Value>
<Value name="15">
<Value>Type</Value>
</Value>
</Data>
<State>NameState</State>
<Type>%Storage.Serial</Type>
}

}
