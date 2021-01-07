/// Claim, 
/// Pre-determination or Pre-authorization.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.Claim Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// code
/// <p>
/// institutional | oral | pharmacy | professional | vision
/// <p>
/// claim-type-link is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend claim-type-link and you may NOT use codes from other ValueSets.
Property type As %String(MAXLEN = 1000000, XMLNAME = "type", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Identifier
/// <p>
/// Claim number.
Property identifier As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// Current specification followed.
/// <p>
/// any FHIR2 code may be used; 
/// ruleset shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property ruleset As HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "ruleset", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// Original specification followed.
/// <p>
/// any FHIR2 code may be used; 
/// ruleset shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property originalRuleset As HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "originalRuleset", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// Creation date.
Property created As %String(MAXLEN = 1000000, XMLNAME = "created", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Insurer.
/// <p>
/// Organization
Property target As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "target", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Responsible provider.
/// <p>
/// Practitioner
Property provider As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "provider", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Responsible organization.
/// <p>
/// Organization
Property organization As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "organization", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// complete | proposed | exploratory | other
/// <p>
/// claim-use-link is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend claim-use-link and you may NOT use codes from other ValueSets.
Property use As %String(MAXLEN = 1000000, XMLNAME = "use", XMLPROJECTION = "ATTRIBUTE");

/// Coding
/// <p>
/// Desired processing priority.
/// <p>
/// any FHIR2 code may be used; 
/// process-priority shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property priority As HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "priority", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// Funds requested to be reserved.
/// <p>
/// any FHIR2 code may be used; 
/// fundsreserve shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property fundsReserve As HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "fundsReserve", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Author.
/// <p>
/// Practitioner
Property enterer As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "enterer", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Servicing Facility.
/// <p>
/// Location
Property facility As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "facility", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Prescription.
/// <p>
/// MedicationOrder | VisionPrescription
Property prescription As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "prescription", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Original Prescription.
/// <p>
/// MedicationOrder
Property originalPrescription As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "originalPrescription", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Payee.
Property payee As HS.FHIR.DTL.vDSTU2.Model.Element.Claim.payee(XMLNAME = "payee", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Treatment Referral.
/// <p>
/// ReferralRequest
Property referral As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "referral", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Diagnosis.
Property diagnosis As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Claim.diagnosis(XMLNAME = "diagnosis", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// List of presenting Conditions.
/// <p>
/// any FHIR2 code may be used; 
/// fm-conditions shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property condition As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "condition", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// The subject of the Products and Services.
/// <p>
/// Patient
Property patient As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "patient", XMLPROJECTION = "ELEMENT") [ Required ];

/// BackboneElement
/// <p>
/// Insurance or medical plan.
Property coverage As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Claim.coverage(XMLNAME = "coverage", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// Eligibility exceptions.
/// <p>
/// any FHIR2 code may be used; 
/// claim-exception shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property exception As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "exception", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Name of School.
Property school As %String(MAXLEN = 1000000, XMLNAME = "school", XMLPROJECTION = "ATTRIBUTE");

/// date
/// <p>
/// Accident Date.
Property accident As %String(MAXLEN = 1000000, XMLNAME = "accident", XMLPROJECTION = "ATTRIBUTE");

/// Coding
/// <p>
/// Accident Type.
/// <p>
/// v3-ActIncidentCode is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend v3-ActIncidentCode and you may NOT use codes from other ValueSets.
Property accidentType As HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "accidentType", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// Intervention and exception code (Pharma)
/// <p>
/// any FHIR2 code may be used; 
/// intervention shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property interventionException As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "interventionException", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Goods and Services.
Property item As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Claim.item(XMLNAME = "item", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// Additional materials, 
/// documents, 
/// etc.
/// <p>
/// any FHIR2 code may be used; 
/// additionalmaterials shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property additionalMaterials As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "additionalMaterials", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Only if type = oral.
Property missingTeeth As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Claim.missingTeeth(XMLNAME = "missingTeeth", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Claim";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Claim";

}
