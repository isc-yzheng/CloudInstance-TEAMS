/// MedicalClaim is neither parsed from HL7, nor is it stored to the Viewer<br>
/// Cache. It appears in the SDA as a list property of HS.SDA3.MedicalClaim.
Class HS.SDA3.MedicalClaimLine Extends HS.SDA3.SuperClass
{

Property Extension As HS.Local.SDA3.MedicalClaimLineExtension;

/// The line number for this service on the claim. <br>
/// First line should start with 1 and each additional line incremented by 1. <br>
/// 837apP: loop2300().loop2400().LX:AssignedNumber<br>
Property LineCounter As %String;

Property PaymentReason As HS.SDA3.CodeTableDetail.PaymentReason;

/// The maximum amount contractually allowed and payable for this claim line as defined by the carrier or its designee.<br>
/// 837apP:	loop2300().loop2400().HCP:MonetaryAmount<br>
Property AllowedAmount As HS.SDA3.Numeric;

/// The amount the provider charged for the claim line service.<br>
/// 837apP:	loop2300().loop2400().SV1:MonetaryAmount<br>
Property ChargedAmount As HS.SDA3.Numeric;

/// The amount paid to the provider for this claim line.<br>
/// 837apP:	loop2300().loop2400().loop2430(1).SVD:MonetaryAmount<br>
Property PaidAmount As HS.SDA3.Numeric;

/// CMS APC methodology expected.<br>
Property APC As %String;

/// Version identifier of the APC Grouper used.<br>
Property APCVersion As %String;

/// The amount the carrier or its designee has pre-paid towards a claim line.<br>
Property PrepaidAmount As HS.SDA3.Numeric;

/// The copay amount applied to a claim line or full claim as calculated by the carrier or its designee.<br>
/// 837apP:	loop2300().loop2400().loop2430(1).CAS(1):MonetaryAmount<br>
Property CopayAmount As HS.SDA3.Numeric;

/// The coinsurance amount applied to a claim line or full claim as calculated by the carrier or its designee.<br>
/// 837apP:	loop2300().loop2400().loop2430(1).CAS(1):MonetaryAmount2<br>
Property CoinsuranceAmount As HS.SDA3.Numeric;

Property AuthorizationNumber As %String;

/// Numeric indicator that reports if a claim line requires an authorization by the carrier or its designee.<br>
/// 837apP:	loop2300().loop2400().REF(1):RefIdQualifier<br>
Property AuthorizationNeeded As %String(DISPLAYLIST = ",Yes,No,Unknown,Other,NotApplicable", VALUELIST = ",1,2,3,4,5");

/// A code that reports the final outcome of the claim line during the submission period of the carrier or its designee.<br>
/// Example: Original, Void, Replacement, Back Out, Amendment.Mbr>
Property ClaimLineType As HS.SDA3.CodeTableDetail.ClaimLineType;

Property COBAmount As HS.SDA3.Numeric;

Property CoInsuranceDays As HS.SDA3.Numeric;

/// Amount of inpatient days paid for by the carrier.<br>
/// If not available, the number of days authorized by the carrier for the admission.<br>
Property CoveredDays As HS.SDA3.Numeric;

/// The date the Member was discharged from the inpatient facility.<br>
///  Inpatient claims may or may not repeat this date on all lines.<br>
Property DischargeDate As HS.SDA3.TimeStamp;

/// Numeric indicator that reports if the claim line was denied by the claims processor.<br>
Property DeniedFlag As %String(DISPLAYLIST = ",Yes,No,Unknown,Other,NotApplicable", VALUELIST = ",1,2,3,4,5");

/// The Claim Line denial reason as assigned by the carrier or its designee.<br>
Property DeniedReasonCode As HS.SDA3.CodeTableDetail.DeniedReasonCode;

/// A numeric indicator that aligns each claim line service to a diagnosis:<br>
/// 1 for Principal Diagnosis;  2 for Other Diagnosis-1;  3 for Other Diagnosis-2, etc.<br>
/// 837apP:	loop2300().loop2400().SV1:CompositeDiagnosisCodePointe<br>
Property DiagnosticPointer As HS.SDA3.Numeric;

/// A standard NDC Code as defined by the FDA in 5-4-2 format without hyphenation.<br>
/// 837apP:	loop2300().loop2400().loop2410.LIN:ProductServiceID<br>
Property DrugCode As HS.SDA3.CodeTableDetail.DrugProduct;

/// The ICD9 External Injury code for Patients with trauma or accidents.<br>
Property ECode As HS.SDA3.CodeTableDetail.Diagnosis;

/// Numeric indicator that reports the claim line service's relation to EPSDT services.<br>
/// 837apP:	loop2300().loop2400().SV1:YesNoConditionorResponseCode2<br>
Property EPSDTIndicator As %String(DISPLAYLIST = ",Unknown,EPSDT Screen,EPSDT Treatment,EPSDT Referral", VALUELIST = ",0,1,2,3");

/// The amount that a carrier or its designee has determined to be over the plan limitations for Patient utilization.<br>
/// 837apP:	loop2300().loop2400().loop2430(1).CAS(1):MonetaryAmount<br>
Property ExcludeExpense As HS.SDA3.Numeric;

/// Numeric indicator that reports the claim line service's relation to family planning.<br>
Property FamilyPlanningIndicator As HS.SDA3.CodeTableDetail.FamilyPlanning;

/// The deductible amount applied to a claim line or full claim as calculated by the carrier or its designee.<br>
/// 837apP:	loop2300().loop2400().loop2430(1).CAS(1):MonetaryAmount<br>
Property DeductibleAmount As HS.SDA3.Numeric;

/// The amount that Medicare paid towards this claim line prior to carrier adjudication.<br>
Property MedicarePaidAmount As HS.SDA3.Numeric;

/// The amount paid to the provider for this service if the provider qualifies / meets performance guarantees.<br>                                          
Property WithholdAmount As HS.SDA3.Numeric;

Property PatientOutOfPocketAmount As HS.SDA3.Numeric;

Property OtherInsurancePaid As HS.SDA3.Numeric;

Property FinancialClaimNumber As %String;

/// The Logical Observation Identifiers, Names and Code for laboratory test / results for the claim line.<br>
Property LOINCCode As HS.SDA3.CodeTableDetail.Order;

/// Amount of inpatient days that were not paid for by the plan for the inpatient event.<br>
/// Enter 0 when not applicable.<br>
Property NonCoveredDays As HS.SDA3.Numeric;

/// The date that appears on the check and/or remit and/or explanation of benefits
/// and corresponds to any and all types of payment for this claim line (Claims paid in full, partial or zero paid).<br>
/// 837apP:	loop2300().loop2400().loop2430(1).DTP:DateTimePeriod<br>
Property ActualPaidDate As HS.SDA3.TimeStamp;

/// Numeric indicator that reports if a claim line was performed by the Patient's assigned Primary Care Provider.<br>
Property PCPIndicator As %String(DISPLAYLIST = ",Yes,No,Unknown,Other,NotApplicable", VALUELIST = ",1,2,3,4,5");

Property FacilityTypeProfessional As %String;

/// Primary ICD-9 procedure code.  The Integer point is not coded.  
/// The ICD-9 procedure must be repeated for all lines of the claim if necessary.  
/// Required for inpatient institutional claims.
Property PrimaryProcedureCode As HS.SDA3.CodeTableDetail.Procedure;

/// Numeric indicator that reports the type of procedure code expected on this claim line.<br>
/// 837apP:	loop2300().loop2400().HCP:ProductServiceIDQualifier<br>
Property ProcedureCodeType As HS.SDA3.CodeTableDetail.ProcedureCodeType;

/// The procedure code reported for this claim line.<br>
/// 837apP:	loop2300().loop2400().HCP:ProductServiceID2<br>
Property ProcedureCode As HS.SDA3.CodeTableDetail.Procedure;

/// The modifiers for the procedure code reported on this claim line.<br>
/// 837apP:	loop2300().loop2400().loop2430(1).SVD:CompositeMedicalProcedureIde.ProcedureModifier<br>
Property ProcedureModifiers As list Of %String;

/// Other ICD-9 procedure codes.<br>
/// The Integer point is not coded.<br> 
/// The ICD-9 procedure must be repeated for all lines of the claim if necessary.<br>  
/// Required for inpatient institutional claims.<br>
Property OtherProcedures As list Of HS.SDA3.CodeTableDetail.Procedure;

/// Numeric indicator that reports if a claim line requires a referral by the carrier or its designee.<br>
/// 837apP:	loop2300().loop2400().REF(1).RefIdQualifier<br>
Property ReferralIndicator As %String(DISPLAYLIST = ",Yes,No,Unknown,Other,NotApplicable", VALUELIST = ",1,2,3,4,5");

/// A standardized code that reports the revenue center of a facility where the claim line service occurred.<br>
Property RevenueCode As HS.SDA3.CodeTableDetail.Revenue;

Property SurgicalPx As list Of HS.SDA3.CodeTableDetail.Procedure;

/// Count of services/units performed.<br>
/// 837apP:	loop2300().loop2400().HCP:Quantity<br>
Property Quantity As HS.SDA3.Numeric;

/// Numeric indicator that reports if a claim line was processed / paid at In-Network rates.<br>
/// 837apP:	loop2300().loop2400().HCP:PolicyComplianceCode<br>
Property InNetworkIndicator As %String(DISPLAYLIST = ",Yes,No,Unknown,Other,NotApplicable", VALUELIST = ",1,2,3,4,5");

/// 837apP:	loop2300().loop2400().loop2420F(1).REF(1):RefIdQualifier<br>
/// 837apP:	loop2300().loop2400().loop2420F(1).REF(1):RefId<br>
Property ReferringProvider As HS.SDA3.CodeTableDetail.CareProvider;

Property ServiceProvider As HS.SDA3.CodeTableDetail.CareProvider;

/// List of health funds associated with the claim line<br><br>
Property HealthFunds As list Of HS.SDA3.HealthFund;

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
<Value>LineCounter</Value>
</Value>
<Value name="14">
<Value>PaymentReason</Value>
</Value>
<Value name="15">
<Value>AllowedAmount</Value>
</Value>
<Value name="16">
<Value>ChargedAmount</Value>
</Value>
<Value name="17">
<Value>PaidAmount</Value>
</Value>
<Value name="18">
<Value>APC</Value>
</Value>
<Value name="19">
<Value>APCVersion</Value>
</Value>
<Value name="20">
<Value>PrepaidAmount</Value>
</Value>
<Value name="21">
<Value>CopayAmount</Value>
</Value>
<Value name="22">
<Value>CoinsuranceAmount</Value>
</Value>
<Value name="23">
<Value>AuthorizationNumber</Value>
</Value>
<Value name="24">
<Value>AuthorizationNeeded</Value>
</Value>
<Value name="25">
<Value>ClaimLineType</Value>
</Value>
<Value name="26">
<Value>COBAmount</Value>
</Value>
<Value name="27">
<Value>CoInsuranceDays</Value>
</Value>
<Value name="28">
<Value>CoveredDays</Value>
</Value>
<Value name="29">
<Value>DischargeDate</Value>
</Value>
<Value name="30">
<Value>DeniedFlag</Value>
</Value>
<Value name="31">
<Value>DeniedReasonCode</Value>
</Value>
<Value name="32">
<Value>DiagnosticPointer</Value>
</Value>
<Value name="33">
<Value>DrugCode</Value>
</Value>
<Value name="34">
<Value>ECode</Value>
</Value>
<Value name="35">
<Value>EPSDTIndicator</Value>
</Value>
<Value name="36">
<Value>ExcludeExpense</Value>
</Value>
<Value name="37">
<Value>FamilyPlanningIndicator</Value>
</Value>
<Value name="38">
<Value>DeductibleAmount</Value>
</Value>
<Value name="39">
<Value>MedicarePaidAmount</Value>
</Value>
<Value name="40">
<Value>WithholdAmount</Value>
</Value>
<Value name="41">
<Value>PatientOutOfPocketAmount</Value>
</Value>
<Value name="42">
<Value>OtherInsurancePaid</Value>
</Value>
<Value name="43">
<Value>FinancialClaimNumber</Value>
</Value>
<Value name="44">
<Value>LOINCCode</Value>
</Value>
<Value name="45">
<Value>NonCoveredDays</Value>
</Value>
<Value name="46">
<Value>ActualPaidDate</Value>
</Value>
<Value name="47">
<Value>PCPIndicator</Value>
</Value>
<Value name="48">
<Value>FacilityTypeProfessional</Value>
</Value>
<Value name="49">
<Value>PrimaryProcedureCode</Value>
</Value>
<Value name="50">
<Value>ProcedureCodeType</Value>
</Value>
<Value name="51">
<Value>ProcedureCode</Value>
</Value>
<Value name="52">
<Value>ProcedureModifiers</Value>
</Value>
<Value name="53">
<Value>OtherProcedures</Value>
</Value>
<Value name="54">
<Value>ReferralIndicator</Value>
</Value>
<Value name="55">
<Value>RevenueCode</Value>
</Value>
<Value name="56">
<Value>SurgicalPx</Value>
</Value>
<Value name="57">
<Value>Quantity</Value>
</Value>
<Value name="58">
<Value>InNetworkIndicator</Value>
</Value>
<Value name="59">
<Value>ReferringProvider</Value>
</Value>
<Value name="60">
<Value>ServiceProvider</Value>
</Value>
<Value name="61">
<Value>HealthFunds</Value>
</Value>
<Value name="62">
<Value>Extension</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}
