/// Information about patient's relatives, 
/// relevant for patient.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.FamilyMemberHistory Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// External Id(s) for this record.
Property identifier As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Patient history is about.
/// <p>
/// Patient
Property patient As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "patient", XMLPROJECTION = "ELEMENT") [ Required ];

/// dateTime
/// <p>
/// When history was captured/updated.
Property date As %String(MAXLEN = 1000000, XMLNAME = "date", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// partial | completed | entered-in-error | health-unknown
/// <p>
/// history-status is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend history-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// string
/// <p>
/// The family member described.
Property name As %String(MAXLEN = 1000000, XMLNAME = "name", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Relationship to the subject.
/// <p>
/// any FHIR2 code may be used; 
/// v3-FamilyMember shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property relationship As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "relationship", XMLPROJECTION = "ELEMENT") [ Required ];

/// code
/// <p>
/// male | female | other | unknown
/// <p>
/// administrative-gender is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend administrative-gender and you may NOT use codes from other ValueSets.
Property gender As %String(MAXLEN = 1000000, XMLNAME = "gender", XMLPROJECTION = "ATTRIBUTE");

/// date
/// <p>
/// (approximate) date of birth.
Property bornDate As %String(MAXLEN = 1000000, XMLNAME = "bornDate", XMLPROJECTION = "ATTRIBUTE");

/// Period
/// <p>
/// (approximate) date of birth.
Property bornPeriod As HS.FHIR.DTL.vDSTU2.Model.Datatype.Period(XMLNAME = "bornPeriod", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// (approximate) date of birth.
Property bornString As %String(MAXLEN = 1000000, XMLNAME = "bornString", XMLPROJECTION = "ATTRIBUTE");

/// Age
/// <p>
/// (approximate) age.
Property ageQuantity As HS.FHIR.DTL.vDSTU2.Model.Datatype.Age(XMLNAME = "ageQuantity", XMLPROJECTION = "ELEMENT");

/// Range
/// <p>
/// (approximate) age.
Property ageRange As HS.FHIR.DTL.vDSTU2.Model.Datatype.Range(XMLNAME = "ageRange", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// (approximate) age.
Property ageString As %String(MAXLEN = 1000000, XMLNAME = "ageString", XMLPROJECTION = "ATTRIBUTE");

/// boolean
/// <p>
/// Dead? How old/when?
Property deceasedBoolean As %Boolean(XMLNAME = "deceasedBoolean", XMLPROJECTION = "ATTRIBUTE");

/// date
/// <p>
/// Dead? How old/when?
Property deceasedDate As %String(MAXLEN = 1000000, XMLNAME = "deceasedDate", XMLPROJECTION = "ATTRIBUTE");

/// Age
/// <p>
/// Dead? How old/when?
Property deceasedQuantity As HS.FHIR.DTL.vDSTU2.Model.Datatype.Age(XMLNAME = "deceasedQuantity", XMLPROJECTION = "ELEMENT");

/// Range
/// <p>
/// Dead? How old/when?
Property deceasedRange As HS.FHIR.DTL.vDSTU2.Model.Datatype.Range(XMLNAME = "deceasedRange", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Dead? How old/when?
Property deceasedString As %String(MAXLEN = 1000000, XMLNAME = "deceasedString", XMLPROJECTION = "ATTRIBUTE");

/// Annotation
/// <p>
/// General note about related person.
Property note As HS.FHIR.DTL.vDSTU2.Model.Datatype.Annotation(XMLNAME = "note", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Condition that the related person had.
Property condition As list Of HS.FHIR.DTL.vDSTU2.Model.Element.FamilyMemberHistory.condition(XMLNAME = "condition", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "FamilyMemberHistory";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "FamilyMemberHistory";

}
