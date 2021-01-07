/// At present, Referrals are not parsed from HL7. This class contains<br>
/// "possible" HL7 annotations, indicating that these mappings from HL7 do not<br>
/// yet exist, but potentially could someday. (prodlog 119135)
Class HS.SDA3.Referral Extends HS.SDA3.SuperClass
{

Property Extension As HS.Local.SDA3.ReferralExtension;

/// The originating application's permanent identifier for the referral<br>
/// Possible HL7:  RF1-6 : OriginatingReferralIdentifier<br><br>
/// VIEWERLIB: Not stored	
Property PlacerId As %String(MAXLEN = 220);

/// The identifier assigned to the referral by the referred-to provider<br>
/// Possible HL7:  RF1-11 : ExternalReferralIdentifier<br><br>
/// VIEWERLIB: Not stored
Property FillerId As %String(MAXLEN = 220);

/// The reason for which the referral will take place<br>
/// Possible HL7:  RF1-10 : ReferralReason<br><br>
/// VIEWERLIB: Not stored
Property ReferralReason As %String(MAXLEN = 32767);

/// The care provider initiating the referral<br>
/// From HL7, the ReferringProvider would be given by the PRD segment with<br>
/// PRD-1.1 (ProviderRole.Indentifier) = "RP" for "Referring Provider".<br>
/// Possible HL7:  PRD<br><br>
/// VIEWERLIB: Not stored
Property ReferringProvider As HS.SDA3.CodeTableDetail.CareProvider;

/// The facility from which the referral originated<br>
/// Possible HL7:  PRD-4 : ProviderLocation<br><br>
/// VIEWERLIB: Not stored
Property ReferringOrganization As HS.SDA3.CodeTableDetail.HealthCareFacility;

/// The care provider to whom the patient is referred<br>
/// From HL7, the ReferredToProvider would be given by the PRD segment with<br>
/// PRD-1.1 (ProviderRole.Indentifier) = "RT" for "Referred to Provider".<br>
/// Possible HL7:  PRD<br><br>
/// VIEWERLIB: Not stored
Property ReferredToProvider As HS.SDA3.CodeTableDetail.CareProvider;

/// The facility to which the patient is referred<br>
/// Possible HL7:  PRD-4 : ProviderLocation<br><br>
/// VIEWERLIB: Not stored
Property ReferredToOrganization As HS.SDA3.CodeTableDetail.HealthCareFacility;

/// The length of time the referral is valid from the date of the first<br>
/// patient/referee encounter.<br><br>
/// VIEWERLIB: Not stored
Property ValidityDuration As HS.SDA3.CodeTableDetail.Duration;

/// The date on which the referral originated<br>
/// Possible HL7:  RF1-9 : ProcessDate<br><br>
/// VIEWERLIB: Not stored
Property EnteredOn As HS.SDA3.TimeStamp;

/// The date on which the referral is effective<br>
/// Possible HL7:  RF1-7 : EffectiveDate<br><br>
/// VIEWERLIB: Not stored
Property FromTime As HS.SDA3.TimeStamp;

/// The date on which the referral expires<br>
/// Possible HL7:  RF1-8 : ExpirationDate<br><br>
/// VIEWERLIB: Not stored
Property ToTime As HS.SDA3.TimeStamp;

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
<Value>PlacerId</Value>
</Value>
<Value name="14">
<Value>FillerId</Value>
</Value>
<Value name="15">
<Value>ReferralReason</Value>
</Value>
<Value name="16">
<Value>ReferringProvider</Value>
</Value>
<Value name="17">
<Value>ReferredToProvider</Value>
</Value>
<Value name="18">
<Value>ReferredToOrganization</Value>
</Value>
<Value name="19">
<Value>ValidityDuration</Value>
</Value>
<Value name="20">
<Value>ReferringOrganization</Value>
</Value>
<Value name="21">
<Value>Extension</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}
