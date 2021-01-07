/// Insurer added line items.
Class HS.FHIR.DTL.vDSTU2.Model.Element.ClaimResponse.addItem Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// positiveInt
/// <p>
/// Service instances.
Property sequenceLinkId As list Of %Integer(XMLNAME = "sequenceLinkId", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// Group, 
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

/// positiveInt
/// <p>
/// List of note numbers which apply.
Property noteNumberLinkId As list Of %Integer(XMLNAME = "noteNumberLinkId", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Added items adjudication.
Property adjudication As list Of HS.FHIR.DTL.vDSTU2.Model.Element.ClaimResponse.addItem.adjudication(XMLNAME = "adjudication", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Added items details.
Property detail As list Of HS.FHIR.DTL.vDSTU2.Model.Element.ClaimResponse.addItem.detail(XMLNAME = "detail", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ClaimResponse.addItem";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ClaimResponse.addItem";

}
