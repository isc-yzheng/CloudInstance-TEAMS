/// Additional items.
Class HS.FHIR.DTL.vDSTU2.Model.Element.Claim.item.detail.subDetail Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// positiveInt
/// <p>
/// Service instance.
Property sequence As %Integer(XMLNAME = "sequence", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Coding
/// <p>
/// Type of product or service.
/// <p>
/// v3-ActInvoiceGroupCode is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend v3-ActInvoiceGroupCode and you may NOT use codes from other ValueSets.
Property type As HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "type", XMLPROJECTION = "ELEMENT") [ Required ];

/// Coding
/// <p>
/// Additional item codes.
/// <p>
/// any FHIR2 code may be used; 
/// service-uscls shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property service As HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "service", XMLPROJECTION = "ELEMENT") [ Required ];

/// SimpleQuantity
/// <p>
/// Count of Products or Services.
Property quantity As HS.FHIR.DTL.vDSTU2.Model.Datatype.SimpleQuantity(XMLNAME = "quantity", XMLPROJECTION = "ELEMENT");

/// Money
/// <p>
/// Fee, 
/// charge or cost per point.
Property unitPrice As HS.FHIR.DTL.vDSTU2.Model.Datatype.Money(XMLNAME = "unitPrice", XMLPROJECTION = "ELEMENT");

/// decimal
/// <p>
/// Price scaling factor.
Property factor As %Decimal(XMLNAME = "factor", XMLPROJECTION = "ATTRIBUTE");

/// decimal
/// <p>
/// Difficulty scaling factor.
Property points As %Decimal(XMLNAME = "points", XMLPROJECTION = "ATTRIBUTE");

/// Money
/// <p>
/// Net additional item cost.
Property net As HS.FHIR.DTL.vDSTU2.Model.Datatype.Money(XMLNAME = "net", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// Unique Device Identifier.
/// <p>
/// any FHIR2 code may be used; 
/// udi shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property udi As HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "udi", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Claim.item.detail.subDetail";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Claim.item.detail.subDetail";

}
