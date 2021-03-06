/// Target outcome for the goal.
Class HS.FHIR.DTL.vSTU3.Model.Element.Goal.target Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// The parameter whose value is being tracked.
/// <p>
/// any FHIR3 code may be used; 
/// observation-codes shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property measure As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "measure", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// The target value to be achieved.
/// <p>
/// any FHIR3 code from any ValueSet may be used.
Property detailCodeableConcept As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "detailCodeableConcept", XMLPROJECTION = "ELEMENT");

/// Quantity
/// <p>
/// The target value to be achieved.
Property detailQuantity As HS.FHIR.DTL.vSTU3.Model.Datatype.Quantity(XMLNAME = "detailQuantity", XMLPROJECTION = "ELEMENT");

/// Range
/// <p>
/// The target value to be achieved.
Property detailRange As HS.FHIR.DTL.vSTU3.Model.Datatype.Range(XMLNAME = "detailRange", XMLPROJECTION = "ELEMENT");

/// date
/// <p>
/// Reach goal on or before.
Property dueDate As %String(MAXLEN = 1000000, XMLNAME = "dueDate", XMLPROJECTION = "ATTRIBUTE");

/// Duration
/// <p>
/// Reach goal on or before.
Property dueDuration As HS.FHIR.DTL.vSTU3.Model.Datatype.Duration(XMLNAME = "dueDuration", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Goal.target";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Goal.target";

}
