/// The subscription resource is used to define a push based subscription from a server to another system. Once a subscription is registered with the server, the server checks every resource that is created or updated, and if the resource matches the given criteria, it sends a message on the defined "channel" so that another system is able to take an appropriate action.
Class HS.FHIR.vSTU3.Model.Resource.Subscription.Channel Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Subscription.Channel";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Subscription.Channel";

Parameter JSONTYPEFIELD;

/// The type of channel to send notifications on.
Property type As HS.FHIR.vSTU3.Model.Base.SubscriptionChannelType(XMLNAME = "type", XMLPROJECTION = "ELEMENT") [ Required ];

/// The uri that describes the actual end-point to send messages to.
Property endpoint As HS.FHIR.vSTU3.Model.Datatype.Uri(XMLNAME = "endpoint", XMLPROJECTION = "ELEMENT");

/// The mime type to send the payload in - either application/fhir+xml, or application/fhir+json. If the payload is not present, then there is no payload in the notification, just a notification.
Property payload As HS.FHIR.vSTU3.Model.Datatype.String(XMLNAME = "payload", XMLPROJECTION = "ELEMENT");

/// Additional headers / information to send as part of the notification.
Property header As list Of HS.FHIR.vSTU3.Model.Datatype.String(XMLNAME = "header", XMLPROJECTION = "ELEMENT");

/// Set method for the "type" property.
Method SetType(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.SubscriptionChannelType).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR SubscriptionChannelType object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..type = tObj
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

/// Set method for the "payload" property.
Method SetPayload(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..payload = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Insert method for the "header" property.
Method SetHeader(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set tSC = ..header.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
