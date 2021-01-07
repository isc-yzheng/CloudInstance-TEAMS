/// Administrable medication details.
Class HS.FHIR.DTL.vDSTU2.Model.Element.Medication.product Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// powder | tablets | carton +
/// <p>
/// any FHIR2 code may be used; 
/// medication-form-codes shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property form As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "form", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Active or inactive ingredient.
Property ingredient As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Medication.product.ingredient(XMLNAME = "ingredient", XMLPROJECTION = "ELEMENT");

/// BackboneElement
Property batch As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Medication.product.batch(XMLNAME = "batch", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Medication.product";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Medication.product";

}
