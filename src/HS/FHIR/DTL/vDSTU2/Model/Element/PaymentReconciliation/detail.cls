/// Details.
Class HS.FHIR.DTL.vDSTU2.Model.Element.PaymentReconciliation.detail Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Coding
/// <p>
/// Type code.
/// <p>
/// any FHIR2 code may be used; 
/// payment-type shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property type As HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "type", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Claim.
/// <p>
/// Any FHIR2 Resource may be indicated by this Reference
Property request As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "request", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Claim Response.
/// <p>
/// Any FHIR2 Resource may be indicated by this Reference
Property responce As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "responce", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Submitter.
/// <p>
/// Organization
Property submitter As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "submitter", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Payee.
/// <p>
/// Organization
Property payee As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "payee", XMLPROJECTION = "ELEMENT");

/// date
/// <p>
/// Invoice date.
Property date As %String(MAXLEN = 1000000, XMLNAME = "date", XMLPROJECTION = "ATTRIBUTE");

/// Money
/// <p>
/// Detail amount.
Property amount As HS.FHIR.DTL.vDSTU2.Model.Datatype.Money(XMLNAME = "amount", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "PaymentReconciliation.detail";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "PaymentReconciliation.detail";

}
