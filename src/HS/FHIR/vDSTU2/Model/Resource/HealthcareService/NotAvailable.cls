Class HS.FHIR.vDSTU2.Model.Resource.HealthcareService.NotAvailable Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "HealthcareService.NotAvailable";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "HealthcareService.NotAvailable";

/// The reason that can be presented to the user as to why this time is not available.
Property description As HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "description") [ Required ];

/// Service is not available (seasonally or for a public holiday) from this date.
Property during As HS.FHIR.vDSTU2.Model.Base.Period(XMLNAME = "during");

/// Set method for the "description" property.
Method SetDescription(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set ..description = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "during" property.
Method SetDuring(pStart As %String = "", pEnd As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Period).%New(pStart, pEnd, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Period object failed") Quit
		Set ..during = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
