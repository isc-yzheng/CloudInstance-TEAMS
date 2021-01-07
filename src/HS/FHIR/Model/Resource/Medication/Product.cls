/// *** <b>THIS CLASS IS DEPRECATED.</b> Please use HS.FHIR.<b>vDSTU2.</b>Model.Resource.Medication.Product when working with FHIR DSTU2.
Class HS.FHIR.Model.Resource.Medication.Product Extends HS.FHIR.Model.Base.BackboneElement [ Deprecated, ProcedureBlock ]
{

///  
Parameter JSONTYPEFIELD;

///  
Parameter ELEMENTQUALIFIED = 1;

///  
Parameter XMLNAME = "Medication.Product";

///  
Parameter XMLSEQUENCE = 1;

///  
Parameter XMLTYPE = "Medication.Product";

///  
Property form As HS.FHIR.Model.Base.CodeableConcept(XMLNAME = "form");

///  
Property ingredient As list Of HS.FHIR.Model.Resource.Medication.Ingredient(XMLNAME = "ingredient", XMLPROJECTION = "ELEMENT");

///  
Property batch As list Of HS.FHIR.Model.Resource.Medication.Batch(XMLNAME = "batch", XMLPROJECTION = "ELEMENT");

///  
Method SetForm(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed") Quit
		Set ..form = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
