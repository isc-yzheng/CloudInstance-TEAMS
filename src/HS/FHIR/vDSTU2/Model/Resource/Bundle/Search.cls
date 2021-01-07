Class HS.FHIR.vDSTU2.Model.Resource.Bundle.Search Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Bundle.Search";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Bundle.Search";

/// Why this entry is in the result set - whether it's included as a match or because of an _include requirement.
Property mode As HS.FHIR.vDSTU2.Model.Base.SearchEntryMode(XMLNAME = "mode");

/// When searching, the server's search ranking score for the entry.
Property score As HS.FHIR.vDSTU2.Model.Datatype.Decimal(XMLNAME = "score");

/// Set method for the "mode" property.
Method SetMode(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.SearchEntryMode).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR SearchEntryMode object failed") Quit
		Set ..mode = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "score" property.
Method SetScore(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Decimal).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Decimal object failed") Quit
		Set ..score = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
