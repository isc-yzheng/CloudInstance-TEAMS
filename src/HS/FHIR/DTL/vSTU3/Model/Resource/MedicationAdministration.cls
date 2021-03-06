/// Describes the event of a patient consuming or otherwise being administered a medication. 
/// This may be as simple as swallowing a tablet or it may be a long running infusion. 
/// Related resources tie this event to the authorizing prescription, 
/// and the specific encounter between patient and health care Practitioner:
Class HS.FHIR.DTL.vSTU3.Model.Resource.MedicationAdministration Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// External identifier.
Property identifier As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Instantiates protocol or definition.
/// <p>
/// PlanDefinition | ActivityDefinition
Property definition As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "definition", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Part of referenced event.
/// <p>
/// MedicationAdministration | Procedure
Property partOf As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "partOf", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// in-progress | on-hold | completed | entered-in-error | stopped | unknown
/// <p>
/// medication-admin-status is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend medication-admin-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// CodeableConcept
/// <p>
/// Type of medication usage.
/// <p>
/// medication-admin-category is the PREFERRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in medication-admin-category, 
/// you may use codes from any ValueSet.
Property category As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "category", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// What was administered.
/// <p>
/// any FHIR3 code may be used; 
/// medication-codes shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property medicationCodeableConcept As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "medicationCodeableConcept", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// What was administered.
/// <p>
/// Medication.
Property medicationReference As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "medicationReference", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Who received medication.
/// <p>
/// Patient | Group
Property subject As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "subject", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Encounter or Episode of Care administered as part of.
/// <p>
/// Encounter | EpisodeOfCare
Property context As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "context", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Additional information to support administration.
/// <p>
/// Any FHIR3 Resource may be indicated by this Reference
Property supportingInformation As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "supportingInformation", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// Start and end time of administration.
Property effectiveDateTime As %String(MAXLEN = 1000000, XMLNAME = "effectiveDateTime", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Period
/// <p>
/// Start and end time of administration.
Property effectivePeriod As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "effectivePeriod", XMLPROJECTION = "ELEMENT") [ Required ];

/// BackboneElement
/// <p>
/// Who administered substance.
Property performer As list Of HS.FHIR.DTL.vSTU3.Model.Element.MedicationAdministration.performer(XMLNAME = "performer", XMLPROJECTION = "ELEMENT");

/// boolean
/// <p>
/// True if medication not administered.
Property notGiven As %Boolean(XMLNAME = "notGiven", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Reason administration not performed.
/// <p>
/// any FHIR3 code may be used; 
/// reason-medication-not-given-codes shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property reasonNotGiven As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "reasonNotGiven", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Reason administration performed.
/// <p>
/// any FHIR3 code may be used; 
/// reason-medication-given-codes shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property reasonCode As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "reasonCode", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Condition or Observation that supports why the medication was administered.
/// <p>
/// Condition | Observation
Property reasonReference As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "reasonReference", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Request administration performed against.
/// <p>
/// MedicationRequest
Property prescription As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "prescription", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Device used to administer.
/// <p>
/// Device
Property device As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "device", XMLPROJECTION = "ELEMENT");

/// Annotation
/// <p>
/// Information about the administration.
Property note As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Annotation(XMLNAME = "note", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Details of how medication was taken.
Property dosage As HS.FHIR.DTL.vSTU3.Model.Element.MedicationAdministration.dosage(XMLNAME = "dosage", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// A list of events of interest in the lifecycle.
/// <p>
/// Provenance
Property eventHistory As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "eventHistory", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "MedicationAdministration";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "MedicationAdministration";

}
