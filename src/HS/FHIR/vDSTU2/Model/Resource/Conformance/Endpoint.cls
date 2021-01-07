Class HS.FHIR.vDSTU2.Model.Resource.Conformance.Endpoint Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Conformance.Endpoint";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Conformance.Endpoint";

/// A list of the messaging transport protocol(s) identifiers, supported by this endpoint.
Property protocol As HS.FHIR.vDSTU2.Model.Base.Coding(XMLNAME = "protocol") [ Required ];

/// The network address of the end-point. For solutions that do not use network addresses for routing, it can be just an identifier.
Property address As HS.FHIR.vDSTU2.Model.Datatype.Uri(XMLNAME = "address") [ Required ];

/// Set method for the "protocol" property.
Method SetProtocol(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Coding).%New(pCode, pDisplay, pSystem, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Coding object failed") Quit
		Set ..protocol = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "address" property.
Method SetAddress(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Uri).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Uri object failed") Quit
		Set ..address = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
