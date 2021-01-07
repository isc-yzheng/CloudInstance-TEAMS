/// Benefits by Category.
Class HS.FHIR.DTL.vSTU3.Model.Element.EligibilityResponse.insurance.benefitBalance Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// Type of services covered.
/// <p>
/// any FHIR3 code may be used; 
/// benefit-category shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property category As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "category", XMLPROJECTION = "ELEMENT") [ Required ];

/// CodeableConcept
/// <p>
/// Detailed services covered within the type.
/// <p>
/// any FHIR3 code may be used; 
/// benefit-subcategory shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property subCategory As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "subCategory", XMLPROJECTION = "ELEMENT");

/// boolean
/// <p>
/// Excluded from the plan.
Property excluded As %Boolean(XMLNAME = "excluded", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Short name for the benefit.
Property name As %String(MAXLEN = 1000000, XMLNAME = "name", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Description of the benefit or services covered.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// In or out of network.
/// <p>
/// any FHIR3 code may be used; 
/// benefit-network shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property network As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "network", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Individual or family.
/// <p>
/// any FHIR3 code may be used; 
/// benefit-unit shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property unit As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "unit", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Annual or lifetime.
/// <p>
/// any FHIR3 code may be used; 
/// benefit-term shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property term As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "term", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Benefit Summary.
Property financial As list Of HS.FHIR.DTL.vSTU3.Model.Element.EligibilityResponse.insurance.benefitBalance.financial(XMLNAME = "financial", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "EligibilityResponse.insurance.benefitBalance";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "EligibilityResponse.insurance.benefitBalance";

}
