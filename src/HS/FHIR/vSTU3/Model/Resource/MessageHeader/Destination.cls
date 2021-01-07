/// The header for a message exchange that is either requesting or responding to an action.  The reference(s) that are the subject of the action as well as other information related to the action are typically transmitted in a bundle in which the MessageHeader resource instance is the first resource in the bundle.
Class HS.FHIR.vSTU3.Model.Resource.MessageHeader.Destination Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "MessageHeader.Destination";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "MessageHeader.Destination";

Parameter JSONTYPEFIELD;

/// Human-readable name for the target system.
Property name As HS.FHIR.vSTU3.Model.Datatype.String(XMLNAME = "name", XMLPROJECTION = "ELEMENT");

/// Identifies the target end system in situations where the initial message transmission is to an intermediary system.
Property target As HS.FHIR.vSTU3.Model.Base.Reference(XMLNAME = "target", XMLPROJECTION = "ELEMENT");

/// Indicates where the message should be routed to.
Property endpoint As HS.FHIR.vSTU3.Model.Datatype.Uri(XMLNAME = "endpoint", XMLPROJECTION = "ELEMENT") [ Required ];

/// Set method for the "name" property.
Method SetName(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..name = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "target" property.
Method SetTarget(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..target = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "endpoint" property.
Method SetEndpoint(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Uri).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Uri object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..endpoint = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
