/// Insurance or medical plan.
Class HS.FHIR.DTL.vSTU3.Model.Element.ExplanationOfBenefit.insurance Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Reference
/// <p>
/// Insurance information.
/// <p>
/// Coverage
Property coverage As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "coverage", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Pre-Authorization/Determination Reference.
Property preAuthRef As list Of %String(MAXLEN = 1000000, XMLNAME = "preAuthRef", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ExplanationOfBenefit.insurance";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ExplanationOfBenefit.insurance";

}
