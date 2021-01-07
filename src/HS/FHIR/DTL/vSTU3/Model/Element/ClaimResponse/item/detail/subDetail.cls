/// Subdetail line items.
Class HS.FHIR.DTL.vSTU3.Model.Element.ClaimResponse.item.detail.subDetail Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// positiveInt
/// <p>
/// Service instance.
Property sequenceLinkId As %Integer(XMLNAME = "sequenceLinkId", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// positiveInt
/// <p>
/// List of note numbers which apply.
Property noteNumber As list Of %Integer(XMLNAME = "noteNumber", XMLPROJECTION = "ELEMENT");

/// ClaimResponse:item[n].adjudication
/// <p>
/// Subdetail level adjudication details.
Property adjudication As list Of HS.FHIR.DTL.vSTU3.Model.Element.ClaimResponse.item.adjudication(XMLNAME = "adjudication", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ClaimResponse.item.detail.subDetail";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ClaimResponse.item.detail.subDetail";

}
