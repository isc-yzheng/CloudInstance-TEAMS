Class HS.FHIR.vDSTU2.Model.Resource.AuditEvent.Detail Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "AuditEvent.Detail";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "AuditEvent.Detail";

/// Name of the property.
Property type As HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "type") [ Required ];

/// Property value.
Property value As HS.FHIR.vDSTU2.Model.Datatype.Base64Binary(XMLNAME = "value") [ Required ];

/// Set method for the "type" property.
Method SetType(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set ..type = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "value" property.
Method SetValue(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Base64Binary).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Base64Binary object failed") Quit
		Set ..value = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
