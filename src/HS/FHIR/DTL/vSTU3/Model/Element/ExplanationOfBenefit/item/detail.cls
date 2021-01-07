/// Additional items.
Class HS.FHIR.DTL.vSTU3.Model.Element.ExplanationOfBenefit.item.detail Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// positiveInt
/// <p>
/// Service instance.
Property sequence As %Integer(XMLNAME = "sequence", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// CodeableConcept
/// <p>
/// Group or type of product or service.
/// <p>
/// v3-ActCode is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend v3-ActCode and you may NOT use codes from other ValueSets.
Property type As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT") [ Required ];

/// CodeableConcept
/// <p>
/// Revenue or cost center code.
/// <p>
/// any FHIR3 code may be used; 
/// ex-revenue-center shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property revenue As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "revenue", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Type of service or product.
/// <p>
/// any FHIR3 code may be used; 
/// benefit-subcategory shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property category As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "category", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Billing Code.
/// <p>
/// any FHIR3 code may be used; 
/// service-uscls shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property service As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "service", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Service/Product billing modifiers.
/// <p>
/// any FHIR3 code may be used; 
/// claim-modifiers shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property modifier As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "modifier", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Program specific reason for item inclusion.
/// <p>
/// any FHIR3 code may be used; 
/// ex-program-code shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property programCode As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "programCode", XMLPROJECTION = "ELEMENT");

/// SimpleQuantity
/// <p>
/// Count of Products or Services.
Property quantity As HS.FHIR.DTL.vSTU3.Model.Datatype.SimpleQuantity(XMLNAME = "quantity", XMLPROJECTION = "ELEMENT");

/// Money
/// <p>
/// Fee, 
/// charge or cost per point.
Property unitPrice As HS.FHIR.DTL.vSTU3.Model.Datatype.Money(XMLNAME = "unitPrice", XMLPROJECTION = "ELEMENT");

/// decimal
/// <p>
/// Price scaling factor.
Property factor As %Decimal(XMLNAME = "factor", XMLPROJECTION = "ATTRIBUTE");

/// Money
/// <p>
/// Total additional item cost.
Property net As HS.FHIR.DTL.vSTU3.Model.Datatype.Money(XMLNAME = "net", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Unique Device Identifier.
/// <p>
/// Device
Property udi As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "udi", XMLPROJECTION = "ELEMENT");

/// positiveInt
/// <p>
/// List of note numbers which apply.
Property noteNumber As list Of %Integer(XMLNAME = "noteNumber", XMLPROJECTION = "ELEMENT");

/// ExplanationOfBenefit:item[n].adjudication
/// <p>
/// Detail level adjudication details.
Property adjudication As list Of HS.FHIR.DTL.vSTU3.Model.Element.ExplanationOfBenefit.item.adjudication(XMLNAME = "adjudication", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Additional items.
Property subDetail As list Of HS.FHIR.DTL.vSTU3.Model.Element.ExplanationOfBenefit.item.detail.subDetail(XMLNAME = "subDetail", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ExplanationOfBenefit.item.detail";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ExplanationOfBenefit.item.detail";

}
