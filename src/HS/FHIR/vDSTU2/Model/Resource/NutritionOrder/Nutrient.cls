Class HS.FHIR.vDSTU2.Model.Resource.NutritionOrder.Nutrient Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "NutritionOrder.Nutrient";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "NutritionOrder.Nutrient";

/// The nutrient that is being modified such as carbohydrate or sodium.
Property modifier As HS.FHIR.vDSTU2.Model.Base.CodeableConcept(XMLNAME = "modifier");

/// The quantity of the specified nutrient to include in diet.
Property amount As HS.FHIR.vDSTU2.Model.Base.SimpleQuantity(XMLNAME = "amount");

/// Set method for the "modifier" property.
Method SetModifier(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed") Quit
		Set ..modifier = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
