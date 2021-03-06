/// Action defined by the plan.
Class HS.FHIR.DTL.vR4.Model.Element.PlanDefinition.action Extends HS.FHIR.DTL.vR4.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// string
/// <p>
/// User-visible prefix for the action (e.g. 
/// 1. 
/// or A.)
Property prefix As %String(MAXLEN = 1000000, XMLNAME = "prefix", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// User-visible title.
Property title As %String(MAXLEN = 1000000, XMLNAME = "title", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Brief description of the action.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Static text equivalent of the action, 
/// used if the dynamic aspects cannot be interpreted by the receiving system.
Property textEquivalent As %String(MAXLEN = 1000000, XMLNAME = "textEquivalent", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// routine | urgent | asap | stat
/// <p>
/// request-priority|4.0.1 is the REQUIRED FHIR4 ValueSet for codes; 
/// you may NOT extend request-priority|4.0.1 and you may NOT use codes from other ValueSets.
Property priority As %String(MAXLEN = 1000000, XMLNAME = "priority", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Code representing the meaning of the action or sub-actions.
/// <p>
/// any FHIR4 code from any ValueSet may be used.
Property code As list Of HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "code", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Why the action should be performed.
/// <p>
/// any FHIR4 code from any ValueSet may be used.
Property reason As list Of HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "reason", XMLPROJECTION = "ELEMENT");

/// RelatedArtifact
/// <p>
/// Supporting documentation for the intended performer of the action.
Property documentation As list Of HS.FHIR.DTL.vR4.Model.Datatype.RelatedArtifact(XMLNAME = "documentation", XMLPROJECTION = "ELEMENT");

/// id
/// <p>
/// What goals this action supports.
Property goalId As list Of %String(MAXLEN = 1000000, XMLNAME = "goalId", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Type of individual the action is focused on.
/// <p>
/// subject-type is the REQUIRED FHIR4 ValueSet for codes, 
/// but if you need to express meanings not found in subject-type, 
/// you may formally EXTEND subject-type to add codes to it.
Property subjectCodeableConcept As HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "subjectCodeableConcept", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Type of individual the action is focused on.
/// <p>
/// Group.
Property subjectReference As HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "subjectReference", XMLPROJECTION = "ELEMENT");

/// TriggerDefinition
/// <p>
/// When the action should be triggered.
Property trigger As list Of HS.FHIR.DTL.vR4.Model.Datatype.TriggerDefinition(XMLNAME = "trigger", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Whether or not the action is applicable.
Property condition As list Of HS.FHIR.DTL.vR4.Model.Element.PlanDefinition.action.condition(XMLNAME = "condition", XMLPROJECTION = "ELEMENT");

/// DataRequirement
/// <p>
/// Input data requirements.
Property input As list Of HS.FHIR.DTL.vR4.Model.Datatype.DataRequirement(XMLNAME = "input", XMLPROJECTION = "ELEMENT");

/// DataRequirement
/// <p>
/// Output data definition.
Property output As list Of HS.FHIR.DTL.vR4.Model.Datatype.DataRequirement(XMLNAME = "output", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Relationship to another action.
Property relatedAction As list Of HS.FHIR.DTL.vR4.Model.Element.PlanDefinition.action.relatedAction(XMLNAME = "relatedAction", XMLPROJECTION = "ELEMENT");

/// Age
/// <p>
/// When the action should take place.
Property timingAge As HS.FHIR.DTL.vR4.Model.Datatype.Age(XMLNAME = "timingAge", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// When the action should take place.
Property timingDateTime As %String(MAXLEN = 1000000, XMLNAME = "timingDateTime", XMLPROJECTION = "ATTRIBUTE");

/// Duration
/// <p>
/// When the action should take place.
Property timingDuration As HS.FHIR.DTL.vR4.Model.Datatype.Duration(XMLNAME = "timingDuration", XMLPROJECTION = "ELEMENT");

/// Period
/// <p>
/// When the action should take place.
Property timingPeriod As HS.FHIR.DTL.vR4.Model.Datatype.Period(XMLNAME = "timingPeriod", XMLPROJECTION = "ELEMENT");

/// Range
/// <p>
/// When the action should take place.
Property timingRange As HS.FHIR.DTL.vR4.Model.Datatype.Range(XMLNAME = "timingRange", XMLPROJECTION = "ELEMENT");

/// Timing
/// <p>
/// When the action should take place.
Property timingTiming As HS.FHIR.DTL.vR4.Model.Datatype.Timing(XMLNAME = "timingTiming", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Who should participate in the action.
Property participant As list Of HS.FHIR.DTL.vR4.Model.Element.PlanDefinition.action.participant(XMLNAME = "participant", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// create | update | remove | fire-event
/// <p>
/// action-type is the REQUIRED FHIR4 ValueSet for codes, 
/// but if you need to express meanings not found in action-type, 
/// you may formally EXTEND action-type to add codes to it.
Property type As HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// visual-group | logical-group | sentence-group
/// <p>
/// action-grouping-behavior|4.0.1 is the REQUIRED FHIR4 ValueSet for codes; 
/// you may NOT extend action-grouping-behavior|4.0.1 and you may NOT use codes from other ValueSets.
Property groupingBehavior As %String(MAXLEN = 1000000, XMLNAME = "groupingBehavior", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// any | all | all-or-none | exactly-one | at-most-one | one-or-more
/// <p>
/// action-selection-behavior|4.0.1 is the REQUIRED FHIR4 ValueSet for codes; 
/// you may NOT extend action-selection-behavior|4.0.1 and you may NOT use codes from other ValueSets.
Property selectionBehavior As %String(MAXLEN = 1000000, XMLNAME = "selectionBehavior", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// must | could | must-unless-documented
/// <p>
/// action-required-behavior|4.0.1 is the REQUIRED FHIR4 ValueSet for codes; 
/// you may NOT extend action-required-behavior|4.0.1 and you may NOT use codes from other ValueSets.
Property requiredBehavior As %String(MAXLEN = 1000000, XMLNAME = "requiredBehavior", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// yes | no
/// <p>
/// action-precheck-behavior|4.0.1 is the REQUIRED FHIR4 ValueSet for codes; 
/// you may NOT extend action-precheck-behavior|4.0.1 and you may NOT use codes from other ValueSets.
Property precheckBehavior As %String(MAXLEN = 1000000, XMLNAME = "precheckBehavior", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// single | multiple
/// <p>
/// action-cardinality-behavior|4.0.1 is the REQUIRED FHIR4 ValueSet for codes; 
/// you may NOT extend action-cardinality-behavior|4.0.1 and you may NOT use codes from other ValueSets.
Property cardinalityBehavior As %String(MAXLEN = 1000000, XMLNAME = "cardinalityBehavior", XMLPROJECTION = "ATTRIBUTE");

/// canonical
/// <p>
/// Description of the activity to be performed.
/// <p>
/// TO DO: Unrecognized value type for the FHIR4 model
Property definitionCanonical As %String(MAXLEN = 1000000, XMLNAME = "definitionCanonical", XMLPROJECTION = "ATTRIBUTE");

/// uri
/// <p>
/// Description of the activity to be performed.
Property definitionUri As %String(MAXLEN = 1000000, XMLNAME = "definitionUri", XMLPROJECTION = "ATTRIBUTE");

/// canonical
/// <p>
/// Transform to apply the template.
/// <p>
/// TO DO: Unrecognized value type for the FHIR4 model
Property transform As %String(MAXLEN = 1000000, XMLNAME = "transform", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Dynamic aspects of the definition.
Property dynamicValue As list Of HS.FHIR.DTL.vR4.Model.Element.PlanDefinition.action.dynamicValue(XMLNAME = "dynamicValue", XMLPROJECTION = "ELEMENT");

/// PlanDefinition:action
/// <p>
/// A sub-action.
Property action As list Of HS.FHIR.DTL.vR4.Model.Element.PlanDefinition.action(XMLNAME = "action", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "PlanDefinition.action";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "PlanDefinition.action";

}
