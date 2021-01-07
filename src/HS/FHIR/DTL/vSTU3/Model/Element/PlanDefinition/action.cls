/// Action defined by the plan.
Class HS.FHIR.DTL.vSTU3.Model.Element.PlanDefinition.action Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// string
/// <p>
/// User-visible label for the action (e.g. 
/// 1. 
/// or A.)
Property label As %String(MAXLEN = 1000000, XMLNAME = "label", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// User-visible title.
Property title As %String(MAXLEN = 1000000, XMLNAME = "title", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Short description of the action.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Static text equivalent of the action, 
/// used if the dynamic aspects cannot be interpreted by the receiving system.
Property textEquivalent As %String(MAXLEN = 1000000, XMLNAME = "textEquivalent", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Code representing the meaning of the action or sub-actions.
/// <p>
/// any FHIR3 code from any ValueSet may be used.
Property code As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "code", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Why the action should be performed.
/// <p>
/// any FHIR3 code from any ValueSet may be used.
Property reason As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "reason", XMLPROJECTION = "ELEMENT");

/// RelatedArtifact
/// <p>
/// Supporting documentation for the intended performer of the action.
Property documentation As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.RelatedArtifact(XMLNAME = "documentation", XMLPROJECTION = "ELEMENT");

/// id
/// <p>
/// What goals this action supports.
Property goalId As list Of %String(MAXLEN = 1000000, XMLNAME = "goalId", XMLPROJECTION = "ELEMENT");

/// TriggerDefinition
/// <p>
/// When the action should be triggered.
Property triggerDefinition As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.TriggerDefinition(XMLNAME = "triggerDefinition", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Whether or not the action is applicable.
Property condition As list Of HS.FHIR.DTL.vSTU3.Model.Element.PlanDefinition.action.condition(XMLNAME = "condition", XMLPROJECTION = "ELEMENT");

/// DataRequirement
/// <p>
/// Input data requirements.
Property input As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.DataRequirement(XMLNAME = "input", XMLPROJECTION = "ELEMENT");

/// DataRequirement
/// <p>
/// Output data definition.
Property output As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.DataRequirement(XMLNAME = "output", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Relationship to another action.
Property relatedAction As list Of HS.FHIR.DTL.vSTU3.Model.Element.PlanDefinition.action.relatedAction(XMLNAME = "relatedAction", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// When the action should take place.
Property timingDateTime As %String(MAXLEN = 1000000, XMLNAME = "timingDateTime", XMLPROJECTION = "ATTRIBUTE");

/// Duration
/// <p>
/// When the action should take place.
Property timingDuration As HS.FHIR.DTL.vSTU3.Model.Datatype.Duration(XMLNAME = "timingDuration", XMLPROJECTION = "ELEMENT");

/// Period
/// <p>
/// When the action should take place.
Property timingPeriod As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "timingPeriod", XMLPROJECTION = "ELEMENT");

/// Range
/// <p>
/// When the action should take place.
Property timingRange As HS.FHIR.DTL.vSTU3.Model.Datatype.Range(XMLNAME = "timingRange", XMLPROJECTION = "ELEMENT");

/// Timing
/// <p>
/// When the action should take place.
Property timingTiming As HS.FHIR.DTL.vSTU3.Model.Datatype.Timing(XMLNAME = "timingTiming", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Who should participate in the action.
Property participant As list Of HS.FHIR.DTL.vSTU3.Model.Element.PlanDefinition.action.participant(XMLNAME = "participant", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// create | update | remove | fire-event
/// <p>
/// action-type is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend action-type and you may NOT use codes from other ValueSets.
Property type As HS.FHIR.DTL.vSTU3.Model.Datatype.Coding(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// visual-group | logical-group | sentence-group
/// <p>
/// action-grouping-behavior is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend action-grouping-behavior and you may NOT use codes from other ValueSets.
Property groupingBehavior As %String(MAXLEN = 1000000, XMLNAME = "groupingBehavior", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// any | all | all-or-none | exactly-one | at-most-one | one-or-more
/// <p>
/// action-selection-behavior is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend action-selection-behavior and you may NOT use codes from other ValueSets.
Property selectionBehavior As %String(MAXLEN = 1000000, XMLNAME = "selectionBehavior", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// must | could | must-unless-documented
/// <p>
/// action-required-behavior is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend action-required-behavior and you may NOT use codes from other ValueSets.
Property requiredBehavior As %String(MAXLEN = 1000000, XMLNAME = "requiredBehavior", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// yes | no
/// <p>
/// action-precheck-behavior is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend action-precheck-behavior and you may NOT use codes from other ValueSets.
Property precheckBehavior As %String(MAXLEN = 1000000, XMLNAME = "precheckBehavior", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// single | multiple
/// <p>
/// action-cardinality-behavior is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend action-cardinality-behavior and you may NOT use codes from other ValueSets.
Property cardinalityBehavior As %String(MAXLEN = 1000000, XMLNAME = "cardinalityBehavior", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Description of the activity to be performed.
/// <p>
/// ActivityDefinition | PlanDefinition
Property definition As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "definition", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Transform to apply the template.
/// <p>
/// StructureMap
Property transform As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "transform", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Dynamic aspects of the definition.
Property dynamicValue As list Of HS.FHIR.DTL.vSTU3.Model.Element.PlanDefinition.action.dynamicValue(XMLNAME = "dynamicValue", XMLPROJECTION = "ELEMENT");

/// PlanDefinition:action
/// <p>
/// A sub-action.
Property action As list Of HS.FHIR.DTL.vSTU3.Model.Element.PlanDefinition.action(XMLNAME = "action", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "PlanDefinition.action";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "PlanDefinition.action";

}
