/// Added items details.
Class HS.FHIR.DTL.vSTU3.Model.Element.ExplanationOfBenefit.addItem.detail Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// Revenue or cost center code.
/// <p>
/// ex-revenue-center is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend ex-revenue-center and you may NOT use codes from other ValueSets.
Property revenue As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "revenue", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Type of service or product.
/// <p>
/// benefit-subcategory is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend benefit-subcategory and you may NOT use codes from other ValueSets.
Property category As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "category", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Billing Code.
/// <p>
/// service-uscls is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend service-uscls and you may NOT use codes from other ValueSets.
Property service As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "service", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Service/Product billing modifiers.
/// <p>
/// claim-modifiers is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend claim-modifiers and you may NOT use codes from other ValueSets.
Property modifier As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "modifier", XMLPROJECTION = "ELEMENT");

/// Money
/// <p>
/// Professional fee or Product charge.
Property fee As HS.FHIR.DTL.vSTU3.Model.Datatype.Money(XMLNAME = "fee", XMLPROJECTION = "ELEMENT");

/// positiveInt
/// <p>
/// List of note numbers which apply.
Property noteNumber As list Of %Integer(XMLNAME = "noteNumber", XMLPROJECTION = "ELEMENT");

/// ExplanationOfBenefit:item[n].adjudication
/// <p>
/// Added items detail adjudication.
Property adjudication As list Of HS.FHIR.DTL.vSTU3.Model.Element.ExplanationOfBenefit.item.adjudication(XMLNAME = "adjudication", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ExplanationOfBenefit.addItem.detail";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ExplanationOfBenefit.addItem.detail";

}
