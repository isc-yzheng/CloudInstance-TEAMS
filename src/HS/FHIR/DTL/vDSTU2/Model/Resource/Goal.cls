/// Describes the intended objective(s) for a patient, 
/// group or organization.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.Goal Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// External Ids for this goal.
Property identifier As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Who this goal is intended for.
/// <p>
/// Patient | Group | Organization
Property subject As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "subject", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// When goal pursuit begins.
/// <p>
/// any FHIR2 code may be used; 
/// goal-start-event shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property startCodeableConcept As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "startCodeableConcept", XMLPROJECTION = "ELEMENT");

/// date
/// <p>
/// When goal pursuit begins.
Property startDate As %String(MAXLEN = 1000000, XMLNAME = "startDate", XMLPROJECTION = "ATTRIBUTE");

/// date
/// <p>
/// Reach goal on or before.
Property targetDate As %String(MAXLEN = 1000000, XMLNAME = "targetDate", XMLPROJECTION = "ATTRIBUTE");

/// Quantity
/// <p>
/// Reach goal on or before.
Property targetQuantity As HS.FHIR.DTL.vDSTU2.Model.Datatype.Quantity(XMLNAME = "targetQuantity", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// E.g. 
/// Treatment, 
/// dietary, 
/// behavioral, 
/// etc.
/// <p>
/// any FHIR2 code may be used; 
/// goal-category shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property category As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "category", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// What's the desired outcome?
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// code
/// <p>
/// proposed | planned | accepted | rejected | in-progress | achieved | sustaining | on-hold | cancelled
/// <p>
/// goal-status is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend goal-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// date
/// <p>
/// When goal status took effect.
Property statusDate As %String(MAXLEN = 1000000, XMLNAME = "statusDate", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Reason for current status.
/// <p>
/// any FHIR2 code may be used; 
/// goal-status-reason shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property statusReason As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "statusReason", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Who's responsible for creating Goal?
/// <p>
/// Patient | Practitioner | RelatedPerson
Property author As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "author", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// high | medium |low
/// <p>
/// goal-priority is the PREFERRED FHIR2 ValueSet for codes, 
/// but if you need to express meanings not found in goal-priority, 
/// you may use codes from any ValueSet.
Property priority As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "priority", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Issues addressed by this goal.
/// <p>
/// Condition | Observation | MedicationStatement | NutritionOrder | ProcedureRequest | RiskAssessment
Property addresses As list Of HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "addresses", XMLPROJECTION = "ELEMENT");

/// Annotation
/// <p>
/// Comments about the goal.
Property note As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Annotation(XMLNAME = "note", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// What was end result of goal?
Property outcome As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Goal.outcome(XMLNAME = "outcome", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Goal";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Goal";

}
