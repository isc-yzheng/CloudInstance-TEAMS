/// Medical care, 
/// research study or other healthcare event causing physical injury.
Class HS.FHIR.DTL.vR4.Model.Resource.AdverseEvent Extends HS.FHIR.DTL.vR4.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Business identifier for the event.
Property identifier As HS.FHIR.DTL.vR4.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// actual | potential
/// <p>
/// adverse-event-actuality|4.0.1 is the REQUIRED FHIR4 ValueSet for codes; 
/// you may NOT extend adverse-event-actuality|4.0.1 and you may NOT use codes from other ValueSets.
Property actuality As %String(MAXLEN = 1000000, XMLNAME = "actuality", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// CodeableConcept
/// <p>
/// product-problem | product-quality | product-use-error | wrong-dose | incorrect-prescribing-information | wrong-technique | wrong-route-of-administration | wrong-rate | wrong-duration | wrong-time | expired-drug | medical-device-use-error | problem-different-manufacturer | unsafe-physical-environment
/// <p>
/// adverse-event-category is the REQUIRED FHIR4 ValueSet for codes, 
/// but if you need to express meanings not found in adverse-event-category, 
/// you may formally EXTEND adverse-event-category to add codes to it.
Property category As list Of HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "category", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Type of the event itself in relation to the subject.
/// <p>
/// any FHIR4 code may be used; 
/// adverse-event-type shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property event As HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "event", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Subject impacted by event.
/// <p>
/// Patient | Group | Practitioner | RelatedPerson
Property subject As HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "subject", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Encounter created as part of.
/// <p>
/// Encounter
Property encounter As HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "encounter", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// When the event occurred.
Property date As %String(MAXLEN = 1000000, XMLNAME = "date", XMLPROJECTION = "ATTRIBUTE");

/// dateTime
/// <p>
/// When the event was detected.
Property detected As %String(MAXLEN = 1000000, XMLNAME = "detected", XMLPROJECTION = "ATTRIBUTE");

/// dateTime
/// <p>
/// When the event was recorded.
Property recordedDate As %String(MAXLEN = 1000000, XMLNAME = "recordedDate", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Effect on the subject due to this event.
/// <p>
/// Condition
Property resultingCondition As list Of HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "resultingCondition", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Location where adverse event occurred.
/// <p>
/// Location
Property location As HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "location", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Seriousness of the event.
/// <p>
/// any FHIR4 code may be used; 
/// adverse-event-seriousness shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property seriousness As HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "seriousness", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// mild | moderate | severe
/// <p>
/// adverse-event-severity|4.0.1 is the REQUIRED FHIR4 ValueSet for codes; 
/// you may NOT extend adverse-event-severity|4.0.1 and you may NOT use codes from other ValueSets.
Property severity As HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "severity", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// resolved | recovering | ongoing | resolvedWithSequelae | fatal | unknown
/// <p>
/// adverse-event-outcome|4.0.1 is the REQUIRED FHIR4 ValueSet for codes; 
/// you may NOT extend adverse-event-outcome|4.0.1 and you may NOT use codes from other ValueSets.
Property outcome As HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "outcome", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Who recorded the adverse event.
/// <p>
/// Patient | Practitioner | PractitionerRole | RelatedPerson
Property recorder As HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "recorder", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Who  was involved in the adverse event or the potential adverse event.
/// <p>
/// Practitioner | PractitionerRole | Device
Property contributor As list Of HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "contributor", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// The suspected agent causing the adverse event.
Property suspectEntity As list Of HS.FHIR.DTL.vR4.Model.Element.AdverseEvent.suspectEntity(XMLNAME = "suspectEntity", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// AdverseEvent.subjectMedicalHistory.
/// <p>
/// Condition | Observation | AllergyIntolerance | FamilyMemberHistory | Immunization | Procedure | Media | DocumentReference
Property subjectMedicalHistory As list Of HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "subjectMedicalHistory", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// AdverseEvent.referenceDocument.
/// <p>
/// DocumentReference
Property referenceDocument As list Of HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "referenceDocument", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// AdverseEvent.study.
/// <p>
/// ResearchStudy
Property study As list Of HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "study", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "AdverseEvent";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "AdverseEvent";

}
