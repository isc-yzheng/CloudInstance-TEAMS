Class HS.SDA3.AbstractExplanationOfBenefit [ Abstract, NoExtent ]
{

/// 
/// ExternalId of the MemberEnrollment with the focal coverage for this claim. 
/// To generate a valid ExplanationOfBenefit FHIR resource, there must be a corresponding 
/// MemberEnrollmentNumber in the MemberEnrollment streamlet.
Property AdjudicatedCoverage As %String(MAXLEN = 450);

/// The outcome of the claim.
/// The corresponding FHIR ValueSet is http://hl7.org/fhir/ValueSet/remittance-outcome
Property AdjudicationStatus As HS.SDA3.CodeTableDetail.AdjudicationStatus;

/// Party responsible for the claim.
Property BillingProvider As HS.SDA3.CodeTableDetail.Organization;

/// The date the claim was processed by the carrier or its designee for adjudication.
Property ClaimProcessedDate As HS.SDA3.TimeStamp;

/// The category of claim, e.g. oral, pharmacy, vision, institutional, professional.
/// The corresponding FHIR ValueSet is http://hl7.org/fhir/ValueSet/claim-type
Property ClaimType As HS.SDA3.CodeTableDetail.ClaimType;

/// Indicates the in network or out of network payment status of the claim.
/// The corresponding FHIR ValueSet is http://hl7.org/fhir/us/carin-bb/ValueSet/BenefitPaymentStatus
Property InOutNetwork As HS.SDA3.CodeTableDetail.BenefitPaymentStatus;

/// ExternalIds of other MemberEnrollments that represent non-primary coverages for this claim.  
/// To generate a valid ExplanationOfBenefit FHIR resource, each number must match to a corresponding 
/// MemberEnrollmentNumber in the MemberEnrollment streamlet.
Property OtherCoverage As list Of %String(MAXLEN = 450);

/// Party responsible for reimbursement.
Property Payer As HS.SDA3.CodeTableDetail.Organization;

/// The status of the Explanation Of Benefit. In FHIR, used to track the status of the resource as 'draft' 
/// resources may undergo further edits while 'active' resources are immutable and may only have their status 
/// changed to 'cancelled'.
/// The corresponding FHIR ValueSet is http://hl7.org/fhir/ValueSet/explanationofbenefit-status
Property Status As HS.SDA3.CodeTableDetail.EOBStatus;

/// A code to indicate whether the nature of the request is: 
/// to request adjudication of products and services previously rendered; 
/// or requesting authorization and adjudication for provision in the future; 
/// or requesting the non-binding adjudication of the listed products and 
/// services which could be provided in the future.
/// The corresponding FHIR ValueSet is http://hl7.org/fhir/ValueSet/claim-use
Property Use As HS.SDA3.CodeTableDetail.ClaimUse;

}
