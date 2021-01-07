Class HS.FHIR.vDSTU2.Model.Resource.NutritionOrder.OralDiet Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "NutritionOrder.OralDiet";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "NutritionOrder.OralDiet";

/// The kind of diet or dietary restriction such as fiber restricted diet or diabetic diet.
Property type As list Of HS.FHIR.vDSTU2.Model.Base.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

/// The time period and frequency at which the diet should be given.
Property schedule As list Of HS.FHIR.vDSTU2.Model.Base.Timing(XMLNAME = "schedule", XMLPROJECTION = "ELEMENT");

/// Class that defines the quantity and type of nutrient modifications required for the oral diet.
Property nutrient As list Of HS.FHIR.vDSTU2.Model.Resource.NutritionOrder.Nutrient(XMLNAME = "nutrient", XMLPROJECTION = "ELEMENT");

/// Class that describes any texture modifications required for the patient to safely consume various types of solid foods.
Property texture As list Of HS.FHIR.vDSTU2.Model.Resource.NutritionOrder.Texture(XMLNAME = "texture", XMLPROJECTION = "ELEMENT");

/// The required consistency (e.g. honey-thick, nectar-thick, thin, thickened.) of liquids or fluids served to the patient.
Property fluidConsistencyType As list Of HS.FHIR.vDSTU2.Model.Base.CodeableConcept(XMLNAME = "fluidConsistencyType", XMLPROJECTION = "ELEMENT");

/// Free text or additional instructions or information pertaining to the oral diet.
Property instruction As HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "instruction");

/// Insert method for the "type" property.
Method SetType(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed") Quit
		Set tSC = ..type.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Insert method for the "fluidConsistencyType" property.
Method SetFluidConsistencyType(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed") Quit
		Set tSC = ..fluidConsistencyType.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "instruction" property.
Method SetInstruction(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set ..instruction = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
