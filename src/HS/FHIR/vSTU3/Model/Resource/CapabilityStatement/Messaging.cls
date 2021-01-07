/// A Capability Statement documents a set of capabilities (behaviors) of a FHIR Server that may be used as a statement of actual server functionality or a statement of required or desired server implementation.
Class HS.FHIR.vSTU3.Model.Resource.CapabilityStatement.Messaging Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "CapabilityStatement.Messaging";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "CapabilityStatement.Messaging";

Parameter JSONTYPEFIELD;

/// An endpoint (network accessible address) to which messages and/or replies are to be sent.
Property endpoint As list Of HS.FHIR.vSTU3.Model.Resource.CapabilityStatement.Endpoint(XMLNAME = "endpoint", XMLPROJECTION = "ELEMENT");

/// Length if the receiver's reliable messaging cache in minutes (if a receiver) or how long the cache length on the receiver should be (if a sender).
Property reliableCache As HS.FHIR.vSTU3.Model.Datatype.UnsignedInt(XMLNAME = "reliableCache", XMLPROJECTION = "ELEMENT");

/// Documentation about the system's messaging capabilities for this endpoint not otherwise documented by the capability statement.  For example, the process for becoming an authorized messaging exchange partner.
Property documentation As HS.FHIR.vSTU3.Model.Datatype.String(XMLNAME = "documentation", XMLPROJECTION = "ELEMENT");

/// References to message definitions for messages this system can send or receive.
Property supportedMessage As list Of HS.FHIR.vSTU3.Model.Resource.CapabilityStatement.SupportedMessage(XMLNAME = "supportedMessage", XMLPROJECTION = "ELEMENT");

/// A description of the solution's support for an event at this end-point.
Property event As list Of HS.FHIR.vSTU3.Model.Resource.CapabilityStatement.Event(XMLNAME = "event", XMLPROJECTION = "ELEMENT");

/// Set method for the "reliableCache" property.
Method SetReliableCache(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.UnsignedInt).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR UnsignedInt object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..reliableCache = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "documentation" property.
Method SetDocumentation(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..documentation = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
