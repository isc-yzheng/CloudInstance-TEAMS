/// A request to supply a diet, formula feeding (enteral) or oral nutritional supplement to a patient/resident.
Class HS.FHIR.vSTU3.Model.Resource.NutritionOrder.Texture Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "NutritionOrder.Texture";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "NutritionOrder.Texture";

Parameter JSONTYPEFIELD;

/// Any texture modifications (for solid foods) that should be made, e.g. easy to chew, chopped, ground, and pureed.
Property modifier As HS.FHIR.vSTU3.Model.Base.CodeableConcept(XMLNAME = "modifier", XMLPROJECTION = "ELEMENT");

/// The food type(s) (e.g. meats, all foods)  that the texture modification applies to.  This could be all foods types.
Property foodType As HS.FHIR.vSTU3.Model.Base.CodeableConcept(XMLNAME = "foodType", XMLPROJECTION = "ELEMENT");

/// Set method for the "modifier" property.
Method SetModifier(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed"_$Select(err="":"",1:" - "_err)) Quit
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
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..foodType = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
