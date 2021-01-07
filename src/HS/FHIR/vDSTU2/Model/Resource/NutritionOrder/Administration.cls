Class HS.FHIR.vDSTU2.Model.Resource.NutritionOrder.Administration Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "NutritionOrder.Administration";

Parameter XMLSEQUENCE = 0;

Parameter XMLTYPE = "NutritionOrder.Administration";

/// The time period and frequency at which the enteral formula should be delivered to the patient.
Property schedule As HS.FHIR.vDSTU2.Model.Base.Timing(XMLNAME = "schedule");

/// The volume of formula to provide to the patient per the specified administration schedule.
Property quantity As HS.FHIR.vDSTU2.Model.Base.SimpleQuantity(XMLNAME = "quantity");

Property rateQuantity As HS.FHIR.vDSTU2.Model.Base.SimpleQuantity(XMLNAME = "rateQuantity");

Property rateRatio As HS.FHIR.vDSTU2.Model.Base.Ratio(XMLNAME = "rateRatio");

}
