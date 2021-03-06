/// In-line definition of activity.
Class HS.FHIR.DTL.vDSTU2.Model.Element.CarePlan.activity.detail Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// diet | drug | encounter | observation | procedure | supply | other
/// <p>
/// any FHIR2 code may be used; 
/// care-plan-activity-category shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property category As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "category", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Detail type of activity.
/// <p>
/// any FHIR2 code may be used; 
/// care-plan-activity shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property code As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "code", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Why activity should be done.
/// <p>
/// any FHIR2 code may be used; 
/// activity-reason shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property reasonCode As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "reasonCode", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Condition triggering need for activity.
/// <p>
/// Condition
Property reasonReference As list Of HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "reasonReference", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Goals this activity relates to.
/// <p>
/// Goal
Property goal As list Of HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "goal", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// not-started | scheduled | in-progress | on-hold | completed | cancelled
/// <p>
/// care-plan-activity-status is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend care-plan-activity-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Reason for current status.
/// <p>
/// any FHIR2 code may be used; 
/// goal-status-reason shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property statusReason As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "statusReason", XMLPROJECTION = "ELEMENT");

/// boolean
/// <p>
/// Do NOT do.
Property prohibited As %Boolean(XMLNAME = "prohibited", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Period
/// <p>
/// When activity is to occur.
Property scheduledPeriod As HS.FHIR.DTL.vDSTU2.Model.Datatype.Period(XMLNAME = "scheduledPeriod", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// When activity is to occur.
Property scheduledString As %String(MAXLEN = 1000000, XMLNAME = "scheduledString", XMLPROJECTION = "ATTRIBUTE");

/// Timing
/// <p>
/// When activity is to occur.
Property scheduledTiming As HS.FHIR.DTL.vDSTU2.Model.Datatype.Timing(XMLNAME = "scheduledTiming", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Where it should happen.
/// <p>
/// Location
Property location As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "location", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Who will be responsible?
/// <p>
/// Practitioner | Organization | RelatedPerson | Patient
Property performer As list Of HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "performer", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// What is to be administered/supplied.
/// <p>
/// any FHIR2 code may be used; 
/// medication-codes shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property productCodeableConcept As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "productCodeableConcept", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// What is to be administered/supplied.
/// <p>
/// Medication | Substance
Property productReference As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "productReference", XMLPROJECTION = "ELEMENT");

/// SimpleQuantity
/// <p>
/// How to consume/day?
Property dailyAmount As HS.FHIR.DTL.vDSTU2.Model.Datatype.SimpleQuantity(XMLNAME = "dailyAmount", XMLPROJECTION = "ELEMENT");

/// SimpleQuantity
/// <p>
/// How much to administer/supply/consume.
Property quantity As HS.FHIR.DTL.vDSTU2.Model.Datatype.SimpleQuantity(XMLNAME = "quantity", XMLPROJECTION = "ELEMENT");

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
