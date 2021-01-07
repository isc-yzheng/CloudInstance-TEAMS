/// A record of a healthcare consumer’s policy choices, which permits or denies identified recipient(s) or recipient role(s) to perform one or more actions within a given policy context, for specific purposes and periods of time.
Class HS.FHIR.vSTU3.Model.Resource.Consent.Policy Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Consent.Policy";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Consent.Policy";

Parameter JSONTYPEFIELD;

/// Entity or Organization having regulatory jurisdiction or accountability for  enforcing policies pertaining to Consent Directives.
Property authority As HS.FHIR.vSTU3.Model.Datatype.Uri(XMLNAME = "authority", XMLPROJECTION = "ELEMENT");

/// The references to the policies that are included in this consent scope. Policies may be organizational, but are often defined jurisdictionally, or in law.
Property uri As HS.FHIR.vSTU3.Model.Datatype.Uri(XMLNAME = "uri", XMLPROJECTION = "ELEMENT");

/// Set method for the "authority" property.
Method SetAuthority(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Uri).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Uri object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..authority = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "uri" property.
Method SetUri(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Uri).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Uri object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..uri = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
