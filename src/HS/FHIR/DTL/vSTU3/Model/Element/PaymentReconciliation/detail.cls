/// List of settlements.
Class HS.FHIR.DTL.vSTU3.Model.Element.PaymentReconciliation.detail Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// Type code.
/// <p>
/// any FHIR3 code may be used; 
/// payment-type shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property type As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Claim.
/// <p>
/// Any FHIR3 Resource may be indicated by this Reference
Property request As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "request", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Claim Response.
/// <p>
/// Any FHIR3 Resource may be indicated by this Reference
Property response As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "response", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Organization which submitted the claim.
/// <p>
/// Organization
Property submitter As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "submitter", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Organization which is receiving the payment.
/// <p>
/// Organization
Property payee As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "payee", XMLPROJECTION = "ELEMENT");

/// date
/// <p>
/// Invoice date.
Property date As %String(MAXLEN = 1000000, XMLNAME = "date", XMLPROJECTION = "ATTRIBUTE");

/// Money
/// <p>
/// Amount being paid.
Property amount As HS.FHIR.DTL.vSTU3.Model.Datatype.Money(XMLNAME = "amount", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "PaymentReconciliation.detail";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "PaymentReconciliation.detail";

}
