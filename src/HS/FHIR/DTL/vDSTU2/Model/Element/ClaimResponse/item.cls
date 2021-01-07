/// Line items.
Class HS.FHIR.DTL.vDSTU2.Model.Element.ClaimResponse.item Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// positiveInt
/// <p>
/// Service instance.
Property sequenceLinkId As %Integer(XMLNAME = "sequenceLinkId", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// positiveInt
/// <p>
/// List of note numbers which apply.
Property noteNumber As list Of %Integer(XMLNAME = "noteNumber", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Adjudication details.
Property adjudication As list Of HS.FHIR.DTL.vDSTU2.Model.Element.ClaimResponse.item.adjudication(XMLNAME = "adjudication", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Detail line items.
Property detail As list Of HS.FHIR.DTL.vDSTU2.Model.Element.ClaimResponse.item.detail(XMLNAME = "detail", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ClaimResponse.item";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ClaimResponse.item";

}
