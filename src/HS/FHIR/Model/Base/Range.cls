/// *** <b>THIS CLASS IS DEPRECATED.</b> Please use HS.FHIR.<b>vDSTU2.</b>Model.Base.Range when working with FHIR DSTU2.
Class HS.FHIR.Model.Base.Range Extends HS.FHIR.Model.Base.Element [ Deprecated, ProcedureBlock ]
{

///  
Parameter JSONTYPEFIELD;

///  
Parameter ELEMENTQUALIFIED = 1;

///  
Parameter XMLNAME = "Range";

///  
Parameter XMLSEQUENCE = 1;

///  
Property low As HS.FHIR.Model.Base.SimpleQuantity(XMLNAME = "low");

///  
Property high As HS.FHIR.Model.Base.SimpleQuantity(XMLNAME = "high");

}
