/// Goods and Services.
Class HS.FHIR.DTL.vDSTU2.Model.Element.Claim.item Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// positiveInt
/// <p>
/// Service instance.
Property sequence As %Integer(XMLNAME = "sequence", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Coding
/// <p>
/// Group or type of product or service.
/// <p>
/// v3-ActInvoiceGroupCode is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend v3-ActInvoiceGroupCode and you may NOT use codes from other ValueSets.
Property type As HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "type", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Responsible practitioner.
/// <p>
/// Practitioner
Property provider As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "provider", XMLPROJECTION = "ELEMENT");

/// positiveInt
/// <p>
/// Diagnosis Link.
Property diagnosisLinkId As list Of %Integer(XMLNAME = "diagnosisLinkId", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// Item Code.
/// <p>
/// any FHIR2 code may be used; 
/// service-uscls shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property service As HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "service", XMLPROJECTION = "ELEMENT") [ Required ];

/// date
/// <p>
/// Date of Service.
Property serviceDate As %String(MAXLEN = 1000000, XMLNAME = "serviceDate", XMLPROJECTION = "ATTRIBUTE");

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
/// Total item cost.
Property net As HS.FHIR.DTL.vDSTU2.Model.Datatype.Money(XMLNAME = "net", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// Unique Device Identifier.
/// <p>
/// any FHIR2 code may be used; 
/// udi shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property udi As HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "udi", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// Service Location.
/// <p>
/// any FHIR2 code may be used; 
/// tooth shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property bodySite As HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "bodySite", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// Service Sub-location.
/// <p>
/// any FHIR2 code may be used; 
/// surface shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property subSite As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "subSite", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// Service/Product billing modifiers.
/// <p>
/// any FHIR2 code may be used; 
/// claim-modifiers shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property modifier As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "modifier", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Additional items.
Property detail As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Claim.item.detail(XMLNAME = "detail", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Prosthetic details.
Property prosthesis As HS.FHIR.DTL.vDSTU2.Model.Element.Claim.item.prosthesis(XMLNAME = "prosthesis", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Claim.item";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Claim.item";

}
