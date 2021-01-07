/// PatientNumber appears in the SDA as the PatientNumbers and<br>
/// PriorPatientNumbers (both lists) properties of HS.SDA3.Patient, as the<br>
/// Identifiers (list) property of HS.SDA3.SupportContact, and as the<br>
/// GuarantorNumber property of HS.SDA3.Guarantor. How it is parsed from HL7<br>
/// and loaded into the Streamlet, Aggregation, and Viewer Caches is documented<br>
/// on each of these properties, where applicable.
Class HS.SDA3.PatientNumber Extends (HS.SDA3.SuperClass, HS.SDA3.AbstractIdentifier)
{

Property Extension As HS.Local.SDA3.PatientNumberExtension;

/// The Assigning Authority for the number<br><br>
/// SDATableName=Organization, ViewerClass=User.HS.CTHospital<br>
Property Organization As HS.SDA3.CodeTableDetail.Organization;

/// The difference between Organization and ISOAssigningAuthority is that<br>
/// Organization is a CodeTableDetail whose Code is intended to come from piece<br>
/// 1 of an Hierarchic Designator (HD) data structure, PID-3.4 for example.<br>
/// ISOAssigningAuthority is a string that is intended to contain the entire HD<br>
/// structure, i.e. all of PID-3.4, not just PID-3.4.1 Unlike Organization,<br>
/// ISOAssigningAuthority is not functional. That is, no matching or other<br>
/// logic triggers off it.
Property ISOAssigningAuthority As %String(MAXLEN = 50);

/// Not used.
Property ActionCode As %String;

/// Not used.
Property ActionScope As %String;

/// Not used.
Property UpdatedOn As HS.SDA3.TimeStamp;

/// Not used.
Property ExternalId As %String(MAXLEN = 220);

/// Not used.
Property EncounterNumber As %String(MAXLEN = 220);

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
<Value>Number</Value>
</Value>
<Value name="9">
<Value>Organization</Value>
</Value>
<Value name="10">
<Value>NumberType</Value>
</Value>
<Value name="11">
<Value>FromTime</Value>
</Value>
<Value name="12">
<Value>ToTime</Value>
</Value>
<Value name="13">
<Value>Deleted</Value>
</Value>
<Value name="14">
<Value>UpdatedOn</Value>
</Value>
<Value name="15">
<Value>CustomPairs</Value>
</Value>
<Value name="16">
<Value>ISOAssigningAuthority</Value>
</Value>
<Value name="17">
<Value>Extension</Value>
</Value>
<Value name="18">
<Value>NumberTypeCodeSystem</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}
