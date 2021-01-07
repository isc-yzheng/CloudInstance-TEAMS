/// MedicalClaim is neither parsed from HL7, nor is it stored to the Viewer Cache.
Class HS.SDA3.MedicalClaim Extends (HS.SDA3.SuperClass, HS.SDA3.AbstractClaim)
{

Property Extension As HS.Local.SDA3.MedicalClaimExtension;

/// Unique identifier within the payer's system that applies to the entire claim. <br>
/// 837apP:	loop2300().CLM:ClaimSubmittersIdentifier<br>
Property MedicalClaimNumber As %String;

/// The APCD filing-type identifier that defines the data contained within the file.<br>
Property RecordType As %String;

Property SubmissionDate As HS.SDA3.TimeStamp;

/// Incrementing counter for a claim line that is reprocessed for any reason over the course of time.<br>
/// Highest value should indicate latest reprocessing of line by the carrier/submitter.<br>
Property Version As HS.SDA3.Numeric;

/// A standardized code that reports the admission source of the Patient into an inpatient setting/facility <br>
/// and indicates how the Patient was referred into the inpatient setting.<br>
Property AdmissionSource As HS.SDA3.CodeTableDetail.AdmissionSource;

/// A standardized, numeric code that reports the type of admission into an inpatient setting.<br>
Property AdmissionType As HS.SDA3.CodeTableDetail.AdmissionType;

/// The date that the Patient was admitted into an inpatient setting at the facility.<br>
Property AdmissionDate As HS.SDA3.TimeStamp;

/// Numeric indicator that reports if a claim line was processed / paid under a global payment arrangement.<br>
/// 837apP:	loop2300().CN1:ContractTypeCode<br>
Property GlobalPaymentFlag As %String(DISPLAYLIST = ",Yes,No,Unknown,Other,NotApplicable", VALUELIST = ",1,2,3,4,5");

/// Numeric indicator that reports if a claim line is covered under a capitation arrangement.<br>
Property CapitatedEncounterFlag As %String(DISPLAYLIST = ",Yes,No,Unknown,Other,NotApplicable", VALUELIST = ",1,2,3,4,5");

/// Numeric indicator that reports if the claim line was paid by the carrier or its designee, and the COB order of the payment.<br>
Property ClaimStatus As HS.SDA3.CodeTableDetail.ClaimStatus;

Property DelegatedBenefitAdminOrgID As %String;

/// A standardized, numeric code that reports the discharge status of the Patient.<br>
Property DischargeStatus As HS.SDA3.CodeTableDetail.DischargeStatus;

/// CMS methodology when available.<br>
/// When the CMS methodology for DRGs is not available, but the All Payer DRG system is used,<br>
/// the insurer shall format the DRG and the complexity level within the same field with an "A" prefix,<br> 
/// and with a hyphen separating the DRG and the complexity level (e.g. AXXX-XX).<br>
Property DRG As %String;

/// Severity adjustment level when applicable.<br>
Property DRGLevel As %String;

/// Version identifier of the DRG Grouper used.<br>
Property DRGVersion As %String;

/// Diagnostic code assigned by the provider to support admission into an inpatient setting at the facility<br>
/// reported in Plan Rendering Provider ID and Provider Location.<br>
Property AdmissionDiagnosis As HS.SDA3.CodeTableDetail.Diagnosis;

/// The ICD9 diagnosis code assigned to the Patient upon discharge.<br>
Property DischargeDiagnosis As HS.SDA3.CodeTableDetail.Diagnosis;

/// Primary ICD9 Diagnosis Code.<br>
/// 837apP: loop2300().HI():HealthCareCodeInformation2<br>
Property PrincipalDiagnosis As HS.SDA3.CodeTableDetail.Diagnosis;

/// Other ICD9 Diagnosis Codes.<br> 
/// 837apP: loop2300().HI():HealthCareCodeInformation2<br>
Property OtherDiagnoses As list Of HS.SDA3.CodeTableDetail.Diagnosis;

/// Numeric indicator that reports if the claim line has any Medicare payments applied towards it as a Prior Payer on the claim.<br>
Property MedicareIndicator As %String(DISPLAYLIST = ",Yes,No,Unknown,Other,NotApplicable", VALUELIST = ",1,2,3,4,5");

/// Numeric indicator that reports if the claim line procedure was performed due to an accident (not employment based).<br>
Property AccidentIndicator As %String(DISPLAYLIST = ",Yes,No,Unknown,Other,NotApplicable", VALUELIST = ",1,2,3,4,5");

Property PatientAccount As %String;

Property SiteNumber As %String;

Property AttendingProvider As HS.SDA3.CodeTableDetail.CareProvider;

/// Report CHIA defined, unique
/// Submitter ID here. TR002 must
/// match the Submitter ID reported
/// here. This ID is linked to other
/// elements in the file for quality control
/// 837apP:	loop1000A.NM1:IdentificationCode<br>
Property Submitter As %String;

/// For Institutional Claims: a standardized code that reports the type of facility where the claim line service occurred. <br>
Property TypeOfBillInstitutional As %String;

/// Numeric indicator that reports if the claim line procedure was performed due to an employment related accident.<br>
/// 837apP:	loop2300().CLM:RelatedCausesInformation.RelatedCausesCode<br>
Property EmploymentRelatedIndicator As %String(DISPLAYLIST = ",Yes,No,Unknown,Other,NotApplicable", VALUELIST = ",1,2,3,4,5");

/// Subscriber
/// 837apP:	loop2000A().loop2000B()<br>
Property Subscriber As HS.SDA3.Guarantor;

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
<Value>MedicalClaimNumber</Value>
</Value>
<Value name="14">
<Value>RecordType</Value>
</Value>
<Value name="15">
<Value>SubmissionDate</Value>
</Value>
<Value name="16">
<Value>Version</Value>
</Value>
<Value name="17">
<Value>AdmissionSource</Value>
</Value>
<Value name="18">
<Value>AdmissionType</Value>
</Value>
<Value name="19">
<Value>AdmissionDate</Value>
</Value>
<Value name="20">
<Value>GlobalPaymentFlag</Value>
</Value>
<Value name="21">
<Value>CapitatedEncounterFlag</Value>
</Value>
<Value name="22">
<Value>ClaimProcessedDate</Value>
</Value>
<Value name="23">
<Value>ClaimStatus</Value>
</Value>
<Value name="24">
<Value>DelegatedBenefitAdminOrgID</Value>
</Value>
<Value name="25">
<Value>DischargeStatus</Value>
</Value>
<Value name="26">
<Value>DRG</Value>
</Value>
<Value name="27">
<Value>DRGLevel</Value>
</Value>
<Value name="28">
<Value>DRGVersion</Value>
</Value>
<Value name="29">
<Value>AdmissionDiagnosis</Value>
</Value>
<Value name="30">
<Value>DischargeDiagnosis</Value>
</Value>
<Value name="31">
<Value>PrincipalDiagnosis</Value>
</Value>
<Value name="32">
<Value>OtherDiagnoses</Value>
</Value>
<Value name="33">
<Value>MedicareIndicator</Value>
</Value>
<Value name="34">
<Value>FormerClaimNumber</Value>
</Value>
<Value name="35">
<Value>AccidentIndicator</Value>
</Value>
<Value name="36">
<Value>PatientAccount</Value>
</Value>
<Value name="37">
<Value>SiteNumber</Value>
</Value>
<Value name="38">
<Value>AttendingProvider</Value>
</Value>
<Value name="39">
<Value>ReceivedDate</Value>
</Value>
<Value name="40">
<Value>Submitter</Value>
</Value>
<Value name="41">
<Value>TypeOfBillInstitutional</Value>
</Value>
<Value name="42">
<Value>EmploymentRelatedIndicator</Value>
</Value>
<Value name="43">
<Value>Subscriber</Value>
</Value>
<Value name="44">
<Value>MedicalClaimLines</Value>
</Value>
<Value name="45">
<Value>Extension</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}
