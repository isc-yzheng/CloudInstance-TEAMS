/// This is used to collect data from the clinician-patient relationships that<br>
/// are stored in the Registry (as  HS.Push.PatientClinicianRelationship), and<br>
/// return them as SDA. This should only ever come from the HealthShare<br>
/// Registry. It should not be submitted by a data provider.
Class HS.SDA3.ClinicalRelationship Extends HS.SDA3.SuperClass
{

/// If the relationship is between a patient and an individual clinician, this<br>
/// is that clinician. The Code will be populated by the ID of the<br>
/// HS.Push.PatientClinicianRelationship:Clinician, and the SDACodingStandard<br>
/// will be set to "HSClinician". Other properties from the User/Clinician<br>
/// Registry (NameParts, Addresses, Telecoms) will populate this Clinician as<br>
/// well. This property will only be populated for individual relationships.<br><br>
/// Viewer cache:<br>
/// If present, Clinician will populate CPCareProvDR, else ClinicianGroup will<br>
/// be used.<br><br>
/// SDATableName=CareProvider, ViewerClass=User.HS.CTCareProv<br>
/// VIEWERLIB: User.HS.PAPersonCareProvider(CPCareProvDR)<br><br>
/// .CareProviderType<br>
/// The Code and Description come from the Name and Description of the<br>
/// HS.Push.PatientClinicianRelationship:Relationship. The SDACodingStandard is<br>
/// set to "HSRelationshipType".<br>
Property Clinician As HS.SDA3.CodeTableDetail.CareProvider;

/// For individual clinician relationships, this is the facility code for the<br>
/// clinician's primary facility.<br><br>
/// Viewer cache:<br>
/// FacilityCode is stored in a code table in the Viewer Cache<br>
/// (User.HS.CTResponsibleUnit), but because it is not a CodeTableDetail, it is<br>
/// not subjected to CodeTableDetail matching. Instead, matching is simply done<br>
/// on RUCode, ALPHAUP collated. If no matching CTResponsibleUnit is found, a<br>
/// new one is created with RUCode and RUDesc = FacilityCode.<br><br>
/// VIEWERLIB: User.HS.PAPersonCareProvider(CPRespUnitDR)
Property FacilityCode As %String;

/// If the relationship is between a patient and a clinician group, this is<br>
/// that group. The Code and Description will be populated by the ID and Name<br>
/// of the HS.Push.PatientClinicianRelationship:ClinicianGroup, respectively.<br>
/// The SDACodingStandard will be set to "HSClinicianGroup". This property will<br>
/// only be populated for group relationships.<br><br>
/// Viewer cache:<br>
/// If present, Clinician will populate CPCareProvDR, else ClinicianGroup will<br>
/// be used.<br><br>
/// SDATableName=CareProvider, ViewerClass=User.HS.CTCareProv<br>
/// VIEWERLIB: User.HS.PAPersonCareProvider(CPCareProvDR)<br><br>
/// .CareProviderType<br>
/// The Code and Description come from the Name and Description of the<br>
/// HS.Push.PatientClinicianRelationship:Relationship. The SDACodingStandard is<br>
/// set to "HSRelationshipType".<br>
Property ClinicianGroup As HS.SDA3.CodeTableDetail.CareProvider;

/// Populated by the ExpirationDate of the<br>
/// HS.Push.PatientClinicianRelationship.<br><br>
/// VIEWERLIB: Not stored<br>
Property ExpirationDate As HS.SDA3.TimeStamp;

/// Not used.
Property ActionScope As %String;

/// Populated by the StartDate of the<br>
/// HS.Push.PatientClinicianRelationship.<br><br>
/// VIEWERLIB: Not stored<br>
Property StartDate As HS.SDA3.TimeStamp;

/// Used for Encounter entities
/// VIEWERLIB: Not stored<br>
Property EncounterNumber As %String(MAXLEN = 220);

ClassMethod GetStreamletClass(pType)
{
	// No extension available
	Quit "HS.SDA3.Streamlet.ClinicalRelationship"
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
<Value>Deleted</Value>
</Value>
<Value name="11">
<Value>UpdatedOn</Value>
</Value>
<Value name="12">
<Value>Clinician</Value>
</Value>
<Value name="13">
<Value>ClinicianGroup</Value>
</Value>
<Value name="14">
<Value>ExpirationDate</Value>
</Value>
<Value name="15">
<Value>FacilityCode</Value>
</Value>
<Value name="16">
<Value>CustomPairs</Value>
</Value>
<Value name="17">
<Value>StartDate</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}
