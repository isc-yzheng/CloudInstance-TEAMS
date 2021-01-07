/// Describes the intended objective(s) for a patient, 
/// group or organization care, 
/// for example, 
/// weight loss, 
/// restoring an activity of daily living, 
/// obtaining herd immunity via immunization, 
/// meeting a process improvement objective, 
/// etc.
Class HS.FHIR.DTL.vSTU3.Model.Resource.Goal Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// External Ids for this goal.
Property identifier As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// proposed | accepted | planned | in-progress | on-target | ahead-of-target | behind-target | sustaining | achieved | on-hold | cancelled | entered-in-error | rejected
/// <p>
/// goal-status is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend goal-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// CodeableConcept
/// <p>
/// E.g. 
/// Treatment, 
/// dietary, 
/// behavioral, 
/// etc.
/// <p>
/// any FHIR3 code may be used; 
/// goal-category shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property category As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "category", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// high-priority | medium-priority | low-priority
/// <p>
/// goal-priority is the PREFERRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in goal-priority, 
/// you may use codes from any ValueSet.
Property priority As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "priority", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Code or text describing goal.
/// <p>
/// any FHIR3 code may be used; 
/// clinical-findings shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property description As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "description", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Who this goal is intended for.
/// <p>
/// Patient | Group | Organization
Property subject As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "subject", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// When goal pursuit begins. 
/// 
/// <p>
/// any FHIR3 code may be used; 
/// goal-start-event shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property startCodeableConcept As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "startCodeableConcept", XMLPROJECTION = "ELEMENT");

/// date
/// <p>
/// When goal pursuit begins. 
/// 
Property startDate As %String(MAXLEN = 1000000, XMLNAME = "startDate", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Target outcome for the goal.
Property target As HS.FHIR.DTL.vSTU3.Model.Element.Goal.target(XMLNAME = "target", XMLPROJECTION = "ELEMENT");

/// date
/// <p>
/// When goal status took effect.
Property statusDate As %String(MAXLEN = 1000000, XMLNAME = "statusDate", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Reason for current status.
Property statusReason As %String(MAXLEN = 1000000, XMLNAME = "statusReason", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Who's responsible for creating Goal?
/// <p>
/// Patient | Practitioner | RelatedPerson
Property expressedBy As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "expressedBy", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Issues addressed by this goal.
/// <p>
/// Condition | Observation | MedicationStatement | NutritionOrder | ProcedureRequest | RiskAssessment
Property addresses As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "addresses", XMLPROJECTION = "ELEMENT");

/// Annotation
/// <p>
/// Comments about the goal.
Property note As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Annotation(XMLNAME = "note", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// What result was achieved regarding the goal?
/// <p>
/// any FHIR3 code may be used; 
/// clinical-findings shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property outcomeCode As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "outcomeCode", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Observation that resulted from goal.
/// <p>
/// Observation
Property outcomeReference As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "outcomeReference", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Goal";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Goal";

}
