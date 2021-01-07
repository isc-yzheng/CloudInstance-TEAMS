Class HS.FHIR.vDSTU2.Model.Resource.NutritionOrder.EnteralFormula Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "NutritionOrder.EnteralFormula";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "NutritionOrder.EnteralFormula";

/// The type of enteral or infant formula such as an adult standard formula with fiber or a soy-based infant formula.
Property baseFormulaType As HS.FHIR.vDSTU2.Model.Base.CodeableConcept(XMLNAME = "baseFormulaType");

/// The product or brand name of the enteral or infant formula product such as"ACME Adult Standard Formula".
Property baseFormulaProductName As HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "baseFormulaProductName");

/// Indicates the type of modular component such as protein, carbohydrate, fat or fiber to be provided in addition to or mixed with the base formula.
Property additiveType As HS.FHIR.vDSTU2.Model.Base.CodeableConcept(XMLNAME = "additiveType");

/// The product or brand name of the type of modular component to be added to the formula.
Property additiveProductName As HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "additiveProductName");

/// The amount of energy (Calories) that the formula should provide per specified volume, typically per mL or fluid oz.  For example, an infant may require a formula that provides 24 Calories per fluid ounce or an adult may require an enteral formula that provides 1.5 Calorie/mL.
Property caloricDensity As HS.FHIR.vDSTU2.Model.Base.SimpleQuantity(XMLNAME = "caloricDensity");

/// The route or physiological path of administration into the patient's gastrointestinal  tract for purposes of providing the formula feeding, e.g. nasogastric tube.
Property routeofAdministration As HS.FHIR.vDSTU2.Model.Base.CodeableConcept(XMLNAME = "routeofAdministration");

/// Formula administration instructions as structured data.  This repeating structure allows for changing the administration rate or volume over time for both bolus and continuous feeding.  An example of this would be an instruction to increase the rate of continuous feeding every 2 hours.
Property administration As list Of HS.FHIR.vDSTU2.Model.Resource.NutritionOrder.Administration(XMLNAME = "administration", XMLPROJECTION = "ELEMENT");

/// The maximum total quantity of formula that may be administered to a subject over the period of time, e.g. 1440 mL over 24 hours.
Property maxVolumeToDeliver As HS.FHIR.vDSTU2.Model.Base.SimpleQuantity(XMLNAME = "maxVolumeToDeliver");

/// Free text formula administration, feeding instructions or additional instructions or information.
Property administrationInstruction As HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "administrationInstruction");

/// Set method for the "baseFormulaType" property.
Method SetBaseFormulaType(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed") Quit
		Set ..baseFormulaType = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "baseFormulaProductName" property.
Method SetBaseFormulaProductName(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set ..baseFormulaProductName = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "additiveType" property.
Method SetAdditiveType(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed") Quit
		Set ..additiveType = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "additiveProductName" property.
Method SetAdditiveProductName(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set ..additiveProductName = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "routeofAdministration" property.
Method SetRouteofAdministration(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed") Quit
		Set ..routeofAdministration = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "administrationInstruction" property.
Method SetAdministrationInstruction(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set ..administrationInstruction = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
