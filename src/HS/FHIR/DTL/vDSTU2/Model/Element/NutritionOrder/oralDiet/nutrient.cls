/// Required  nutrient modifications.
Class HS.FHIR.DTL.vDSTU2.Model.Element.NutritionOrder.oralDiet.nutrient Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// Type of nutrient that is being modified.
/// <p>
/// any FHIR2 code may be used; 
/// nutrient-code shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property modifier As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "modifier", XMLPROJECTION = "ELEMENT");

/// SimpleQuantity
/// <p>
/// Quantity of the specified nutrient.
Property amount As HS.FHIR.DTL.vDSTU2.Model.Datatype.SimpleQuantity(XMLNAME = "amount", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "NutritionOrder.oralDiet.nutrient";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "NutritionOrder.oralDiet.nutrient";

}
