/// An assessment of the likely outcome(s) for a patient or other subject as well as the likelihood of each outcome.
Class HS.FHIR.DTL.vSTU3.Model.Resource.RiskAssessment Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Unique identifier for the assessment.
Property identifier As HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Request fulfilled by this assessment.
/// <p>
/// Any FHIR3 Resource may be indicated by this Reference
Property basedOn As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "basedOn", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Part of this occurrence.
/// <p>
/// Any FHIR3 Resource may be indicated by this Reference
Property parent As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "parent", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// registered | preliminary | final | amended +
/// <p>
/// observation-status is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend observation-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// CodeableConcept
/// <p>
/// Evaluation mechanism.
/// <p>
/// any FHIR3 code from any ValueSet may be used.
Property method As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "method", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Type of assessment.
/// <p>
/// any FHIR3 code from any ValueSet may be used.
Property code As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "code", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Who/what does assessment apply to?
/// <p>
/// Patient | Group
Property subject As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "subject", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Where was assessment performed?
/// <p>
/// Encounter | EpisodeOfCare
Property context As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "context", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// When was assessment made?
Property occurrenceDateTime As %String(MAXLEN = 1000000, XMLNAME = "occurrenceDateTime", XMLPROJECTION = "ATTRIBUTE");

/// Period
/// <p>
/// When was assessment made?
Property occurrencePeriod As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "occurrencePeriod", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Condition assessed.
/// <p>
/// Condition
Property condition As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "condition", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Who did assessment?
/// <p>
/// Practitioner | Device
Property performer As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "performer", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Why the assessment was necessary?
/// <p>
/// any FHIR3 code from any ValueSet may be used.
Property reasonCodeableConcept As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "reasonCodeableConcept", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Why the assessment was necessary?
/// <p>
/// Any FHIR3 Resource may be indicated by this Reference.
Property reasonReference As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "reasonReference", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Information used in assessment.
/// <p>
/// Any FHIR3 Resource may be indicated by this Reference
Property basis As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "basis", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Outcome predicted.
Property prediction As list Of HS.FHIR.DTL.vSTU3.Model.Element.RiskAssessment.prediction(XMLNAME = "prediction", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// How to reduce risk.
Property mitigation As %String(MAXLEN = 1000000, XMLNAME = "mitigation", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Comments on the risk assessment.
Property comment As %String(MAXLEN = 1000000, XMLNAME = "comment", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "RiskAssessment";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "RiskAssessment";

}
