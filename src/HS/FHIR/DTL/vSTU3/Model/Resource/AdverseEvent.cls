/// Actual or potential/avoided event causing unintended physical injury resulting from or contributed to by medical care, 
/// a research study or other healthcare setting factors that requires additional monitoring, 
/// treatment, 
/// or hospitalization, 
/// or that results in death.
Class HS.FHIR.DTL.vSTU3.Model.Resource.AdverseEvent Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Business identifier for the event.
Property identifier As HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// An adverse event is an event that caused harm to a patient, 
/// an adverse reaction is a something that is a subject-specific event that is a result of an exposure to a medication, 
/// food, 
/// device or environmental substance, 
/// a potential adverse event is something that occurred and that could have caused harm to a patient but did not.
/// <p>
/// adverse-event-category is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend adverse-event-category and you may NOT use codes from other ValueSets.
Property category As %String(MAXLEN = 1000000, XMLNAME = "category", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// actual | potential
/// <p>
/// any FHIR3 code may be used; 
/// adverse-event-type shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property type As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Subject or group impacted by event.
/// <p>
/// Patient | ResearchSubject | Medication | Device
Property subject As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "subject", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// When the event occurred.
Property date As %String(MAXLEN = 1000000, XMLNAME = "date", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Adverse Reaction Events linked to exposure to substance.
/// <p>
/// Condition
Property reaction As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "reaction", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Location where adverse event occurred.
/// <p>
/// Location
Property location As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "location", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Mild | Moderate | Severe
/// <p>
/// any FHIR3 code may be used; 
/// adverse-event-seriousness shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property seriousness As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "seriousness", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// resolved | recovering | ongoing | resolvedWithSequelae | fatal | unknown
/// <p>
/// adverse-event-outcome is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend adverse-event-outcome and you may NOT use codes from other ValueSets.
Property outcome As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "outcome", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Who recorded the adverse event.
/// <p>
/// Patient | Practitioner | RelatedPerson
Property recorder As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "recorder", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Who  was involved in the adverse event or the potential adverse event.
/// <p>
/// Practitioner | Device
Property eventParticipant As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "eventParticipant", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Description of the adverse event.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// The suspected agent causing the adverse event.
Property suspectEntity As list Of HS.FHIR.DTL.vSTU3.Model.Element.AdverseEvent.suspectEntity(XMLNAME = "suspectEntity", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// AdverseEvent:subjectMedicalHistory.
/// <p>
/// Condition | Observation | AllergyIntolerance | FamilyMemberHistory | Immunization | Procedure
Property subjectMedicalHistory As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "subjectMedicalHistory", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// AdverseEvent:referenceDocument.
/// <p>
/// DocumentReference
Property referenceDocument As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "referenceDocument", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// AdverseEvent:study.
/// <p>
/// ResearchStudy
Property study As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "study", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "AdverseEvent";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "AdverseEvent";

}
