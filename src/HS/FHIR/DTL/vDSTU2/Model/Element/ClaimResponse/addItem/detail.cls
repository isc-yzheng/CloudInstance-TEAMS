/// Added items details.
Class HS.FHIR.DTL.vDSTU2.Model.Element.ClaimResponse.addItem.detail Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Coding
/// <p>
/// Service or Product.
/// <p>
/// any FHIR2 code may be used; 
/// service-uscls shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property service As HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "service", XMLPROJECTION = "ELEMENT") [ Required ];

/// Money
/// <p>
/// Professional fee or Product charge.
Property fee As HS.FHIR.DTL.vDSTU2.Model.Datatype.Money(XMLNAME = "fee", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Added items detail adjudication.
Property adjudication As list Of HS.FHIR.DTL.vDSTU2.Model.Element.ClaimResponse.addItem.detail.adjudication(XMLNAME = "adjudication", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ClaimResponse.addItem.detail";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ClaimResponse.addItem.detail";

}
