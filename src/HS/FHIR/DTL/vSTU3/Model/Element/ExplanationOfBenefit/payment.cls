/// Payment (if paid)
Class HS.FHIR.DTL.vSTU3.Model.Element.ExplanationOfBenefit.payment Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// Partial or Complete.
/// <p>
/// any FHIR3 code may be used; 
/// ex-paymenttype shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property type As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

/// Money
/// <p>
/// Payment adjustment for non-Claim issues.
Property adjustment As HS.FHIR.DTL.vSTU3.Model.Datatype.Money(XMLNAME = "adjustment", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Explanation for the non-claim adjustment.
/// <p>
/// any FHIR3 code may be used; 
/// payment-adjustment-reason shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property adjustmentReason As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "adjustmentReason", XMLPROJECTION = "ELEMENT");

/// date
/// <p>
/// Expected date of Payment.
Property date As %String(MAXLEN = 1000000, XMLNAME = "date", XMLPROJECTION = "ATTRIBUTE");

/// Money
/// <p>
/// Payable amount after adjustment.
Property amount As HS.FHIR.DTL.vSTU3.Model.Datatype.Money(XMLNAME = "amount", XMLPROJECTION = "ELEMENT");

/// Identifier
/// <p>
/// Identifier of the payment instrument.
Property identifier As HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ExplanationOfBenefit.payment";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ExplanationOfBenefit.payment";

}
