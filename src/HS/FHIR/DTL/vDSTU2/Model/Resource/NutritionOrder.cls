/// A request for a diet, 
/// formula or nutritional supplement.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.NutritionOrder Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Reference
/// <p>
/// The person who requires the diet, 
/// formula or nutritional supplement.
/// <p>
/// Patient
Property patient As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "patient", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Who ordered the diet, 
/// formula or nutritional supplement.
/// <p>
/// Practitioner
Property orderer As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "orderer", XMLPROJECTION = "ELEMENT");

/// Identifier
/// <p>
/// Identifiers assigned to this order.
Property identifier As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// The encounter associated with this nutrition order.
/// <p>
/// Encounter
Property encounter As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "encounter", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// Date and time the nutrition order was requested.
Property dateTime As %String(MAXLEN = 1000000, XMLNAME = "dateTime", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// code
/// <p>
/// proposed | draft | planned | requested | active | on-hold | completed | cancelled
/// <p>
/// nutrition-order-status is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend nutrition-order-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// List of the patient's food and nutrition-related allergies and intolerances.
/// <p>
/// AllergyIntolerance
Property allergyIntolerance As list Of HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "allergyIntolerance", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Order-specific modifier about the type of food that should be given.
/// <p>
/// any FHIR2 code may be used; 
/// encounter-diet shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property foodPreferenceModifier As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "foodPreferenceModifier", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Order-specific modifier about the type of food that should not be given.
/// <p>
/// any FHIR2 code may be used; 
/// food-type shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property excludeFoodModifier As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "excludeFoodModifier", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Oral diet components.
Property oralDiet As HS.FHIR.DTL.vDSTU2.Model.Element.NutritionOrder.oralDiet(XMLNAME = "oralDiet", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Supplement components.
Property supplement As list Of HS.FHIR.DTL.vDSTU2.Model.Element.NutritionOrder.supplement(XMLNAME = "supplement", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Enteral formula components.
Property enteralFormula As HS.FHIR.DTL.vDSTU2.Model.Element.NutritionOrder.enteralFormula(XMLNAME = "enteralFormula", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "NutritionOrder";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "NutritionOrder";

}
