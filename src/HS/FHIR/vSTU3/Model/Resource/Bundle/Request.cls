/// A container for a collection of resources.
Class HS.FHIR.vSTU3.Model.Resource.Bundle.Request Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Bundle.Request";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Bundle.Request";

Parameter JSONTYPEFIELD;

/// The HTTP verb for this entry in either a change history, or a transaction/ transaction response.
Property method As HS.FHIR.vSTU3.Model.Base.HTTPVerb(XMLNAME = "method", XMLPROJECTION = "ELEMENT") [ Required ];

/// The URL for this entry, relative to the root (the address to which the request is posted).
Property url As HS.FHIR.vSTU3.Model.Datatype.Uri(XMLNAME = "url", XMLPROJECTION = "ELEMENT") [ Required ];

/// If the ETag values match, return a 304 Not Modified status. See the API documentation for ["Conditional Read"](http.html#cread).
Property ifNoneMatch As HS.FHIR.vSTU3.Model.Datatype.String(XMLNAME = "ifNoneMatch", XMLPROJECTION = "ELEMENT");

/// Only perform the operation if the last updated date matches. See the API documentation for ["Conditional Read"](http.html#cread).
Property ifModifiedSince As HS.FHIR.vSTU3.Model.Datatype.Instant(XMLNAME = "ifModifiedSince", XMLPROJECTION = "ELEMENT");

/// Only perform the operation if the Etag value matches. For more information, see the API section ["Managing Resource Contention"](http.html#concurrency).
Property ifMatch As HS.FHIR.vSTU3.Model.Datatype.String(XMLNAME = "ifMatch", XMLPROJECTION = "ELEMENT");

/// Instruct the server not to perform the create if a specified resource already exists. For further information, see the API documentation for ["Conditional Create"](http.html#ccreate). This is just the query portion of the URL - what follows the "?" (not including the "?").
Property ifNoneExist As HS.FHIR.vSTU3.Model.Datatype.String(XMLNAME = "ifNoneExist", XMLPROJECTION = "ELEMENT");

/// Set method for the "method" property.
Method SetMethod(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.HTTPVerb).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR HTTPVerb object failed"_$Select(err="":"",1:" - "_err)) Quit
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
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Uri).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Uri object failed"_$Select(err="":"",1:" - "_err)) Quit
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
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed"_$Select(err="":"",1:" - "_err)) Quit
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
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Instant).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Instant object failed"_$Select(err="":"",1:" - "_err)) Quit
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
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed"_$Select(err="":"",1:" - "_err)) Quit
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
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..ifNoneExist = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
