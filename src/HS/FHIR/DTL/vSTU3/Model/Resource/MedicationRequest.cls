/// An order or request for both supply of the medication and the instructions for administration of the medication to a Patient: The resource is called "MedicationRequest" rather than "MedicationPrescription" or "MedicationOrder" to generalize the use across inpatient and outpatient settings, 
/// including care plans, 
/// etc., 
/// and to harmonize with workflow patterns.
Class HS.FHIR.DTL.vSTU3.Model.Resource.MedicationRequest Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// External ids for this request.
Property identifier As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Protocol or definition.
/// <p>
/// ActivityDefinition | PlanDefinition
Property definition As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "definition", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// What request fulfills.
/// <p>
/// CarePlan | MedicationRequest | ProcedureRequest | ReferralRequest
Property basedOn As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "basedOn", XMLPROJECTION = "ELEMENT");

/// Identifier
/// <p>
/// Composite request this is part of.
Property groupIdentifier As HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "groupIdentifier", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// active | on-hold | cancelled | completed | entered-in-error | stopped | draft | unknown
/// <p>
/// medication-request-status is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend medication-request-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// Whether the request is a proposal, 
/// plan, 
/// or an original order.
/// <p>
/// medication-request-intent is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend medication-request-intent and you may NOT use codes from other ValueSets.
Property intent As %String(MAXLEN = 1000000, XMLNAME = "intent", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// CodeableConcept
/// <p>
/// Type of medication usage.
/// <p>
/// medication-request-category is the PREFERRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in medication-request-category, 
/// you may use codes from any ValueSet.
Property category As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "category", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// routine | urgent | stat | asap
/// <p>
/// medication-request-priority is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend medication-request-priority and you may NOT use codes from other ValueSets.
Property priority As %String(MAXLEN = 1000000, XMLNAME = "priority", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Medication to be taken. 
/// 
/// <p>
/// any FHIR3 code may be used; 
/// medication-codes shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property medicationCodeableConcept As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "medicationCodeableConcept", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Medication to be taken. 
/// 
/// <p>
/// Medication.
Property medicationReference As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "medicationReference", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Who or group medication request is for.
/// <p>
/// Patient | Group
Property subject As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "subject", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Created during encounter/admission/stay.
/// <p>
/// Encounter | EpisodeOfCare
Property context As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "context", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Information to support ordering of the medication.
/// <p>
/// Any FHIR3 Resource may be indicated by this Reference
Property supportingInformation As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "supportingInformation", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// When request was initially authored.
Property authoredOn As %String(MAXLEN = 1000000, XMLNAME = "authoredOn", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Who/What requested the Request.
Property requester As HS.FHIR.DTL.vSTU3.Model.Element.MedicationRequest.requester(XMLNAME = "requester", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Person who entered the request.
/// <p>
/// Practitioner
Property recorder As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "recorder", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Reason or indication for writing the prescription.
/// <p>
/// any FHIR3 code may be used; 
/// condition-code shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property reasonCode As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "reasonCode", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Condition or Observation that supports why the prescription is being written.
/// <p>
/// Condition | Observation
Property reasonReference As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "reasonReference", XMLPROJECTION = "ELEMENT");

/// Annotation
/// <p>
/// Information about the prescription.
Property note As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Annotation(XMLNAME = "note", XMLPROJECTION = "ELEMENT");

/// Dosage
/// <p>
/// How the medication should be taken.
Property dosageInstruction As list Of HS.FHIR.DTL.vSTU3.Model.Element.Dosage(XMLNAME = "dosageInstruction", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Medication supply authorization.
Property dispenseRequest As HS.FHIR.DTL.vSTU3.Model.Element.MedicationRequest.dispenseRequest(XMLNAME = "dispenseRequest", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Any restrictions on medication substitution.
Property substitution As HS.FHIR.DTL.vSTU3.Model.Element.MedicationRequest.substitution(XMLNAME = "substitution", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// An order/prescription that is being replaced.
/// <p>
/// MedicationRequest
Property priorPrescription As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "priorPrescription", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Clinical Issue with action.
/// <p>
/// DetectedIssue
Property detectedIssue As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "detectedIssue", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// A list of events of interest in the lifecycle.
/// <p>
/// Provenance
Property eventHistory As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "eventHistory", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "MedicationRequest";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "MedicationRequest";

}
