/// A clinical assessment performed when planning treatments and management strategies for a patient.
Class HS.FHIR.DTL.vR4.Model.Resource.ClinicalImpression Extends HS.FHIR.DTL.vR4.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Business identifier.
Property identifier As list Of HS.FHIR.DTL.vR4.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// in-progress | completed | entered-in-error
/// <p>
/// clinicalimpression-status|4.0.1 is the REQUIRED FHIR4 ValueSet for codes; 
/// you may NOT extend clinicalimpression-status|4.0.1 and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// CodeableConcept
/// <p>
/// Reason for current status.
/// <p>
/// any FHIR4 code from any ValueSet may be used.
Property statusReason As HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "statusReason", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Kind of assessment performed.
/// <p>
/// any FHIR4 code from any ValueSet may be used.
Property code As HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "code", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Why/how the assessment was performed.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Patient or group assessed.
/// <p>
/// Patient | Group
Property subject As HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "subject", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Encounter created as part of.
/// <p>
/// Encounter
Property encounter As HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "encounter", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// Time of assessment.
Property effectiveDateTime As %String(MAXLEN = 1000000, XMLNAME = "effectiveDateTime", XMLPROJECTION = "ATTRIBUTE");

/// Period
/// <p>
/// Time of assessment.
Property effectivePeriod As HS.FHIR.DTL.vR4.Model.Datatype.Period(XMLNAME = "effectivePeriod", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// When the assessment was documented.
Property date As %String(MAXLEN = 1000000, XMLNAME = "date", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// The clinician performing the assessment.
/// <p>
/// Practitioner | PractitionerRole
Property assessor As HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "assessor", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Reference to last assessment.
/// <p>
/// ClinicalImpression
Property previous As HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "previous", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Relevant impressions of patient state.
/// <p>
/// Condition | AllergyIntolerance
Property problem As list Of HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "problem", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// One or more sets of investigations (signs, 
/// symptoms, 
/// etc.)
Property investigation As list Of HS.FHIR.DTL.vR4.Model.Element.ClinicalImpression.investigation(XMLNAME = "investigation", XMLPROJECTION = "ELEMENT");

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
Property finding As list Of HS.FHIR.DTL.vR4.Model.Element.ClinicalImpression.finding(XMLNAME = "finding", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Estimate of likely outcome.
/// <p>
/// any FHIR4 code may be used; 
/// clinicalimpression-prognosis shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property prognosisCodeableConcept As list Of HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "prognosisCodeableConcept", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// RiskAssessment expressing likely outcome.
/// <p>
/// RiskAssessment
Property prognosisReference As list Of HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "prognosisReference", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Information supporting the clinical impression.
/// <p>
/// Any FHIR4 Resource may be indicated by this Reference
Property supportingInfo As list Of HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "supportingInfo", XMLPROJECTION = "ELEMENT");

/// Annotation
/// <p>
/// Comments made about the ClinicalImpression.
Property note As list Of HS.FHIR.DTL.vR4.Model.Datatype.Annotation(XMLNAME = "note", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ClinicalImpression";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ClinicalImpression";

}
