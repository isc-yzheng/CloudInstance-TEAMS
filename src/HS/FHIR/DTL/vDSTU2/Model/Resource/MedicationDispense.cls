/// Dispensing a medication to a named patient.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.MedicationDispense Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// External identifier.
Property identifier As HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// in-progress | on-hold | completed | entered-in-error | stopped
/// <p>
/// medication-dispense-status is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend medication-dispense-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Who the dispense is for.
/// <p>
/// Patient
Property patient As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "patient", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Practitioner responsible for dispensing medication.
/// <p>
/// Practitioner
Property dispenser As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "dispenser", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Medication order that authorizes the dispense.
/// <p>
/// MedicationOrder
Property authorizingPrescription As list Of HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "authorizingPrescription", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Trial fill, 
/// partial fill, 
/// emergency fill, 
/// etc.
/// <p>
/// any FHIR2 code may be used; 
/// v3-ActPharmacySupplyType shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property type As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

/// SimpleQuantity
/// <p>
/// Amount dispensed.
Property quantity As HS.FHIR.DTL.vDSTU2.Model.Datatype.SimpleQuantity(XMLNAME = "quantity", XMLPROJECTION = "ELEMENT");

/// SimpleQuantity
/// <p>
/// Days Supply.
Property daysSupply As HS.FHIR.DTL.vDSTU2.Model.Datatype.SimpleQuantity(XMLNAME = "daysSupply", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// What medication was supplied.
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property medicationCodeableConcept As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "medicationCodeableConcept", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// What medication was supplied.
/// <p>
/// Medication.
Property medicationReference As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "medicationReference", XMLPROJECTION = "ELEMENT") [ Required ];

/// dateTime
/// <p>
/// Dispense processing time.
Property whenPrepared As %String(MAXLEN = 1000000, XMLNAME = "whenPrepared", XMLPROJECTION = "ATTRIBUTE");

/// dateTime
/// <p>
/// When product was given out.
Property whenHandedOver As %String(MAXLEN = 1000000, XMLNAME = "whenHandedOver", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Where the medication was sent.
/// <p>
/// Location
Property destination As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "destination", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Who collected the medication.
/// <p>
/// Patient | Practitioner
Property receiver As list Of HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "receiver", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Information about the dispense.
Property note As %String(MAXLEN = 1000000, XMLNAME = "note", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Medicine administration instructions to the patient/caregiver.
Property dosageInstruction As list Of HS.FHIR.DTL.vDSTU2.Model.Element.MedicationDispense.dosageInstruction(XMLNAME = "dosageInstruction", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Deals with substitution of one medicine for another.
Property substitution As HS.FHIR.DTL.vDSTU2.Model.Element.MedicationDispense.substitution(XMLNAME = "substitution", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "MedicationDispense";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "MedicationDispense";

}
