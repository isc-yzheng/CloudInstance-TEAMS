/// Detailed information about conditions, 
/// problems or diagnoses.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.Condition Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// External Ids for this condition.
Property identifier As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Who has the condition?
/// <p>
/// Patient
Property patient As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "patient", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Encounter when condition first asserted.
/// <p>
/// Encounter
Property encounter As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "encounter", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Person who asserts this condition.
/// <p>
/// Practitioner | Patient
Property asserter As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "asserter", XMLPROJECTION = "ELEMENT");

/// date
/// <p>
/// When first entered.
Property dateRecorded As %String(MAXLEN = 1000000, XMLNAME = "dateRecorded", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Identification of the condition, 
/// problem or diagnosis.
/// <p>
/// any FHIR2 code may be used; 
/// condition-code shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property code As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "code", XMLPROJECTION = "ELEMENT") [ Required ];

/// CodeableConcept
/// <p>
/// complaint | symptom | finding | diagnosis
/// <p>
/// condition-category is the PREFERRED FHIR2 ValueSet for codes, 
/// but if you need to express meanings not found in condition-category, 
/// you may use codes from any ValueSet.
Property category As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "category", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// active | relapse | remission | resolved
/// <p>
/// condition-clinical is the PREFERRED FHIR2 ValueSet for codes, 
/// but if you need to express meanings not found in condition-clinical, 
/// you may use codes from any ValueSet.
Property clinicalStatus As %String(MAXLEN = 1000000, XMLNAME = "clinicalStatus", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// provisional | differential | confirmed | refuted | entered-in-error | unknown
/// <p>
/// condition-ver-status is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend condition-ver-status and you may NOT use codes from other ValueSets.
Property verificationStatus As %String(MAXLEN = 1000000, XMLNAME = "verificationStatus", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// CodeableConcept
/// <p>
/// Subjective severity of condition.
/// <p>
/// condition-severity is the PREFERRED FHIR2 ValueSet for codes, 
/// but if you need to express meanings not found in condition-severity, 
/// you may use codes from any ValueSet.
Property severity As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "severity", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// Estimated or actual date, 
///  date-time, 
/// or age.
Property onsetDateTime As %String(MAXLEN = 1000000, XMLNAME = "onsetDateTime", XMLPROJECTION = "ATTRIBUTE");

/// Period
/// <p>
/// Estimated or actual date, 
///  date-time, 
/// or age.
Property onsetPeriod As HS.FHIR.DTL.vDSTU2.Model.Datatype.Period(XMLNAME = "onsetPeriod", XMLPROJECTION = "ELEMENT");

/// Age
/// <p>
/// Estimated or actual date, 
///  date-time, 
/// or age.
Property onsetQuantity As HS.FHIR.DTL.vDSTU2.Model.Datatype.Age(XMLNAME = "onsetQuantity", XMLPROJECTION = "ELEMENT");

/// Range
/// <p>
/// Estimated or actual date, 
///  date-time, 
/// or age.
Property onsetRange As HS.FHIR.DTL.vDSTU2.Model.Datatype.Range(XMLNAME = "onsetRange", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Estimated or actual date, 
///  date-time, 
/// or age.
Property onsetString As %String(MAXLEN = 1000000, XMLNAME = "onsetString", XMLPROJECTION = "ATTRIBUTE");

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
Property abatementPeriod As HS.FHIR.DTL.vDSTU2.Model.Datatype.Period(XMLNAME = "abatementPeriod", XMLPROJECTION = "ELEMENT");

/// Age
/// <p>
/// If/when in resolution/remission.
Property abatementQuantity As HS.FHIR.DTL.vDSTU2.Model.Datatype.Age(XMLNAME = "abatementQuantity", XMLPROJECTION = "ELEMENT");

/// Range
/// <p>
/// If/when in resolution/remission.
Property abatementRange As HS.FHIR.DTL.vDSTU2.Model.Datatype.Range(XMLNAME = "abatementRange", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// If/when in resolution/remission.
Property abatementString As %String(MAXLEN = 1000000, XMLNAME = "abatementString", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Stage/grade, 
/// usually assessed formally.
Property stage As HS.FHIR.DTL.vDSTU2.Model.Element.Condition.stage(XMLNAME = "stage", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Supporting evidence.
Property evidence As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Condition.evidence(XMLNAME = "evidence", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Anatomical location, 
/// if relevant.
/// <p>
/// any FHIR2 code may be used; 
/// body-site shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property bodySite As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "bodySite", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Additional information about the Condition.
Property notes As %String(MAXLEN = 1000000, XMLNAME = "notes", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Condition";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Condition";

}
