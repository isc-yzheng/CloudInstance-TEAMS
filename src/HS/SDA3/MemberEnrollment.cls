/// MemberEnrollment is neither parsed from HL7, nor is it stored to the Viewer Cache.
Class HS.SDA3.MemberEnrollment Extends HS.SDA3.SuperClass
{

Property Extension As HS.Local.SDA3.MemberEnrollmentExtension;

/// A unique string to identify Member Enrollment <br>
/// For 834, it takes the form  payerIdCode_subscriberId_memberId_coveragePeriod: <br>
/// payerIdCode: loop1000B.N1 <br>
/// subscriberId: loop2000.REF():RefId <br>
/// memberId: loop2000.REF():RefId <br>
/// coveragePeriod: loop2000.loop2300().DTP() <br>
Property MemberEnrollmentNumber As %String;

/// The source, e.g., 834 etc.
Property Source As %String;

/// Unique, internal identification assigned by the carrier or its designee to the Member.<br>
/// This can be used to link Claim Lines to eligibility segments.<br>
Property CarrierSpecificMemberID As %String;

Property SuffixOrSequenceNumber As %String;

Property Business As HS.SDA3.CodeTableDetail.Business;

/// A code that defines the type of insurance applied to the claim line.  <br>
/// This value can be derived from the claim as submitted by the provider or reassigned by the carrier or its designee. <br>
Property InsuranceTypeOrProductCode As HS.SDA3.CodeTableDetail.InsuranceType;

/// A code that reports relationships which are covered under the benefits during the time-period of this eligibility segment.<br>
Property CoverageLevelCode As HS.SDA3.CodeTableDetail.CoverageLevel;

/// Numeric indicator to define the Member's relationship to the Subscriber.<br>
/// 834:	loop2000().INS:IndividualRelationshipCode<br>
Property IndividualRelationshipCode As HS.SDA3.CodeTableDetail.Relationship;

/// <p>
/// Deprecated. Use either the InsuredGroup property, or the PolicyPlan property.
/// </p><p>
/// Deprecated property description:
/// The carrier assigned group / policy number for this claim line.<br> 
/// This information is often filed as reported by the provider.<br>
/// 834:	loop2000().REF():RefId<br>
/// </p>
Property InsuredGroupOrPolicyNumber As %String;

/// Numeric indicator that reports if the Member has medical coverage as a benefit during the time-period of this eligibility segment.<br>
Property MedicalCoverage As %String(DISPLAYLIST = ",Yes,No,Unknown,Other,NotApplicable", VALUELIST = ",1,2,3,4,5");

/// Numeric indicator that reports if the Member has dental coverage as a benefit during the time-period of this eligibility segment.<br>
Property DentalCoverage As %String(DISPLAYLIST = ",Yes,No,Unknown,Other,NotApplicable", VALUELIST = ",1,2,3,4,5");

/// Numeric indicator that reports if the Member has prescription drug coverage as a benefit during the time-period of this eligibility segment.<br>
Property PrescriptionCoverage As %String(DISPLAYLIST = ",Yes,No,Unknown,Other,NotApplicable", VALUELIST = ",1,2,3,4,5");

/// Numeric indicator that reports if the Member's eligibility is for primary insurance during the time-period of this eligibility segment.<br>
Property PrimaryInsuranceIndicator As %String(DISPLAYLIST = ",Yes,No,Unknown,Other,NotApplicable", VALUELIST = ",1,2,3,4,5");

/// A code that reports the risk-type of the carrier the Member is covered under during the time-period stated on this eligibility segment.<br>
Property CoverageType As HS.SDA3.CodeTableDetail.CoverageType;

/// A code that reports the market the policy is sold into by the carrier or its designee during the time-period of this eligibility segment.<br>
/// Use this code to map to individuals and group sizes.<br>
Property MarketCategoryCode As HS.SDA3.CodeTableDetail.MarketCategory;

/// A code that reports special coverage type under Commonwealth Care or the Health Safety Net during the time-period of this eligibility segment.<br>
/// Value of N/A indicates any other type of coverage.<br>
Property SpecialCoverage As HS.SDA3.CodeTableDetail.SpecialCoverage;

/// Unique, internal identification assigned by the carrier or its designee to the Subscriber.<br>
/// This can be used to link Claim Lines to eligibility segments.<br>
/// 834:	loop2000().REF():RefId<br>
Property PlanSpecificSubscriberID As %String;

/// Tax ID of the Subscriber.<br>
Property SubscriberSSNOrProxy As %String;

/// This is a unique identifier as outlined
/// by Centers for Medicare and
/// Medicaid Services (CMS) for Plans
/// or Sub plans
/// 834:	loop2000().loop2300().REF(1):RefId<br>
Property NationalPlanID As %String;

Property Guarantor As HS.SDA3.Guarantor;

Property HealthFund As HS.SDA3.HealthFund;

/// Primary Care Provider
/// 834: loop2000().loop2300().loop2310()
Property PrimaryCareProvider As HS.SDA3.CodeTableDetail.CareProvider;

/// Primary Care Facility
Property PrimaryCareFacility As HS.SDA3.CodeTableDetail.HealthCareFacility;

/// Employer account identifier.
Property InsuredGroup As HS.SDA3.CodeTableDetail.InsuredGroup;

/// Business concept used by a health plan to describe its benefit offerings.
Property PolicyPlan As HS.SDA3.CodeTableDetail.PolicyPlan;

/// <p>
/// Identifies the status of the coverage information for the FHIR Coverage resource.
/// </p><p>
/// To conform to the FHIR CARIN Blue Button Implementation Profiles, 
/// the Status.Code property requires the value set defined at http://hl7.org/fhir/ValueSet/fm-status. 
/// Refer to the HealthShare documentation for information on translating local codes into defined value sets.
/// </p><p>
/// When no value is supplied, the default is "active".
/// </p>
Property Status As HS.SDA3.CodeTableDetail.FinancialResourceStatus;

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
<Value>MemberEnrollmentNumber</Value>
</Value>
<Value name="14">
<Value>Source</Value>
</Value>
<Value name="15">
<Value>CarrierSpecificMemberID</Value>
</Value>
<Value name="16">
<Value>SuffixOrSequenceNumber</Value>
</Value>
<Value name="17">
<Value>Business</Value>
</Value>
<Value name="18">
<Value>InsuranceTypeOrProductCode</Value>
</Value>
<Value name="19">
<Value>CoverageLevelCode</Value>
</Value>
<Value name="20">
<Value>IndividualRelationshipCode</Value>
</Value>
<Value name="21">
<Value>InsuredGroupOrPolicyNumber</Value>
</Value>
<Value name="22">
<Value>MedicalCoverage</Value>
</Value>
<Value name="23">
<Value>DentalCoverage</Value>
</Value>
<Value name="24">
<Value>PrescriptionCoverage</Value>
</Value>
<Value name="25">
<Value>PrimaryInsuranceIndicator</Value>
</Value>
<Value name="26">
<Value>CoverageType</Value>
</Value>
<Value name="27">
<Value>MarketCategoryCode</Value>
</Value>
<Value name="28">
<Value>SpecialCoverage</Value>
</Value>
<Value name="29">
<Value>PlanSpecificSubscriberID</Value>
</Value>
<Value name="30">
<Value>SubscriberSSNOrProxy</Value>
</Value>
<Value name="31">
<Value>NationalPlanID</Value>
</Value>
<Value name="32">
<Value>Guarantor</Value>
</Value>
<Value name="33">
<Value>HealthFund</Value>
</Value>
<Value name="34">
<Value>PrimaryCareProvider</Value>
</Value>
<Value name="35">
<Value>PrimaryCareFacility</Value>
</Value>
<Value name="36">
<Value>Extension</Value>
</Value>
<Value name="37">
<Value>InsuredGroup</Value>
</Value>
<Value name="38">
<Value>PolicyPlan</Value>
</Value>
<Value name="39">
<Value>Status</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}
