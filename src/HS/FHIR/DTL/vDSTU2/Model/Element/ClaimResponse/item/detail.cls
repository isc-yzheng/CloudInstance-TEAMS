/// Detail line items.
Class HS.FHIR.DTL.vDSTU2.Model.Element.ClaimResponse.item.detail Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// positiveInt
/// <p>
/// Service instance.
Property sequenceLinkId As %Integer(XMLNAME = "sequenceLinkId", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// BackboneElement
/// <p>
/// Detail adjudication.
Property adjudication As list Of HS.FHIR.DTL.vDSTU2.Model.Element.ClaimResponse.item.detail.adjudication(XMLNAME = "adjudication", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Subdetail line items.
Property subDetail As list Of HS.FHIR.DTL.vDSTU2.Model.Element.ClaimResponse.item.detail.subDetail(XMLNAME = "subDetail", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ClaimResponse.item.detail";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ClaimResponse.item.detail";

}
