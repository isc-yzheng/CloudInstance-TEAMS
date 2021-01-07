/// Defines the characteristics of a message that can be shared between systems, including the type of event that initiates the message, the content to be transmitted and what response(s), if any, are permitted.
Class HS.FHIR.vSTU3.Model.Resource.MessageDefinition.AllowedResponse Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "MessageDefinition.AllowedResponse";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "MessageDefinition.AllowedResponse";

Parameter JSONTYPEFIELD;

/// A reference to the message definition that must be adhered to by this supported response.
Property message As HS.FHIR.vSTU3.Model.Base.Reference(XMLNAME = "message", XMLPROJECTION = "ELEMENT") [ Required ];

/// Provides a description of the circumstances in which this response should be used (as opposed to one of the alternative responses).
Property situation As HS.FHIR.vSTU3.Model.Datatype.Markdown(XMLNAME = "situation", XMLPROJECTION = "ELEMENT");

/// Set method for the "message" property.
Method SetMessage(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..message = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "situation" property.
Method SetSituation(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Markdown).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Markdown object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..situation = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
