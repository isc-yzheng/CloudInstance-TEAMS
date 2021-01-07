/// Administration of medication to a patient.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.MedicationAdministration Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// External identifier.
Property identifier As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// in-progress | on-hold | completed | entered-in-error | stopped
/// <p>
/// medication-admin-status is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend medication-admin-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Reference
/// <p>
/// Who received medication.
/// <p>
/// Patient
Property patient As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "patient", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Who administered substance.
/// <p>
/// Practitioner | Patient | RelatedPerson
Property practitioner As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "practitioner", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Encounter administered as part of.
/// <p>
/// Encounter
Property encounter As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "encounter", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Order administration performed against.
/// <p>
/// MedicationOrder
Property prescription As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "prescription", XMLPROJECTION = "ELEMENT");

/// boolean
/// <p>
/// True if medication not administered.
Property wasNotGiven As %Boolean(XMLNAME = "wasNotGiven", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Reason administration not performed.
/// <p>
/// any FHIR2 code may be used; 
/// reason-medication-not-given-codes shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property reasonNotGiven As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "reasonNotGiven", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Reason administration performed.
/// <p>
/// any FHIR2 code may be used; 
/// reason-medication-given-codes shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property reasonGiven As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "reasonGiven", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// Start and end time of administration.
Property effectiveTimeDateTime As %String(MAXLEN = 1000000, XMLNAME = "effectiveTimeDateTime", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Period
/// <p>
/// Start and end time of administration.
Property effectiveTimePeriod As HS.FHIR.DTL.vDSTU2.Model.Datatype.Period(XMLNAME = "effectiveTimePeriod", XMLPROJECTION = "ELEMENT") [ Required ];

/// CodeableConcept
/// <p>
/// What was administered.
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property medicationCodeableConcept As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "medicationCodeableConcept", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// What was administered.
/// <p>
/// Medication.
Property medicationReference As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "medicationReference", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Device used to administer.
/// <p>
/// Device
Property device As list Of HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "device", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Information about the administration.
Property note As %String(MAXLEN = 1000000, XMLNAME = "note", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Details of how medication was taken.
Property dosage As HS.FHIR.DTL.vDSTU2.Model.Element.MedicationAdministration.dosage(XMLNAME = "dosage", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "MedicationAdministration";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "MedicationAdministration";

}
