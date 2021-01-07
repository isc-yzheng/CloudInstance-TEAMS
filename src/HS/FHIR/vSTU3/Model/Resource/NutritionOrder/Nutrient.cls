/// A request to supply a diet, formula feeding (enteral) or oral nutritional supplement to a patient/resident.
Class HS.FHIR.vSTU3.Model.Resource.NutritionOrder.Nutrient Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "NutritionOrder.Nutrient";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "NutritionOrder.Nutrient";

Parameter JSONTYPEFIELD;

/// The nutrient that is being modified such as carbohydrate or sodium.
Property modifier As HS.FHIR.vSTU3.Model.Base.CodeableConcept(XMLNAME = "modifier", XMLPROJECTION = "ELEMENT");

/// The quantity of the specified nutrient to include in diet.
Property amount As HS.FHIR.vSTU3.Model.Base.Quantity(XMLNAME = "amount", XMLPROJECTION = "ELEMENT");

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

/// Set method for the "amount" property.
Method SetAmount(pValue As %String = "", pComparator As %String = "", pUnit As %String = "", pSystem As %String = "", pCode As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Quantity).%New(pValue, pComparator, pUnit, pSystem, pCode, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Quantity object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..amount = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
