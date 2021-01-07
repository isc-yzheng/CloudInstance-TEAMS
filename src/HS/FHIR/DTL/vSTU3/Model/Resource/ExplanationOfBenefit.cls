/// This resource provides: the claim details; 
/// adjudication details from the processing of a Claim; 
/// and optionally account balance information, 
/// for informing the subscriber of the benefits provided.
Class HS.FHIR.DTL.vSTU3.Model.Resource.ExplanationOfBenefit Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Business Identifier.
Property identifier As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// active | cancelled | draft | entered-in-error
/// <p>
/// explanationofbenefit-status is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend explanationofbenefit-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Type or discipline.
/// <p>
/// claim-type is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend claim-type and you may NOT use codes from other ValueSets.
Property type As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Finer grained claim type information.
/// <p>
/// any FHIR3 code may be used; 
/// claim-subtype shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property subType As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "subType", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// The subject of the Products and Services.
/// <p>
/// Patient
Property patient As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "patient", XMLPROJECTION = "ELEMENT");

/// Period
/// <p>
/// Period for charge submission.
Property billablePeriod As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "billablePeriod", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// Creation date.
Property created As %String(MAXLEN = 1000000, XMLNAME = "created", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Author.
/// <p>
/// Practitioner
Property enterer As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "enterer", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Insurer responsible for the EOB.
/// <p>
/// Organization
Property insurer As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "insurer", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Responsible provider for the claim.
/// <p>
/// Practitioner
Property provider As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "provider", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Responsible organization for the claim.
/// <p>
/// Organization
Property organization As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "organization", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Treatment Referral.
/// <p>
/// ReferralRequest
Property referral As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "referral", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Servicing Facility.
/// <p>
/// Location
Property facility As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "facility", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Claim reference.
/// <p>
/// Claim
Property claim As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "claim", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Claim response reference.
/// <p>
/// ClaimResponse
Property claimResponse As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "claimResponse", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// complete | error | partial
/// <p>
/// any FHIR3 code may be used; 
/// remittance-outcome shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property outcome As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "outcome", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Disposition Message.
Property disposition As %String(MAXLEN = 1000000, XMLNAME = "disposition", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Related Claims which may be revelant to processing this claim.
Property related As list Of HS.FHIR.DTL.vSTU3.Model.Element.ExplanationOfBenefit.related(XMLNAME = "related", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Prescription authorizing services or products.
/// <p>
/// MedicationRequest | VisionPrescription
Property prescription As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "prescription", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Original prescription if superceded by fulfiller.
/// <p>
/// MedicationRequest
Property originalPrescription As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "originalPrescription", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Party to be paid any benefits payable.
Property payee As HS.FHIR.DTL.vSTU3.Model.Element.ExplanationOfBenefit.payee(XMLNAME = "payee", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Exceptions, 
/// special considerations, 
/// the condition, 
/// situation, 
/// prior or concurrent issues.
Property information As list Of HS.FHIR.DTL.vSTU3.Model.Element.ExplanationOfBenefit.information(XMLNAME = "information", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Care Team members.
Property careTeam As list Of HS.FHIR.DTL.vSTU3.Model.Element.ExplanationOfBenefit.careTeam(XMLNAME = "careTeam", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// List of Diagnosis.
Property diagnosis As list Of HS.FHIR.DTL.vSTU3.Model.Element.ExplanationOfBenefit.diagnosis(XMLNAME = "diagnosis", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Procedures performed.
Property procedure As list Of HS.FHIR.DTL.vSTU3.Model.Element.ExplanationOfBenefit.procedure(XMLNAME = "procedure", XMLPROJECTION = "ELEMENT");

/// positiveInt
/// <p>
/// Precedence (primary, 
/// secondary, 
/// etc.)
Property precedence As %Integer(XMLNAME = "precedence", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Insurance or medical plan.
Property insurance As HS.FHIR.DTL.vSTU3.Model.Element.ExplanationOfBenefit.insurance(XMLNAME = "insurance", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Details of an accident.
Property accident As HS.FHIR.DTL.vSTU3.Model.Element.ExplanationOfBenefit.accident(XMLNAME = "accident", XMLPROJECTION = "ELEMENT");

/// Period
/// <p>
/// Period unable to work.
Property employmentImpacted As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "employmentImpacted", XMLPROJECTION = "ELEMENT");

/// Period
/// <p>
/// Period in hospital.
Property hospitalization As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "hospitalization", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Goods and Services.
Property item As list Of HS.FHIR.DTL.vSTU3.Model.Element.ExplanationOfBenefit.item(XMLNAME = "item", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Insurer added line items.
Property addItem As list Of HS.FHIR.DTL.vSTU3.Model.Element.ExplanationOfBenefit.addItem(XMLNAME = "addItem", XMLPROJECTION = "ELEMENT");

/// Money
/// <p>
/// Total Cost of service from the Claim.
Property totalCost As HS.FHIR.DTL.vSTU3.Model.Datatype.Money(XMLNAME = "totalCost", XMLPROJECTION = "ELEMENT");

/// Money
/// <p>
/// Unallocated deductable.
Property unallocDeductable As HS.FHIR.DTL.vSTU3.Model.Datatype.Money(XMLNAME = "unallocDeductable", XMLPROJECTION = "ELEMENT");

/// Money
/// <p>
/// Total benefit payable for the Claim.
Property totalBenefit As HS.FHIR.DTL.vSTU3.Model.Datatype.Money(XMLNAME = "totalBenefit", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Payment (if paid)
Property payment As HS.FHIR.DTL.vSTU3.Model.Element.ExplanationOfBenefit.payment(XMLNAME = "payment", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Printed Form Identifier.
/// <p>
/// any FHIR3 code may be used; 
/// forms shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property form As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "form", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Processing notes.
Property processNote As list Of HS.FHIR.DTL.vSTU3.Model.Element.ExplanationOfBenefit.processNote(XMLNAME = "processNote", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Balance by Benefit Category.
Property benefitBalance As list Of HS.FHIR.DTL.vSTU3.Model.Element.ExplanationOfBenefit.benefitBalance(XMLNAME = "benefitBalance", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ExplanationOfBenefit";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ExplanationOfBenefit";

}
