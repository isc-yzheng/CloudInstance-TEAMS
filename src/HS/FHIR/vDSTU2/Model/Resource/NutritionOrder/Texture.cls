Class HS.FHIR.vDSTU2.Model.Resource.NutritionOrder.Texture Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "NutritionOrder.Texture";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "NutritionOrder.Texture";

/// Any texture modifications (for solid foods) that should be made, e.g. easy to chew, chopped, ground, and pureed.
Property modifier As HS.FHIR.vDSTU2.Model.Base.CodeableConcept(XMLNAME = "modifier");

/// The food type(s) (e.g. meats, all foods)  that the texture modification applies to.  This could be all foods types.
Property foodType As HS.FHIR.vDSTU2.Model.Base.CodeableConcept(XMLNAME = "foodType");

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

/// Set method for the "foodType" property.
Method SetFoodType(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed") Quit
		Set ..foodType = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
