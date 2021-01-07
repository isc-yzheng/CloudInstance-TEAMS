/// Each step of the process.
Class HS.FHIR.DTL.vR4.Model.Element.ExampleScenario.process.step Extends HS.FHIR.DTL.vR4.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// ExampleScenario:process
/// <p>
/// Nested process.
Property process As list Of HS.FHIR.DTL.vR4.Model.Element.ExampleScenario.process(XMLNAME = "process", XMLPROJECTION = "ELEMENT");

/// boolean
/// <p>
/// If there is a pause in the flow.
Property pause As %Boolean(XMLNAME = "pause", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Each interaction or action.
Property operation As HS.FHIR.DTL.vR4.Model.Element.ExampleScenario.process.step.operation(XMLNAME = "operation", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Alternate non-typical step action.
Property alternative As list Of HS.FHIR.DTL.vR4.Model.Element.ExampleScenario.process.step.alternative(XMLNAME = "alternative", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ExampleScenario.process.step";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ExampleScenario.process.step";

}
