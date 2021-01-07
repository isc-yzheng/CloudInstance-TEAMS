/// An action that is or was performed on a Patient: This can be a physical intervention like an operation, 
/// or less invasive like counseling or hypnotherapy.
Class HS.FHIR.DTL.vSTU3.Model.Resource.Procedure Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// External Identifiers for this procedure.
Property identifier As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Instantiates protocol or definition.
/// <p>
/// PlanDefinition | ActivityDefinition | HealthcareService
Property definition As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "definition", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// A request for this procedure.
/// <p>
/// CarePlan | ProcedureRequest | ReferralRequest
Property basedOn As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "basedOn", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Part of referenced event.
/// <p>
/// Procedure | Observation | MedicationAdministration
Property partOf As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "partOf", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// preparation | in-progress | suspended | aborted | completed | entered-in-error | unknown
/// <p>
/// event-status is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend event-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// boolean
/// <p>
/// True if procedure was not performed as scheduled.
Property notDone As %Boolean(XMLNAME = "notDone", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Reason procedure was not performed.
/// <p>
/// any FHIR3 code may be used; 
/// procedure-not-performed-reason shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property notDoneReason As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "notDoneReason", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Classification of the procedure.
/// <p>
/// any FHIR3 code may be used; 
/// procedure-category shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property category As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "category", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Identification of the procedure.
/// <p>
/// any FHIR3 code may be used; 
/// procedure-code shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property code As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "code", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Who the procedure was performed on.
/// <p>
/// Patient | Group
Property subject As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "subject", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Encounter or episode associated with the procedure.
/// <p>
/// Encounter | EpisodeOfCare
Property context As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "context", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// Date/Period the procedure was performed. 
/// 
Property performedDateTime As %String(MAXLEN = 1000000, XMLNAME = "performedDateTime", XMLPROJECTION = "ATTRIBUTE");

/// Period
/// <p>
/// Date/Period the procedure was performed. 
/// 
Property performedPeriod As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "performedPeriod", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// The people who performed the procedure.
Property performer As list Of HS.FHIR.DTL.vSTU3.Model.Element.Procedure.performer(XMLNAME = "performer", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Where the procedure happened.
/// <p>
/// Location
Property location As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "location", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Coded reason procedure performed.
/// <p>
/// procedure-reason is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend procedure-reason and you may NOT use codes from other ValueSets.
Property reasonCode As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "reasonCode", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Condition that is the reason the procedure performed.
/// <p>
/// Condition | Observation
Property reasonReference As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "reasonReference", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Target body sites.
/// <p>
/// any FHIR3 code may be used; 
/// body-site shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property bodySite As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "bodySite", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// The result of procedure.
/// <p>
/// any FHIR3 code may be used; 
/// procedure-outcome shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property outcome As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "outcome", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Any report resulting from the procedure.
/// <p>
/// DiagnosticReport
Property report As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "report", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Complication following the procedure.
/// <p>
/// any FHIR3 code may be used; 
/// condition-code shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property complication As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "complication", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// A condition that is a result of the procedure.
/// <p>
/// Condition
Property complicationDetail As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "complicationDetail", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Instructions for follow up.
/// <p>
/// any FHIR3 code may be used; 
/// procedure-followup shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property followUp As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "followUp", XMLPROJECTION = "ELEMENT");

/// Annotation
/// <p>
/// Additional information about the procedure.
Property note As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Annotation(XMLNAME = "note", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Device changed in procedure.
Property focalDevice As list Of HS.FHIR.DTL.vSTU3.Model.Element.Procedure.focalDevice(XMLNAME = "focalDevice", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Items used during procedure.
/// <p>
/// Device | Medication | Substance
Property usedReference As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "usedReference", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Coded items used during the procedure.
/// <p>
/// any FHIR3 code may be used; 
/// device-kind shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property usedCode As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "usedCode", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Procedure";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Procedure";

}
