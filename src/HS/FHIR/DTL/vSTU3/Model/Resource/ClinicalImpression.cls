/// A record of a clinical assessment performed to determine what problem(s) may affect the patient and before planning the treatments or management strategies that are best to manage a patient's condition. 
/// Assessments are often 1:1 with a clinical consultation / encounter, 
/// but this varies greatly depending on the clinical workflow. 
/// This resource is called "ClinicalImpression" rather than "ClinicalAssessment" to avoid confusion with the recording of assessment tools such as Apgar score.
Class HS.FHIR.DTL.vSTU3.Model.Resource.ClinicalImpression Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Business identifier.
Property identifier As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// draft | completed | entered-in-error
/// <p>
/// clinical-impression-status is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend clinical-impression-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// CodeableConcept
/// <p>
/// Kind of assessment performed.
/// <p>
/// any FHIR3 code from any ValueSet may be used.
Property code As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "code", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Why/how the assessment was performed.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Patient or group assessed.
/// <p>
/// Patient | Group
Property subject As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "subject", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Encounter or Episode created from.
/// <p>
/// Encounter | EpisodeOfCare
Property context As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "context", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// Time of assessment. 
/// 
Property effectiveDateTime As %String(MAXLEN = 1000000, XMLNAME = "effectiveDateTime", XMLPROJECTION = "ATTRIBUTE");

/// Period
/// <p>
/// Time of assessment. 
/// 
Property effectivePeriod As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "effectivePeriod", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// When the assessment was documented.
Property date As %String(MAXLEN = 1000000, XMLNAME = "date", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// The clinician performing the assessment.
/// <p>
/// Practitioner
Property assessor As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "assessor", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Reference to last assessment.
/// <p>
/// ClinicalImpression
Property previous As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "previous", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Relevant impressions of patient state.
/// <p>
/// Condition | AllergyIntolerance
Property problem As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "problem", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// One or more sets of investigations (signs, 
/// symptions, 
/// etc.)
Property investigation As list Of HS.FHIR.DTL.vSTU3.Model.Element.ClinicalImpression.investigation(XMLNAME = "investigation", XMLPROJECTION = "ELEMENT");

/// uri
/// <p>
/// Clinical Protocol followed.
Property protocol As list Of %String(MAXLEN = 1000000, XMLNAME = "protocol", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Summary of the assessment.
Property summary As %String(MAXLEN = 1000000, XMLNAME = "summary", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Possible or likely findings and diagnoses.
Property finding As list Of HS.FHIR.DTL.vSTU3.Model.Element.ClinicalImpression.finding(XMLNAME = "finding", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Estimate of likely outcome.
/// <p>
/// any FHIR3 code may be used; 
/// clinicalimpression-prognosis shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property prognosisCodeableConcept As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "prognosisCodeableConcept", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// RiskAssessment expressing likely outcome.
/// <p>
/// RiskAssessment
Property prognosisReference As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "prognosisReference", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Action taken as part of assessment procedure.
/// <p>
/// ReferralRequest | ProcedureRequest | Procedure | MedicationRequest | Appointment
Property action As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "action", XMLPROJECTION = "ELEMENT");

/// Annotation
/// <p>
/// Comments made about the ClinicalImpression.
Property note As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Annotation(XMLNAME = "note", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ClinicalImpression";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ClinicalImpression";

}
