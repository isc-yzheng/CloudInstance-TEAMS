Class HS.FHIR.vDSTU2.Model.Resource.AuditEvent.Network Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "AuditEvent.Network";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "AuditEvent.Network";

/// An identifier for the network access point of the user device for the audit event.
Property address As HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "address");

/// An identifier for the type of network access point that originated the audit event.
Property type As HS.FHIR.vDSTU2.Model.Base.AuditEventParticipantNetworkType(XMLNAME = "type");

/// Set method for the "address" property.
Method SetAddress(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set ..address = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "type" property.
Method SetType(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.AuditEventParticipantNetworkType).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR AuditEventParticipantNetworkType object failed") Quit
		Set ..type = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
