/// A clinical condition, 
/// problem, 
/// diagnosis, 
/// or other event, 
/// situation, 
/// issue, 
/// or clinical concept that has risen to a level of concern.
Class HS.FHIR.DTL.vSTU3.Model.Resource.Condition Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// External Ids for this condition.
Property identifier As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// active | recurrence | inactive | remission | resolved
/// <p>
/// condition-clinical is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend condition-clinical and you may NOT use codes from other ValueSets.
Property clinicalStatus As %String(MAXLEN = 1000000, XMLNAME = "clinicalStatus", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// provisional | differential | confirmed | refuted | entered-in-error | unknown
/// <p>
/// condition-ver-status is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend condition-ver-status and you may NOT use codes from other ValueSets.
Property verificationStatus As %String(MAXLEN = 1000000, XMLNAME = "verificationStatus", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// problem-list-item | encounter-diagnosis
/// <p>
/// any FHIR3 code may be used; 
/// condition-category shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property category As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "category", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Subjective severity of condition.
/// <p>
/// condition-severity is the PREFERRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in condition-severity, 
/// you may use codes from any ValueSet.
Property severity As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "severity", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Identification of the condition, 
/// problem or diagnosis.
/// <p>
/// any FHIR3 code may be used; 
/// condition-code shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property code As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "code", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Anatomical location, 
/// if relevant.
/// <p>
/// any FHIR3 code may be used; 
/// body-site shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property bodySite As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "bodySite", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Who has the condition?
/// <p>
/// Patient | Group
Property subject As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "subject", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Encounter or episode when condition first asserted.
/// <p>
/// Encounter | EpisodeOfCare
Property context As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "context", XMLPROJECTION = "ELEMENT");

/// Age
/// <p>
/// Estimated or actual date, 
/// date-time, 
/// or age.
Property onsetAge As HS.FHIR.DTL.vSTU3.Model.Datatype.Age(XMLNAME = "onsetAge", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// Estimated or actual date, 
/// date-time, 
/// or age.
Property onsetDateTime As %String(MAXLEN = 1000000, XMLNAME = "onsetDateTime", XMLPROJECTION = "ATTRIBUTE");

/// Period
/// <p>
/// Estimated or actual date, 
/// date-time, 
/// or age.
Property onsetPeriod As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "onsetPeriod", XMLPROJECTION = "ELEMENT");

/// Range
/// <p>
/// Estimated or actual date, 
/// date-time, 
/// or age.
Property onsetRange As HS.FHIR.DTL.vSTU3.Model.Datatype.Range(XMLNAME = "onsetRange", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Estimated or actual date, 
/// date-time, 
/// or age.
Property onsetString As %String(MAXLEN = 1000000, XMLNAME = "onsetString", XMLPROJECTION = "ATTRIBUTE");

/// Age
/// <p>
/// If/when in resolution/remission.
Property abatementAge As HS.FHIR.DTL.vSTU3.Model.Datatype.Age(XMLNAME = "abatementAge", XMLPROJECTION = "ELEMENT");

/// boolean
/// <p>
/// If/when in resolution/remission.
Property abatementBoolean As %Boolean(XMLNAME = "abatementBoolean", XMLPROJECTION = "ATTRIBUTE");

/// dateTime
/// <p>
/// If/when in resolution/remission.
Property abatementDateTime As %String(MAXLEN = 1000000, XMLNAME = "abatementDateTime", XMLPROJECTION = "ATTRIBUTE");

/// Period
/// <p>
/// If/when in resolution/remission.
Property abatementPeriod As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "abatementPeriod", XMLPROJECTION = "ELEMENT");

/// Range
/// <p>
/// If/when in resolution/remission.
Property abatementRange As HS.FHIR.DTL.vSTU3.Model.Datatype.Range(XMLNAME = "abatementRange", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// If/when in resolution/remission.
Property abatementString As %String(MAXLEN = 1000000, XMLNAME = "abatementString", XMLPROJECTION = "ATTRIBUTE");

/// dateTime
/// <p>
/// Date record was believed accurate.
Property assertedDate As %String(MAXLEN = 1000000, XMLNAME = "assertedDate", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Person who asserts this condition.
/// <p>
/// Practitioner | Patient | RelatedPerson
Property asserter As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "asserter", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Stage/grade, 
/// usually assessed formally.
Property stage As HS.FHIR.DTL.vSTU3.Model.Element.Condition.stage(XMLNAME = "stage", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Supporting evidence.
Property evidence As list Of HS.FHIR.DTL.vSTU3.Model.Element.Condition.evidence(XMLNAME = "evidence", XMLPROJECTION = "ELEMENT");

/// Annotation
/// <p>
/// Additional information about the condition.
Property note As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Annotation(XMLNAME = "note", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Condition";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Condition";

}
