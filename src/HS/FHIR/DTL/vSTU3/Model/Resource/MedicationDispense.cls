/// Indicates that a medication product is to be or has been dispensed for a named person/Patient: This includes a description of the medication product (supply) provided and the instructions for administering the medication. 
/// The medication dispense is the result of a pharmacy system responding to a medication order.
Class HS.FHIR.DTL.vSTU3.Model.Resource.MedicationDispense Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// External identifier.
Property identifier As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Event that dispense is part of.
/// <p>
/// Procedure
Property partOf As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "partOf", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// preparation | in-progress | on-hold | completed | entered-in-error | stopped
/// <p>
/// medication-dispense-status is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend medication-dispense-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Type of medication dispense.
/// <p>
/// medication-dispense-category is the PREFERRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in medication-dispense-category, 
/// you may use codes from any ValueSet.
Property category As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "category", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// What medication was supplied.
/// <p>
/// any FHIR3 code may be used; 
/// medication-codes shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property medicationCodeableConcept As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "medicationCodeableConcept", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// What medication was supplied.
/// <p>
/// Medication.
Property medicationReference As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "medicationReference", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Who the dispense is for.
/// <p>
/// Patient | Group
Property subject As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "subject", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Encounter / Episode associated with event.
/// <p>
/// Encounter | EpisodeOfCare
Property context As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "context", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Information that supports the dispensing of the medication.
/// <p>
/// Any FHIR3 Resource may be indicated by this Reference
Property supportingInformation As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "supportingInformation", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Who performed event.
Property performer As list Of HS.FHIR.DTL.vSTU3.Model.Element.MedicationDispense.performer(XMLNAME = "performer", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Medication order that authorizes the dispense.
/// <p>
/// MedicationRequest
Property authorizingPrescription As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "authorizingPrescription", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Trial fill, 
/// partial fill, 
/// emergency fill, 
/// etc.
/// <p>
/// any FHIR3 code may be used; 
/// v3-ActPharmacySupplyType shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property type As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

/// SimpleQuantity
/// <p>
/// Amount dispensed.
Property quantity As HS.FHIR.DTL.vSTU3.Model.Datatype.SimpleQuantity(XMLNAME = "quantity", XMLPROJECTION = "ELEMENT");

/// SimpleQuantity
/// <p>
/// Amount of medication expressed as a timing amount.
Property daysSupply As HS.FHIR.DTL.vSTU3.Model.Datatype.SimpleQuantity(XMLNAME = "daysSupply", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// When product was packaged and reviewed.
Property whenPrepared As %String(MAXLEN = 1000000, XMLNAME = "whenPrepared", XMLPROJECTION = "ATTRIBUTE");

/// dateTime
/// <p>
/// When product was given out.
Property whenHandedOver As %String(MAXLEN = 1000000, XMLNAME = "whenHandedOver", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Where the medication was sent.
/// <p>
/// Location
Property destination As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "destination", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Who collected the medication.
/// <p>
/// Patient | Practitioner
Property receiver As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "receiver", XMLPROJECTION = "ELEMENT");

/// Annotation
/// <p>
/// Information about the dispense.
Property note As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Annotation(XMLNAME = "note", XMLPROJECTION = "ELEMENT");

/// Dosage
/// <p>
/// How the medication is to be used by the patient or administered by the caregiver.
Property dosageInstruction As list Of HS.FHIR.DTL.vSTU3.Model.Element.Dosage(XMLNAME = "dosageInstruction", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Whether a substitution was performed on the dispense.
Property substitution As HS.FHIR.DTL.vSTU3.Model.Element.MedicationDispense.substitution(XMLNAME = "substitution", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Clinical issue with action.
/// <p>
/// DetectedIssue
Property detectedIssue As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "detectedIssue", XMLPROJECTION = "ELEMENT");

/// boolean
/// <p>
/// Whether the dispense was or was not performed.
Property notDone As %Boolean(XMLNAME = "notDone", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Why a dispense was not performed. 
/// 
/// <p>
/// any FHIR3 code from any ValueSet may be used.
Property notDoneReasonCodeableConcept As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "notDoneReasonCodeableConcept", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Why a dispense was not performed. 
/// 
/// <p>
/// DetectedIssue.
Property notDoneReasonReference As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "notDoneReasonReference", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// A list of releveant lifecycle events.
/// <p>
/// Provenance
Property eventHistory As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "eventHistory", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "MedicationDispense";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "MedicationDispense";

}
