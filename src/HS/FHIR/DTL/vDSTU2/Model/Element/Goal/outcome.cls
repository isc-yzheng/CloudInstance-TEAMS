/// What was end result of goal?
Class HS.FHIR.DTL.vDSTU2.Model.Element.Goal.outcome Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// Code or observation that resulted from goal.
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property resultCodeableConcept As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "resultCodeableConcept", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Code or observation that resulted from goal.
/// <p>
/// Observation.
Property resultReference As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "resultReference", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Goal.outcome";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Goal.outcome";

}
