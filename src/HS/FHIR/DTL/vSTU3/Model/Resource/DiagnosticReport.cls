/// The findings and interpretation of diagnostic tests performed on patients, 
/// groups of patients, 
/// devices, 
/// and locations, 
/// and/or specimens derived from these. 
/// The report includes clinical context such as requesting and provider information, 
/// and some mix of atomic results, 
/// images, 
/// textual and coded interpretations, 
/// and formatted representation of diagnostic reports.
Class HS.FHIR.DTL.vSTU3.Model.Resource.DiagnosticReport Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Business identifier for report.
Property identifier As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// What was requested.
/// <p>
/// CarePlan | ImmunizationRecommendation | MedicationRequest | NutritionOrder | ProcedureRequest | ReferralRequest
Property basedOn As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "basedOn", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// registered | partial | preliminary | final +
/// <p>
/// diagnostic-report-status is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend diagnostic-report-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// CodeableConcept
/// <p>
/// Service category.
/// <p>
/// any FHIR3 code may be used; 
/// diagnostic-service-sections shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property category As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "category", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Name/Code for this diagnostic report.
/// <p>
/// report-codes is the PREFERRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in report-codes, 
/// you may use codes from any ValueSet.
Property code As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "code", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// The subject of the report - usually, 
/// but not always, 
/// the patient.
/// <p>
/// Patient | Group | Device | Location
Property subject As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "subject", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Health care event when test ordered.
/// <p>
/// Encounter | EpisodeOfCare
Property context As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "context", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// Clinically relevant time/time-period for report. 
/// 
Property effectiveDateTime As %String(MAXLEN = 1000000, XMLNAME = "effectiveDateTime", XMLPROJECTION = "ATTRIBUTE");

/// Period
/// <p>
/// Clinically relevant time/time-period for report. 
/// 
Property effectivePeriod As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "effectivePeriod", XMLPROJECTION = "ELEMENT");

/// instant
/// <p>
/// DateTime this version was released.
Property issued As %String(MAXLEN = 1000000, XMLNAME = "issued", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Participants in producing the report.
Property performer As list Of HS.FHIR.DTL.vSTU3.Model.Element.DiagnosticReport.performer(XMLNAME = "performer", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Specimens this report is based on.
/// <p>
/// Specimen
Property specimen As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "specimen", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Observations - simple, 
/// or complex nested groups.
/// <p>
/// Observation
Property result As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "result", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Reference to full details of imaging associated with the diagnostic report.
/// <p>
/// ImagingStudy | ImagingManifest
Property imagingStudy As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "imagingStudy", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Key images associated with this report.
Property image As list Of HS.FHIR.DTL.vSTU3.Model.Element.DiagnosticReport.image(XMLNAME = "image", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Clinical Interpretation of test results.
Property conclusion As %String(MAXLEN = 1000000, XMLNAME = "conclusion", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Codes for the conclusion.
/// <p>
/// any FHIR3 code may be used; 
/// clinical-findings shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property codedDiagnosis As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "codedDiagnosis", XMLPROJECTION = "ELEMENT");

/// Attachment
/// <p>
/// Entire report as issued.
Property presentedForm As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Attachment(XMLNAME = "presentedForm", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "DiagnosticReport";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "DiagnosticReport";

}
