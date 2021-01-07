/// *** <b>THIS CLASS IS DEPRECATED.</b> Please use HS.FHIR.<b>vDSTU2.</b>Model.Resource.NutritionOrder.Administration when working with FHIR DSTU2.
Class HS.FHIR.Model.Resource.NutritionOrder.Administration Extends HS.FHIR.Model.Base.BackboneElement [ Deprecated, ProcedureBlock ]
{

///  
Parameter JSONTYPEFIELD;

///  
Parameter ELEMENTQUALIFIED = 1;

///  
Parameter XMLNAME = "NutritionOrder.Administration";

///  
Parameter XMLSEQUENCE = 0;

///  
Parameter XMLTYPE = "NutritionOrder.Administration";

///  
Property schedule As HS.FHIR.Model.Base.Timing(XMLNAME = "schedule");

///  
Property quantity As HS.FHIR.Model.Base.SimpleQuantity(XMLNAME = "quantity");

///  
Property rateQuantity As HS.FHIR.Model.Base.SimpleQuantity(XMLNAME = "rateQuantity");

///  
Property rateRatio As HS.FHIR.Model.Base.Ratio(XMLNAME = "rateRatio");

}
