/// Whether or not the action is applicable.
Class HS.FHIR.DTL.vR4.Model.Element.PlanDefinition.action.condition Extends HS.FHIR.DTL.vR4.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// code
/// <p>
/// applicability | start | stop
/// <p>
/// action-condition-kind|4.0.1 is the REQUIRED FHIR4 ValueSet for codes; 
/// you may NOT extend action-condition-kind|4.0.1 and you may NOT use codes from other ValueSets.
Property kind As %String(MAXLEN = 1000000, XMLNAME = "kind", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Expression
/// <p>
/// Boolean-valued expression.
Property expression As HS.FHIR.DTL.vR4.Model.Datatype.Expression(XMLNAME = "expression", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "PlanDefinition.action.condition";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "PlanDefinition.action.condition";

}
