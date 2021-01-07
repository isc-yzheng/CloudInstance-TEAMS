Class HS.FHIR.vDSTU2.Model.Resource.Medication.Content Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Medication.Content";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Medication.Content";

/// Identifies one of the items in the package.
Property item As HS.FHIR.vDSTU2.Model.Base.Reference(XMLNAME = "item") [ Required ];

/// The amount of the product that is in the package.
Property amount As HS.FHIR.vDSTU2.Model.Base.SimpleQuantity(XMLNAME = "amount");

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
