/// A clinical assessment performed when planning treatments and management strategies for a patient.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.ClinicalImpression Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Reference
/// <p>
/// The patient being assessed.
/// <p>
/// Patient
Property patient As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "patient", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// The clinician performing the assessment.
/// <p>
/// Practitioner
Property assessor As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "assessor", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// in-progress | completed | entered-in-error
/// <p>
/// clinical-impression-status is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend clinical-impression-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// dateTime
/// <p>
/// When the assessment occurred.
Property date As %String(MAXLEN = 1000000, XMLNAME = "date", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Why/how the assessment was performed.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Reference to last assessment.
/// <p>
/// ClinicalImpression
Property previous As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "previous", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// General assessment of patient state.
/// <p>
/// Condition | AllergyIntolerance
Property problem As list Of HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "problem", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Request or event that necessitated this assessment.
/// <p>
/// any FHIR2 code may be used; 
/// clinical-findings shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property triggerCodeableConcept As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "triggerCodeableConcept", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Request or event that necessitated this assessment.
/// <p>
/// Any FHIR2 Resource may be indicated by this Reference.
Property triggerReference As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "triggerReference", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// One or more sets of investigations (signs, 
/// symptions, 
/// etc.)
Property investigations As list Of HS.FHIR.DTL.vDSTU2.Model.Element.ClinicalImpression.investigations(XMLNAME = "investigations", XMLPROJECTION = "ELEMENT");

/// uri
/// <p>
/// Clinical Protocol followed.
Property protocol As %String(MAXLEN = 1000000, XMLNAME = "protocol", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Summary of the assessment.
Property summary As %String(MAXLEN = 1000000, XMLNAME = "summary", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Possible or likely findings and diagnoses.
Property finding As list Of HS.FHIR.DTL.vDSTU2.Model.Element.ClinicalImpression.finding(XMLNAME = "finding", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Diagnoses/conditions resolved since previous assessment.
/// <p>
/// any FHIR2 code may be used; 
/// condition-code shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property resolved As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "resolved", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Diagnosis considered not possible.
Property ruledOut As list Of HS.FHIR.DTL.vDSTU2.Model.Element.ClinicalImpression.ruledOut(XMLNAME = "ruledOut", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Estimate of likely outcome.
Property prognosis As %String(MAXLEN = 1000000, XMLNAME = "prognosis", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Plan of action after assessment.
/// <p>
/// CarePlan | Appointment | CommunicationRequest | DeviceUseRequest | DiagnosticOrder | MedicationOrder | NutritionOrder | Order | ProcedureRequest | ProcessRequest | ReferralRequest | SupplyRequest | VisionPrescription
Property plan As list Of HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "plan", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Actions taken during assessment.
/// <p>
/// ReferralRequest | ProcedureRequest | Procedure | MedicationOrder | DiagnosticOrder | NutritionOrder | SupplyRequest | Appointment
Property action As list Of HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "action", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ClinicalImpression";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ClinicalImpression";

}
