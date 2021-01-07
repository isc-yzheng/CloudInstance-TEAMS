/// A container for a collection of resources.
Class HS.FHIR.vSTU3.Model.Resource.Bundle.Search Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Bundle.Search";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Bundle.Search";

Parameter JSONTYPEFIELD;

/// Why this entry is in the result set - whether it's included as a match or because of an _include requirement.
Property mode As HS.FHIR.vSTU3.Model.Base.SearchEntryMode(XMLNAME = "mode", XMLPROJECTION = "ELEMENT");

/// When searching, the server's search ranking score for the entry.
Property score As HS.FHIR.vSTU3.Model.Datatype.Decimal(XMLNAME = "score", XMLPROJECTION = "ELEMENT");

/// Set method for the "mode" property.
Method SetMode(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.SearchEntryMode).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR SearchEntryMode object failed"_$Select(err="":"",1:" - "_err)) Quit
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
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Decimal).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Decimal object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..score = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
