/// In-line definition of activity.
Class HS.FHIR.DTL.vR4.Model.Element.CarePlan.activity.detail Extends HS.FHIR.DTL.vR4.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// code
/// <p>
/// Appointment | CommunicationRequest | DeviceRequest | MedicationRequest | NutritionOrder | Task | ServiceRequest | VisionPrescription
/// <p>
/// care-plan-activity-kind|4.0.1 is the REQUIRED FHIR4 ValueSet for codes; 
/// you may NOT extend care-plan-activity-kind|4.0.1 and you may NOT use codes from other ValueSets.
Property kind As %String(MAXLEN = 1000000, XMLNAME = "kind", XMLPROJECTION = "ATTRIBUTE");

/// canonical
/// <p>
/// Instantiates FHIR protocol or definition.
/// <p>
/// TO DO: Unrecognized value type for the FHIR4 model
Property instantiatesCanonical As list Of %String(MAXLEN = 1000000, XMLNAME = "instantiatesCanonical", XMLPROJECTION = "ELEMENT");

/// uri
/// <p>
/// Instantiates external protocol or definition.
Property instantiatesUri As list Of %String(MAXLEN = 1000000, XMLNAME = "instantiatesUri", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Detail type of activity.
/// <p>
/// any FHIR4 code may be used; 
/// procedure-code shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property code As HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "code", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Why activity should be done or why activity was prohibited.
/// <p>
/// any FHIR4 code may be used; 
/// clinical-findings shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property reasonCode As list Of HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "reasonCode", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Why activity is needed.
/// <p>
/// Condition | Observation | DiagnosticReport | DocumentReference
Property reasonReference As list Of HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "reasonReference", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Goals this activity relates to.
/// <p>
/// Goal
Property goal As list Of HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "goal", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// not-started | scheduled | in-progress | on-hold | completed | cancelled | stopped | unknown | entered-in-error
/// <p>
/// care-plan-activity-status|4.0.1 is the REQUIRED FHIR4 ValueSet for codes; 
/// you may NOT extend care-plan-activity-status|4.0.1 and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// CodeableConcept
/// <p>
/// Reason for current status.
/// <p>
/// any FHIR4 code from any ValueSet may be used.
Property statusReason As HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "statusReason", XMLPROJECTION = "ELEMENT");

/// boolean
/// <p>
/// If true, 
/// activity is prohibiting action.
Property doNotPerform As %Boolean(XMLNAME = "doNotPerform", XMLPROJECTION = "ATTRIBUTE");

/// Period
/// <p>
/// When activity is to occur.
Property scheduledPeriod As HS.FHIR.DTL.vR4.Model.Datatype.Period(XMLNAME = "scheduledPeriod", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// When activity is to occur.
Property scheduledString As %String(MAXLEN = 1000000, XMLNAME = "scheduledString", XMLPROJECTION = "ATTRIBUTE");

/// Timing
/// <p>
/// When activity is to occur.
Property scheduledTiming As HS.FHIR.DTL.vR4.Model.Datatype.Timing(XMLNAME = "scheduledTiming", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Where it should happen.
/// <p>
/// Location
Property location As HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "location", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Who will be responsible?
/// <p>
/// Practitioner | PractitionerRole | Organization | RelatedPerson | Patient | CareTeam | HealthcareService | Device
Property performer As list Of HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "performer", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// What is to be administered/supplied.
/// <p>
/// any FHIR4 code may be used; 
/// medication-codes shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property productCodeableConcept As HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "productCodeableConcept", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// What is to be administered/supplied.
/// <p>
/// Medication | Substance
Property productReference As HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "productReference", XMLPROJECTION = "ELEMENT");

/// Quantity
/// <p>
/// How to consume/day?
Property dailyAmount As HS.FHIR.DTL.vR4.Model.Datatype.Quantity(XMLNAME = "dailyAmount", XMLPROJECTION = "ELEMENT");

/// Quantity
/// <p>
/// How much to administer/supply/consume.
Property quantity As HS.FHIR.DTL.vR4.Model.Datatype.Quantity(XMLNAME = "quantity", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Extra info describing activity to perform.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "CarePlan.activity.detail";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "CarePlan.activity.detail";

}
