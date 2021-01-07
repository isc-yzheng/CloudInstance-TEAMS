/// Goods and Services.
Class HS.FHIR.DTL.vSTU3.Model.Element.ExplanationOfBenefit.item Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// positiveInt
/// <p>
/// Service instance.
Property sequence As %Integer(XMLNAME = "sequence", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// positiveInt
/// <p>
/// Applicable careteam members.
Property careTeamLinkId As list Of %Integer(XMLNAME = "careTeamLinkId", XMLPROJECTION = "ELEMENT");

/// positiveInt
/// <p>
/// Applicable diagnoses.
Property diagnosisLinkId As list Of %Integer(XMLNAME = "diagnosisLinkId", XMLPROJECTION = "ELEMENT");

/// positiveInt
/// <p>
/// Applicable procedures.
Property procedureLinkId As list Of %Integer(XMLNAME = "procedureLinkId", XMLPROJECTION = "ELEMENT");

/// positiveInt
/// <p>
/// Applicable exception and supporting information.
Property informationLinkId As list Of %Integer(XMLNAME = "informationLinkId", XMLPROJECTION = "ELEMENT");

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

/// date
/// <p>
///  Date or dates of Service.
Property servicedDate As %String(MAXLEN = 1000000, XMLNAME = "servicedDate", XMLPROJECTION = "ATTRIBUTE");

/// Period
/// <p>
///  Date or dates of Service.
Property servicedPeriod As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "servicedPeriod", XMLPROJECTION = "ELEMENT");

/// Address
/// <p>
///  Place of service.
Property locationAddress As HS.FHIR.DTL.vSTU3.Model.Datatype.Address(XMLNAME = "locationAddress", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
///  Place of service.
/// <p>
/// any FHIR3 code may be used; 
/// service-place shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property locationCodeableConcept As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "locationCodeableConcept", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
///  Place of service.
/// <p>
/// Location.
Property locationReference As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "locationReference", XMLPROJECTION = "ELEMENT");

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
/// Total item cost.
Property net As HS.FHIR.DTL.vSTU3.Model.Datatype.Money(XMLNAME = "net", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Unique Device Identifier.
/// <p>
/// Device
Property udi As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "udi", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Service Location.
/// <p>
/// any FHIR3 code may be used; 
/// tooth shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property bodySite As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "bodySite", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Service Sub-location.
/// <p>
/// any FHIR3 code may be used; 
/// surface shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property subSite As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "subSite", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Encounters related to this billed item.
/// <p>
/// Encounter
Property encounter As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "encounter", XMLPROJECTION = "ELEMENT");

/// positiveInt
/// <p>
/// List of note numbers which apply.
Property noteNumber As list Of %Integer(XMLNAME = "noteNumber", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Adjudication details.
Property adjudication As list Of HS.FHIR.DTL.vSTU3.Model.Element.ExplanationOfBenefit.item.adjudication(XMLNAME = "adjudication", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Additional items.
Property detail As list Of HS.FHIR.DTL.vSTU3.Model.Element.ExplanationOfBenefit.item.detail(XMLNAME = "detail", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ExplanationOfBenefit.item";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ExplanationOfBenefit.item";

}
