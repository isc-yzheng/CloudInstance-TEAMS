/// Prescription of medication to for patient.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.MedicationOrder Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// External identifier.
Property identifier As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// When prescription was authorized.
Property dateWritten As %String(MAXLEN = 1000000, XMLNAME = "dateWritten", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// active | on-hold | completed | entered-in-error | stopped | draft
/// <p>
/// medication-order-status is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend medication-order-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE");

/// dateTime
/// <p>
/// When prescription was stopped.
Property dateEnded As %String(MAXLEN = 1000000, XMLNAME = "dateEnded", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Why prescription was stopped.
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property reasonEnded As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "reasonEnded", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Who prescription is for.
/// <p>
/// Patient
Property patient As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "patient", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Who ordered the medication(s)
/// <p>
/// Practitioner
Property prescriber As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "prescriber", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Created during encounter/admission/stay.
/// <p>
/// Encounter
Property encounter As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "encounter", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Reason or indication for writing the prescription.
/// <p>
/// any FHIR2 code may be used; 
/// condition-code shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property reasonCodeableConcept As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "reasonCodeableConcept", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Reason or indication for writing the prescription.
/// <p>
/// Condition.
Property reasonReference As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "reasonReference", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Information about the prescription.
Property note As %String(MAXLEN = 1000000, XMLNAME = "note", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Medication to be taken.
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property medicationCodeableConcept As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "medicationCodeableConcept", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Medication to be taken.
/// <p>
/// Medication.
Property medicationReference As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "medicationReference", XMLPROJECTION = "ELEMENT") [ Required ];

/// BackboneElement
/// <p>
/// How medication should be taken.
Property dosageInstruction As list Of HS.FHIR.DTL.vDSTU2.Model.Element.MedicationOrder.dosageInstruction(XMLNAME = "dosageInstruction", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Medication supply authorization.
Property dispenseRequest As HS.FHIR.DTL.vDSTU2.Model.Element.MedicationOrder.dispenseRequest(XMLNAME = "dispenseRequest", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Any restrictions on medication substitution.
Property substitution As HS.FHIR.DTL.vDSTU2.Model.Element.MedicationOrder.substitution(XMLNAME = "substitution", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// An order/prescription that this supersedes.
/// <p>
/// MedicationOrder
Property priorPrescription As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "priorPrescription", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "MedicationOrder";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "MedicationOrder";

}
