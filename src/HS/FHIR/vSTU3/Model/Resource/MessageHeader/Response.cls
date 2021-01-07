/// The header for a message exchange that is either requesting or responding to an action.  The reference(s) that are the subject of the action as well as other information related to the action are typically transmitted in a bundle in which the MessageHeader resource instance is the first resource in the bundle.
Class HS.FHIR.vSTU3.Model.Resource.MessageHeader.Response Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "MessageHeader.Response";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "MessageHeader.Response";

Parameter JSONTYPEFIELD;

/// The MessageHeader.id of the message to which this message is a response.
Property identifier As HS.FHIR.vSTU3.Model.Datatype.Id(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT") [ Required ];

/// Code that identifies the type of response to the message - whether it was successful or not, and whether it should be resent or not.
Property code As HS.FHIR.vSTU3.Model.Base.ResponseType(XMLNAME = "code", XMLPROJECTION = "ELEMENT") [ Required ];

/// Full details of any issues found in the message.
Property details As HS.FHIR.vSTU3.Model.Base.Reference(XMLNAME = "details", XMLPROJECTION = "ELEMENT");

/// Set method for the "identifier" property.
Method SetIdentifier(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Id).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Id object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..identifier = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "code" property.
Method SetCode(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.ResponseType).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR ResponseType object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..code = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "details" property.
Method SetDetails(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..details = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
