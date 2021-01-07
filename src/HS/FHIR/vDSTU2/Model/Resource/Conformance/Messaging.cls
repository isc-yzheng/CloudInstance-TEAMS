Class HS.FHIR.vDSTU2.Model.Resource.Conformance.Messaging Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Conformance.Messaging";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Conformance.Messaging";

/// An endpoint (network accessible address) to which messages and/or replies are to be sent.
Property endpoint As list Of HS.FHIR.vDSTU2.Model.Resource.Conformance.Endpoint(XMLNAME = "endpoint", XMLPROJECTION = "ELEMENT");

/// Length if the receiver's reliable messaging cache in minutes (if a receiver) or how long the cache length on the receiver should be (if a sender).
Property reliableCache As HS.FHIR.vDSTU2.Model.Datatype.UnsignedInt(XMLNAME = "reliableCache");

/// Documentation about the system's messaging capabilities for this endpoint not otherwise documented by the conformance statement.  For example, process for becoming an authorized messaging exchange partner.
Property documentation As HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "documentation");

/// A description of the solution's support for an event at this end-point.
Property event As list Of HS.FHIR.vDSTU2.Model.Resource.Conformance.Event(XMLNAME = "event", XMLPROJECTION = "ELEMENT") [ Required ];

/// Set method for the "reliableCache" property.
Method SetReliableCache(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.UnsignedInt).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR UnsignedInt object failed") Quit
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
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set ..documentation = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
