/// Details by insurance coverage.
Class HS.FHIR.DTL.vSTU3.Model.Element.EligibilityResponse.insurance Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Reference
/// <p>
/// Updated Coverage details.
/// <p>
/// Coverage
Property coverage As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "coverage", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Contract details.
/// <p>
/// Contract
Property contract As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "contract", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Benefits by Category.
Property benefitBalance As list Of HS.FHIR.DTL.vSTU3.Model.Element.EligibilityResponse.insurance.benefitBalance(XMLNAME = "benefitBalance", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "EligibilityResponse.insurance";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "EligibilityResponse.insurance";

}
