/// A Diagnostic report - a combination of request information, 
/// atomic results, 
/// images, 
/// interpretation, 
/// as well as formatted reports.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.DiagnosticReport Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Id for external references to this report.
Property identifier As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// registered | partial | final | corrected | appended | cancelled | entered-in-error
/// <p>
/// diagnostic-report-status is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend diagnostic-report-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// CodeableConcept
/// <p>
/// Service category.
/// <p>
/// any FHIR2 code may be used; 
/// diagnostic-service-sections shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property category As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "category", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Name/Code for this diagnostic report.
/// <p>
/// report-codes is the PREFERRED FHIR2 ValueSet for codes, 
/// but if you need to express meanings not found in report-codes, 
/// you may use codes from any ValueSet.
Property code As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "code", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// The subject of the report, 
/// usually, 
/// but not always, 
/// the patient.
/// <p>
/// Patient | Group | Device | Location
Property subject As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "subject", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Health care event when test ordered.
/// <p>
/// Encounter
Property encounter As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "encounter", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// Clinically Relevant time/time-period for report.
Property effectiveDateTime As %String(MAXLEN = 1000000, XMLNAME = "effectiveDateTime", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Period
/// <p>
/// Clinically Relevant time/time-period for report.
Property effectivePeriod As HS.FHIR.DTL.vDSTU2.Model.Datatype.Period(XMLNAME = "effectivePeriod", XMLPROJECTION = "ELEMENT") [ Required ];

/// instant
/// <p>
/// DateTime this version was released.
Property issued As %String(MAXLEN = 1000000, XMLNAME = "issued", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Reference
/// <p>
/// Responsible Diagnostic Service.
/// <p>
/// Practitioner | Organization
Property performer As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "performer", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// What was requested.
/// <p>
/// DiagnosticOrder | ProcedureRequest | ReferralRequest
Property request As list Of HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "request", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Specimens this report is based on.
/// <p>
/// Specimen
Property specimen As list Of HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "specimen", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Observations - simple, 
/// or complex nested groups.
/// <p>
/// Observation
Property result As list Of HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "result", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Reference to full details of imaging associated with the diagnostic report.
/// <p>
/// ImagingStudy | ImagingObjectSelection
Property imagingStudy As list Of HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "imagingStudy", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Key images associated with this report.
Property image As list Of HS.FHIR.DTL.vDSTU2.Model.Element.DiagnosticReport.image(XMLNAME = "image", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Clinical Interpretation of test results.
Property conclusion As %String(MAXLEN = 1000000, XMLNAME = "conclusion", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Codes for the conclusion.
/// <p>
/// any FHIR2 code may be used; 
/// clinical-findings shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property codedDiagnosis As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "codedDiagnosis", XMLPROJECTION = "ELEMENT");

/// Attachment
/// <p>
/// Entire report as issued.
Property presentedForm As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Attachment(XMLNAME = "presentedForm", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "DiagnosticReport";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "DiagnosticReport";

}
