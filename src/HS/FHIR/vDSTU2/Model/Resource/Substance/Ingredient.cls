Class HS.FHIR.vDSTU2.Model.Resource.Substance.Ingredient Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Substance.Ingredient";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Substance.Ingredient";

/// The amount of the ingredient in the substance - a concentration ratio.
Property quantity As HS.FHIR.vDSTU2.Model.Base.Ratio(XMLNAME = "quantity");

/// Another substance that is a component of this substance.
Property substance As HS.FHIR.vDSTU2.Model.Base.Reference(XMLNAME = "substance") [ Required ];

/// Set method for the "substance" property.
Method SetSubstance(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed") Quit
		Set ..substance = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
