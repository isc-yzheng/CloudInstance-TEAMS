Class HS.FHIR.vDSTU2.Model.Resource.Bundle.Request Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Bundle.Request";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Bundle.Request";

/// The HTTP verb for this entry in either a update history, or a transaction/ transaction response.
Property method As HS.FHIR.vDSTU2.Model.Base.HTTPVerb(XMLNAME = "method") [ Required ];

/// The URL for this entry, relative to the root (the address to which the request is posted).
Property url As HS.FHIR.vDSTU2.Model.Datatype.Uri(XMLNAME = "url") [ Required ];

/// If the ETag values match, return a 304 Not modified status. See the API documentation for ["Conditional Read"](http.html#cread).
Property ifNoneMatch As HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "ifNoneMatch");

/// Only perform the operation if the last updated date matches. See the API documentation for ["Conditional Read"](http.html#cread).
Property ifModifiedSince As HS.FHIR.vDSTU2.Model.Datatype.Instant(XMLNAME = "ifModifiedSince");

/// Only perform the operation if the Etag value matches. For more information, see the API section ["Managing Resource Contention"](http.html#concurrency).
Property ifMatch As HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "ifMatch");

/// Instruct the server not to perform the create if a specified resource already exists. For further information, see the API documentation for ["Conditional Create"](http.html#ccreate). This is just the query portion of the URL - what follows the"?" (not including the"?").
Property ifNoneExist As HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "ifNoneExist");

/// Set method for the "method" property.
Method SetMethod(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.HTTPVerb).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR HTTPVerb object failed") Quit
		Set ..method = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "url" property.
Method SetUrl(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Uri).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Uri object failed") Quit
		Set ..url = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "ifNoneMatch" property.
Method SetIfNoneMatch(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set ..ifNoneMatch = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "ifModifiedSince" property.
Method SetIfModifiedSince(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Instant).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Instant object failed") Quit
		Set ..ifModifiedSince = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "ifMatch" property.
Method SetIfMatch(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set ..ifMatch = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "ifNoneExist" property.
Method SetIfNoneExist(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set ..ifNoneExist = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
