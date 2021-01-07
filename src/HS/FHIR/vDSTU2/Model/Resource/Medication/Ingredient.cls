Class HS.FHIR.vDSTU2.Model.Resource.Medication.Ingredient Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Medication.Ingredient";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Medication.Ingredient";

/// The actual ingredient - either a substance (simple ingredient) or another medication.
Property item As HS.FHIR.vDSTU2.Model.Base.Reference(XMLNAME = "item") [ Required ];

/// Specifies how many (or how much) of the items there are in this Medication.  For example, 250 mg per tablet.
Property amount As HS.FHIR.vDSTU2.Model.Base.Ratio(XMLNAME = "amount");

/// Set method for the "item" property.
Method SetItem(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed") Quit
		Set ..item = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
