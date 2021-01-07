/// A record of a medication that is being consumed by a Patient: A MedicationStatement may indicate that the patient may be taking the medication now, 
/// or has taken the medication in the past or will be taking the medication in the future. 
/// The source of this information can be the patient, 
/// significant other (such as a family member or spouse), 
/// or a clinician. 
/// A common scenario where this information is captured is during the history taking process during a patient visit or stay. 
/// The medication information may come from sources such as the patient's memory, 
/// from a prescription bottle, 
/// or from a list of medications the patient, 
/// clinician or other party maintains The primary difference between a medication statement and a medication administration is that the medication administration has complete administration information and is based on actual administration information from the person who administered the medication. 
/// A medication statement is often, 
/// if not always, 
/// less specific. 
/// There is no required date/time when the medication was administered, 
/// in fact we only know that a source has reported the patient is taking this medication, 
/// where details such as time, 
/// quantity, 
/// or rate or even medication product may be incomplete or missing or less precise. 
/// As stated earlier, 
/// the medication statement information may come from the patient's memory, 
/// from a prescription bottle or from a list of medications the patient, 
/// clinician or other party maintains. 
/// Medication administration is more formal and is not missing detailed information.
Class HS.FHIR.DTL.vSTU3.Model.Resource.MedicationStatement Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// External identifier.
Property identifier As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Fulfils plan, 
/// proposal or order.
/// <p>
/// MedicationRequest | CarePlan | ProcedureRequest | ReferralRequest
Property basedOn As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "basedOn", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Part of referenced event.
/// <p>
/// MedicationAdministration | MedicationDispense | MedicationStatement | Procedure | Observation
Property partOf As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "partOf", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Encounter / Episode associated with MedicationStatement.
/// <p>
/// Encounter | EpisodeOfCare
Property context As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "context", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// active | completed | entered-in-error | intended | stopped | on-hold
/// <p>
/// medication-statement-status is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend medication-statement-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// CodeableConcept
/// <p>
/// Type of medication usage.
/// <p>
/// medication-statement-category is the PREFERRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in medication-statement-category, 
/// you may use codes from any ValueSet.
Property category As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "category", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// What medication was taken.
/// <p>
/// any FHIR3 code may be used; 
/// medication-codes shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property medicationCodeableConcept As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "medicationCodeableConcept", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// What medication was taken.
/// <p>
/// Medication.
Property medicationReference As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "medicationReference", XMLPROJECTION = "ELEMENT") [ Required ];

/// dateTime
/// <p>
/// The date/time or interval when the medication was taken.
Property effectiveDateTime As %String(MAXLEN = 1000000, XMLNAME = "effectiveDateTime", XMLPROJECTION = "ATTRIBUTE");

/// Period
/// <p>
/// The date/time or interval when the medication was taken.
Property effectivePeriod As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "effectivePeriod", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// When the statement was asserted?
Property dateAsserted As %String(MAXLEN = 1000000, XMLNAME = "dateAsserted", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Person or organization that provided the information about the taking of this medication.
/// <p>
/// Patient | Practitioner | RelatedPerson | Organization
Property informationSource As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "informationSource", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Who is/was taking  the medication.
/// <p>
/// Patient | Group
Property subject As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "subject", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Additional supporting information.
/// <p>
/// Any FHIR3 Resource may be indicated by this Reference
Property derivedFrom As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "derivedFrom", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// y | n | unk | na
/// <p>
/// medication-statement-taken is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend medication-statement-taken and you may NOT use codes from other ValueSets.
Property taken As %String(MAXLEN = 1000000, XMLNAME = "taken", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// CodeableConcept
/// <p>
/// True if asserting medication was not given.
/// <p>
/// any FHIR3 code may be used; 
/// reason-medication-not-taken-codes shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property reasonNotTaken As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "reasonNotTaken", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Reason for why the medication is being/was taken.
/// <p>
/// any FHIR3 code may be used; 
/// condition-code shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property reasonCode As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "reasonCode", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Condition or observation that supports why the medication is being/was taken.
/// <p>
/// Condition | Observation
Property reasonReference As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "reasonReference", XMLPROJECTION = "ELEMENT");

/// Annotation
/// <p>
/// Further information about the statement.
Property note As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Annotation(XMLNAME = "note", XMLPROJECTION = "ELEMENT");

/// Dosage
/// <p>
/// Details of how medication is/was taken or should be taken.
Property dosage As list Of HS.FHIR.DTL.vSTU3.Model.Element.Dosage(XMLNAME = "dosage", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "MedicationStatement";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "MedicationStatement";

}
