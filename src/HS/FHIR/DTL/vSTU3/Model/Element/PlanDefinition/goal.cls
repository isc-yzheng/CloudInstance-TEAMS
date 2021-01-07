/// What the plan is trying to accomplish.
Class HS.FHIR.DTL.vSTU3.Model.Element.PlanDefinition.goal Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

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
Property category As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "category", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Code or text describing the goal.
/// <p>
/// any FHIR3 code may be used; 
/// clinical-findings shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property description As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "description", XMLPROJECTION = "ELEMENT") [ Required ];

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
/// When goal pursuit begins.
/// <p>
/// any FHIR3 code may be used; 
/// goal-start-event shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property start As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "start", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// What does the goal address.
/// <p>
/// any FHIR3 code may be used; 
/// condition-code shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property addresses As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "addresses", XMLPROJECTION = "ELEMENT");

/// RelatedArtifact
/// <p>
/// Supporting documentation for the goal.
Property documentation As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.RelatedArtifact(XMLNAME = "documentation", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Target outcome for the goal.
Property target As list Of HS.FHIR.DTL.vSTU3.Model.Element.PlanDefinition.goal.target(XMLNAME = "target", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "PlanDefinition.goal";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "PlanDefinition.goal";

}
