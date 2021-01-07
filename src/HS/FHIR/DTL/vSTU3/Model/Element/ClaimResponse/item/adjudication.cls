/// Adjudication details.
Class HS.FHIR.DTL.vSTU3.Model.Element.ClaimResponse.item.adjudication Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// Adjudication category such as co-pay, 
/// eligible, 
/// benefit, 
/// etc.
/// <p>
/// any FHIR3 code may be used; 
/// adjudication shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property category As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "category", XMLPROJECTION = "ELEMENT") [ Required ];

/// CodeableConcept
/// <p>
/// Explanation of Adjudication outcome.
/// <p>
/// any FHIR3 code may be used; 
/// adjudication-reason shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property reason As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "reason", XMLPROJECTION = "ELEMENT");

/// Money
/// <p>
/// Monetary amount.
Property amount As HS.FHIR.DTL.vSTU3.Model.Datatype.Money(XMLNAME = "amount", XMLPROJECTION = "ELEMENT");

/// decimal
/// <p>
/// Non-monetary value.
Property value As %Decimal(XMLNAME = "value", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ClaimResponse.item.adjudication";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ClaimResponse.item.adjudication";

}
