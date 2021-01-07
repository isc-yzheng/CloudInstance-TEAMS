/// A provider issued list of services and products provided, 
/// or to be provided, 
/// to a patient which is provided to an insurer for payment recovery.
Class HS.FHIR.DTL.vSTU3.Model.Resource.Claim Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Claim number.
Property identifier As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// active | cancelled | draft | entered-in-error
/// <p>
/// fm-status is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend fm-status and you may NOT use codes from other ValueSets.
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

/// code
/// <p>
/// complete | proposed | exploratory | other
/// <p>
/// claim-use is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend claim-use and you may NOT use codes from other ValueSets.
Property use As %String(MAXLEN = 1000000, XMLNAME = "use", XMLPROJECTION = "ATTRIBUTE");

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
/// Target.
/// <p>
/// Organization
Property insurer As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "insurer", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Responsible provider.
/// <p>
/// Practitioner
Property provider As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "provider", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Responsible organization.
/// <p>
/// Organization
Property organization As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "organization", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Desired processing priority.
/// <p>
/// any FHIR3 code may be used; 
/// process-priority shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property priority As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "priority", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Funds requested to be reserved.
/// <p>
/// any FHIR3 code may be used; 
/// fundsreserve shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property fundsReserve As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "fundsReserve", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Related Claims which may be revelant to processing this claimn.
Property related As list Of HS.FHIR.DTL.vSTU3.Model.Element.Claim.related(XMLNAME = "related", XMLPROJECTION = "ELEMENT");

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
Property payee As HS.FHIR.DTL.vSTU3.Model.Element.Claim.payee(XMLNAME = "payee", XMLPROJECTION = "ELEMENT");

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

/// BackboneElement
/// <p>
/// Members of the care team.
Property careTeam As list Of HS.FHIR.DTL.vSTU3.Model.Element.Claim.careTeam(XMLNAME = "careTeam", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Exceptions, 
/// special considerations, 
/// the condition, 
/// situation, 
/// prior or concurrent issues.
Property information As list Of HS.FHIR.DTL.vSTU3.Model.Element.Claim.information(XMLNAME = "information", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// List of Diagnosis.
Property diagnosis As list Of HS.FHIR.DTL.vSTU3.Model.Element.Claim.diagnosis(XMLNAME = "diagnosis", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Procedures performed.
Property procedure As list Of HS.FHIR.DTL.vSTU3.Model.Element.Claim.procedure(XMLNAME = "procedure", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Insurance or medical plan.
Property insurance As list Of HS.FHIR.DTL.vSTU3.Model.Element.Claim.insurance(XMLNAME = "insurance", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Details about an accident.
Property accident As HS.FHIR.DTL.vSTU3.Model.Element.Claim.accident(XMLNAME = "accident", XMLPROJECTION = "ELEMENT");

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
Property item As list Of HS.FHIR.DTL.vSTU3.Model.Element.Claim.item(XMLNAME = "item", XMLPROJECTION = "ELEMENT");

/// Money
/// <p>
/// Total claim cost.
Property total As HS.FHIR.DTL.vSTU3.Model.Datatype.Money(XMLNAME = "total", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Claim";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Claim";

}
