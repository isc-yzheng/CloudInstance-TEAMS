/// Administration appears in the SDA as a list property (Administrations) of<br>
/// HS.SDA3.Medication and HS.SDA3.Vaccination. Administrations are not loaded<br>
/// into the Viewer Cache.
Class HS.SDA3.Administration Extends HS.SDA3.SuperClass
{

Property Extension As HS.Local.SDA3.AdministrationExtension;

/// Notes on the administration<br>
/// Length subject to the total streamlet size limit - 3,000,000<br><br>
/// HL7ToSDA3:<br>
/// RXA-9 is a coded, repeating field. For each non-null instance of the field,<br>
/// HL7ToSDA3 will parse Text (piece 2), or Identifier (piece 1) if Text is<br>
/// null, on a new, CRLF-delimited line.<br><br>
/// HL7:  RXA-9 : AdministrationNotes<br>
/// VIEWERLIB: Not stored<br>
Property AdministrationNotes As %String(MAXLEN = "");

/// Care provider who did the administration<br><br>
/// HL7:  RXA-10 : AdministeringProvider<br>
/// SDATableName=CareProvider, ViewerClass=User.HS.CTCareProv<br>
/// VIEWERLIB: Not stored<br><br>
/// .Name.FamilyName<br>
/// HL7:  RXA-10.2.1 : FamilyNameSurname<br>
/// .Name.GivenName<br>
/// HL7:  RXA-10.3 : GivenName<br>
/// .Name.MiddleName<br>
/// HL7:  RXA-10.4 : MiddleName<br>
/// .Name.NamePrefix<br>
/// HL7:  RXA-10.6 : NamePrefix<br>
/// .Name.NameSuffix<br>
/// HL7:  RXA-10.7 : Degree<br>
Property AdministeringProvider As HS.SDA3.CodeTableDetail.CareProvider;

/// The location at which the administration took place.<br><br>
/// HL7ToSDA3:<br>
/// RXA-11.1 is parsed to the AdministeredAtLocation Code. HL7ToSDA3 does not<br>
/// set the Description.<br><br>
/// SDATableName=HealthCareFacility, ViewerClass=User.HS.CTLoc<br>
/// HL7:  RXA-11.1 : AdministeredatLocation.PointOfCare
/// VIEWERLIB: Not stored
Property AdministeredAtLocation As HS.SDA3.CodeTableDetail.HealthCareFacility;

/// The completion status of the administration<br><br>
/// HL7ToSDA3:<br>
/// RXA-20 is parsed to the AdministrationStatus Code. HL7ToSDA3 does not set<br>
/// the Description.<br><br>
/// HL7:  RXA-20 : CompletionStatus<br>
/// VIEWERLIB: Not stored<br>
Property AdministrationStatus As HS.SDA3.CodeTableDetail.AdministrationStatus;

/// The amount of medication administered<br><br>
/// HL7:  RXA-6 : AdministeredAmount<br>
/// VIEWERLIB: Not stored
Property AdministeredAmount As %String;

/// The number of units of medication administered<br><br>
/// HL7ToSDA3:<br>
/// RXA-7 is a coded field. HL7ToSDA3 will get the value from Text (subfield<br>
/// 2), or Identifier (subfield 1) if Text is null.<br><br>
/// HL7:  RXA-7 : AdministeredUnits<br>
/// VIEWERLIB: Not stored
Property AdministeredUnits As %String;

/// The lot number of the medication administered<br><br>
/// HL7ToSDA3:<br>
/// Though RXA-15 is a repeating field, HL7ToSDA3 will only use the first<br>
/// instance.<br><br>
/// HL7:  RXA-15 : SubstanceLotNumber<br>
/// VIEWERLIB: Not stored
Property LotNumber As %String;

/// The expiry date of the medication administered<br><br>
/// HL7ToSDA3:<br>
/// Though RXA-16 is a repeating field, HL7ToSDA3 will only use the first<br>
/// instance.<br><br>
/// HL7:  RXA-16.1 : SubstanceExpirationDate.Time<br>
/// VIEWERLIB: Not stored
Property ExpiryDate As HS.SDA3.TimeStamp;

/// The manufacturer of the medication administered<br><br>
/// HL7ToSDA3:<br>
/// Though RXA-17 is a repeating field, HL7ToSDA3 will only use the first<br>
/// non-null instance. RXA-17 is also a coded field. HL7ToSDA3 will use Text<br>
/// (piece 2), or Identifier (piece 1) if Text is null.<br><br>
/// HL7:  RXA-17 : SubstanceManufacturerName<br>
/// VIEWERLIB: Not stored
Property ManufacturerName As %String(MAXLEN = 32000);

/// Substance/Treatment Refusal Reason<br><br>
/// HL7ToSDA3:<br>
/// RXA-18 will only be parsed if subfield 1 is not null.<br><br>
/// HL7:  RXA-18 : SubstanceTreatmentRefusalReason<br>
/// VIEWERLIB: Not stored<br><br>
/// .Code<br>
/// HL7:  RXA-18.1 : SubstanceTreatmentRefusalReason.Identifier<br>
/// .Description<br>
/// HL7:  RXA-18.2 : SubstanceTreatmentRefusalReason.Text<br>
/// .SDACodingStandard<br>
/// HL7:  RXA-18.3 : SubstanceTreatmentRefusalReason.NameofCodingSystem<br>
Property RefusalReason As HS.SDA3.CodeTableDetail.RefusalReason;

/// Location a vaccine was administered (e.g. Left Arm)<br><br>
/// HL7ToSDA3:<br>
/// RXR-2 will only be parsed if subfield 1 or 2 is not null.<br><br>
/// HL7:  RXR-2 : AdministrationSite<br>
/// VIEWERLIB: Not stored<br><br>
/// .Code<br>
/// HL7:  RXR-2.1 : AdministrationSite.Identifier<br>
/// .Description<br>
/// HL7:  RXR-2.2 : AdministrationSite.Text<br>
/// .SDACodingStandard<br>
/// HL7:  RXR-2.3 : AdministrationSite.NameofCodingSystem<br>
Property AdministrationSite As HS.SDA3.CodeTableDetail.AdministrationSite;

/// HL7:  RXA-22.1 : SystemEntryDateTime.Time<br>
/// VIEWERLIB: Not stored<br>
Property EnteredOn As HS.SDA3.TimeStamp;

/// Start time of administration of medication<br><br>
/// HL7:  RXA-3.1 : DateTimeStartofAdministration.Time<br>
/// VIEWERLIB: Not stored
Property FromTime As HS.SDA3.TimeStamp;

/// End time of administration of medication<br><br>
/// HL7:  RXA-4.1 : DateTimeEndofAdministration.Time<br>
/// VIEWERLIB: Not stored
Property ToTime As HS.SDA3.TimeStamp;

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
<Value>CustomPairs</Value>
</Value>
<Value name="13">
<Value>AdministrationNotes</Value>
</Value>
<Value name="14">
<Value>AdministeringProvider</Value>
</Value>
<Value name="15">
<Value>AdministeredAtLocation</Value>
</Value>
<Value name="16">
<Value>AdministrationStatus</Value>
</Value>
<Value name="17">
<Value>AdministeredAmount</Value>
</Value>
<Value name="18">
<Value>AdministeredUnits</Value>
</Value>
<Value name="19">
<Value>LotNumber</Value>
</Value>
<Value name="20">
<Value>ExpiryDate</Value>
</Value>
<Value name="21">
<Value>ManufacturerName</Value>
</Value>
<Value name="22">
<Value>RefusalReason</Value>
</Value>
<Value name="23">
<Value>AdministrationSite</Value>
</Value>
<Value name="24">
<Value>Extension</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}
