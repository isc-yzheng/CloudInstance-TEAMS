/// Enteral formula components.
Class HS.FHIR.DTL.vSTU3.Model.Element.NutritionOrder.enteralFormula Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// Type of enteral or infant formula.
/// <p>
/// any FHIR3 code may be used; 
/// entformula-type shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property baseFormulaType As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "baseFormulaType", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Product or brand name of the enteral or infant formula.
Property baseFormulaProductName As %String(MAXLEN = 1000000, XMLNAME = "baseFormulaProductName", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Type of modular component to add to the feeding.
/// <p>
/// any FHIR3 code may be used; 
/// entformula-additive shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property additiveType As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "additiveType", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Product or brand name of the modular additive.
Property additiveProductName As %String(MAXLEN = 1000000, XMLNAME = "additiveProductName", XMLPROJECTION = "ATTRIBUTE");

/// SimpleQuantity
/// <p>
/// Amount of energy per specified volume that is required.
Property caloricDensity As HS.FHIR.DTL.vSTU3.Model.Datatype.SimpleQuantity(XMLNAME = "caloricDensity", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// How the formula should enter the patient's gastrointestinal tract.
/// <p>
/// enteral-route is the REQUIRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in enteral-route, 
/// you may formally EXTEND enteral-route to add codes to it.
Property routeofAdministration As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "routeofAdministration", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Formula feeding instruction as structured data.
Property administration As list Of HS.FHIR.DTL.vSTU3.Model.Element.NutritionOrder.enteralFormula.administration(XMLNAME = "administration", XMLPROJECTION = "ELEMENT");

/// SimpleQuantity
/// <p>
/// Upper limit on formula volume per unit of time.
Property maxVolumeToDeliver As HS.FHIR.DTL.vSTU3.Model.Datatype.SimpleQuantity(XMLNAME = "maxVolumeToDeliver", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Formula feeding instructions expressed as text.
Property administrationInstruction As %String(MAXLEN = 1000000, XMLNAME = "administrationInstruction", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "NutritionOrder.enteralFormula";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "NutritionOrder.enteralFormula";

}
