/// Stratifier criteria for the measure.
Class HS.FHIR.DTL.vR4.Model.Element.Measure.group.stratifier Extends HS.FHIR.DTL.vR4.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// Meaning of the stratifier.
/// <p>
/// any FHIR4 code from any ValueSet may be used.
Property code As HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "code", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// The human readable description of this stratifier.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

/// Expression
/// <p>
/// How the measure should be stratified.
Property criteria As HS.FHIR.DTL.vR4.Model.Datatype.Expression(XMLNAME = "criteria", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Stratifier criteria component for the measure.
Property component As list Of HS.FHIR.DTL.vR4.Model.Element.Measure.group.stratifier.component(XMLNAME = "component", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Measure.group.stratifier";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Measure.group.stratifier";

}
