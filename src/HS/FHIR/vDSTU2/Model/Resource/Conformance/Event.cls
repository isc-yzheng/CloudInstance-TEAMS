Class HS.FHIR.vDSTU2.Model.Resource.Conformance.Event Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Conformance.Event";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Conformance.Event";

/// A coded identifier of a supported messaging event.
Property code As HS.FHIR.vDSTU2.Model.Base.Coding(XMLNAME = "code") [ Required ];

/// The impact of the content of the message.
Property category As HS.FHIR.vDSTU2.Model.Base.MessageSignificanceCategory(XMLNAME = "category");

/// The mode of this event declaration - whether application is sender or receiver.
Property mode As HS.FHIR.vDSTU2.Model.Base.ConformanceEventMode(XMLNAME = "mode") [ Required ];

/// A resource associated with the event.  This is the resource that defines the event.
Property focus As HS.FHIR.vDSTU2.Model.Datatype.Code(XMLNAME = "focus") [ Required ];

/// Information about the request for this event.
Property request As HS.FHIR.vDSTU2.Model.Base.Reference(XMLNAME = "request") [ Required ];

/// Information about the response for this event.
Property response As HS.FHIR.vDSTU2.Model.Base.Reference(XMLNAME = "response") [ Required ];

/// Guidance on how this event is handled, such as internal system trigger points, business rules, etc.
Property documentation As HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "documentation");

/// Set method for the "code" property.
Method SetCode(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Coding).%New(pCode, pDisplay, pSystem, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Coding object failed") Quit
		Set ..code = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "category" property.
Method SetCategory(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.MessageSignificanceCategory).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR MessageSignificanceCategory object failed") Quit
		Set ..category = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "mode" property.
Method SetMode(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.ConformanceEventMode).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR ConformanceEventMode object failed") Quit
		Set ..mode = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "focus" property.
Method SetFocus(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Code).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Code object failed") Quit
		Set ..focus = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "request" property.
Method SetRequest(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed") Quit
		Set ..request = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "response" property.
Method SetResponse(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed") Quit
		Set ..response = tObj
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
