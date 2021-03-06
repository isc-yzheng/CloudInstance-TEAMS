/// Added items detail adjudication.
Class HS.FHIR.DTL.vDSTU2.Model.Element.ClaimResponse.addItem.detail.adjudication Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Coding
/// <p>
/// Adjudication category such as co-pay, 
/// eligible, 
/// benefit, 
/// etc.
/// <p>
/// adjudication is the REQUIRED FHIR2 ValueSet for codes, 
/// but if you need to express meanings not found in adjudication, 
/// you may formally EXTEND adjudication to add codes to it.
Property code As HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "code", XMLPROJECTION = "ELEMENT") [ Required ];

/// Quantity
/// <p>
/// Monetary amount.
Property amount As HS.FHIR.DTL.vDSTU2.Model.Datatype.Quantity(XMLNAME = "amount", XMLPROJECTION = "ELEMENT");

/// decimal
/// <p>
/// Non-monetary value.
Property value As %Decimal(XMLNAME = "value", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ClaimResponse.addItem.detail.adjudication";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ClaimResponse.addItem.detail.adjudication";

}
