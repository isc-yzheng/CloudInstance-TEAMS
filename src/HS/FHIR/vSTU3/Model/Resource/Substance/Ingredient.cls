/// A homogeneous material with a definite composition.
Class HS.FHIR.vSTU3.Model.Resource.Substance.Ingredient Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Substance.Ingredient";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Substance.Ingredient";

Parameter JSONTYPEFIELD;

/// The amount of the ingredient in the substance - a concentration ratio.
Property quantity As HS.FHIR.vSTU3.Model.Base.Ratio(XMLNAME = "quantity", XMLPROJECTION = "ELEMENT");

Property substanceCodeableConcept As HS.FHIR.vSTU3.Model.Base.CodeableConcept(XMLNAME = "substanceCodeableConcept", XMLPROJECTION = "ELEMENT");

Property substanceReference As HS.FHIR.vSTU3.Model.Base.Reference(XMLNAME = "substanceReference", XMLPROJECTION = "ELEMENT");

/// Set method for the "substanceCodeableConcept" property.
Method SetSubstanceCodeableConcept(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..substanceCodeableConcept = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "substanceReference" property.
Method SetSubstanceReference(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..substanceReference = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
