Class HS.FHIR.vDSTU2.Model.Resource.Medication.Product Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Medication.Product";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Medication.Product";

/// Describes the form of the item.  Powder; tablets; carton.
Property form As HS.FHIR.vDSTU2.Model.Base.CodeableConcept(XMLNAME = "form");

/// Identifies a particular constituent of interest in the product.
Property ingredient As list Of HS.FHIR.vDSTU2.Model.Resource.Medication.Ingredient(XMLNAME = "ingredient", XMLPROJECTION = "ELEMENT");

/// Information about a group of medication produced or packaged from one production run.
Property batch As list Of HS.FHIR.vDSTU2.Model.Resource.Medication.Batch(XMLNAME = "batch", XMLPROJECTION = "ELEMENT");

/// Set method for the "form" property.
Method SetForm(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed") Quit
		Set ..form = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
