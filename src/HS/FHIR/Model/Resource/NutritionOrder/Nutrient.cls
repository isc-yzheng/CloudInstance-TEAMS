/// *** <b>THIS CLASS IS DEPRECATED.</b> Please use HS.FHIR.<b>vDSTU2.</b>Model.Resource.NutritionOrder.Nutrient when working with FHIR DSTU2.
Class HS.FHIR.Model.Resource.NutritionOrder.Nutrient Extends HS.FHIR.Model.Base.BackboneElement [ Deprecated, ProcedureBlock ]
{

///  
Parameter JSONTYPEFIELD;

///  
Parameter ELEMENTQUALIFIED = 1;

///  
Parameter XMLNAME = "NutritionOrder.Nutrient";

///  
Parameter XMLSEQUENCE = 1;

///  
Parameter XMLTYPE = "NutritionOrder.Nutrient";

///  
Property modifier As HS.FHIR.Model.Base.CodeableConcept(XMLNAME = "modifier");

///  
Property amount As HS.FHIR.Model.Base.SimpleQuantity(XMLNAME = "amount");

///  
Method SetModifier(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed") Quit
		Set ..modifier = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
