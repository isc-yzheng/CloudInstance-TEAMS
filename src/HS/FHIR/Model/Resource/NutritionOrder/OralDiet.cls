/// *** <b>THIS CLASS IS DEPRECATED.</b> Please use HS.FHIR.<b>vDSTU2.</b>Model.Resource.NutritionOrder.OralDiet when working with FHIR DSTU2.
Class HS.FHIR.Model.Resource.NutritionOrder.OralDiet Extends HS.FHIR.Model.Base.BackboneElement [ Deprecated, ProcedureBlock ]
{

///  
Parameter JSONTYPEFIELD;

///  
Parameter ELEMENTQUALIFIED = 1;

///  
Parameter XMLNAME = "NutritionOrder.OralDiet";

///  
Parameter XMLSEQUENCE = 1;

///  
Parameter XMLTYPE = "NutritionOrder.OralDiet";

///  
Property type As list Of HS.FHIR.Model.Base.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

///  
Property schedule As list Of HS.FHIR.Model.Base.Timing(XMLNAME = "schedule", XMLPROJECTION = "ELEMENT");

///  
Property nutrient As list Of HS.FHIR.Model.Resource.NutritionOrder.Nutrient(XMLNAME = "nutrient", XMLPROJECTION = "ELEMENT");

///  
Property texture As list Of HS.FHIR.Model.Resource.NutritionOrder.Texture(XMLNAME = "texture", XMLPROJECTION = "ELEMENT");

///  
Property fluidConsistencyType As list Of HS.FHIR.Model.Base.CodeableConcept(XMLNAME = "fluidConsistencyType", XMLPROJECTION = "ELEMENT");

///  
Property instruction As HS.FHIR.Model.Datatype.String(XMLNAME = "instruction");

///  
Method SetType(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed") Quit
		Set tSC = ..type.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  
Method SetFluidConsistencyType(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed") Quit
		Set tSC = ..fluidConsistencyType.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  
Method SetInstruction(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set ..instruction = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
