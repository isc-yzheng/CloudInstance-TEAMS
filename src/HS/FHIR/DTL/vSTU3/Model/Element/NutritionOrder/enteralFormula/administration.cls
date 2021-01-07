/// Formula feeding instruction as structured data.
Class HS.FHIR.DTL.vSTU3.Model.Element.NutritionOrder.enteralFormula.administration Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Timing
/// <p>
/// Scheduled frequency of enteral feeding.
Property schedule As HS.FHIR.DTL.vSTU3.Model.Datatype.Timing(XMLNAME = "schedule", XMLPROJECTION = "ELEMENT");

/// SimpleQuantity
/// <p>
/// The volume of formula to provide.
Property quantity As HS.FHIR.DTL.vSTU3.Model.Datatype.SimpleQuantity(XMLNAME = "quantity", XMLPROJECTION = "ELEMENT");

/// SimpleQuantity
/// <p>
/// Speed with which the formula is provided per period of time. 
/// 
Property rateQuantity As HS.FHIR.DTL.vSTU3.Model.Datatype.SimpleQuantity(XMLNAME = "rateQuantity", XMLPROJECTION = "ELEMENT");

/// Ratio
/// <p>
/// Speed with which the formula is provided per period of time. 
/// 
Property rateRatio As HS.FHIR.DTL.vSTU3.Model.Datatype.Ratio(XMLNAME = "rateRatio", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "NutritionOrder.enteralFormula.administration";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "NutritionOrder.enteralFormula.administration";

}
