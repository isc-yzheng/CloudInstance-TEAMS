/// A structured set of tests against a FHIR server implementation to determine compliance against the FHIR specification.
Class HS.FHIR.vSTU3.Model.Resource.TestScript.Param3 Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "TestScript.Param3";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "TestScript.Param3";

Parameter JSONTYPEFIELD;

/// Descriptive name for this parameter that matches the external assert ruleset rule parameter name.
Property name As HS.FHIR.vSTU3.Model.Datatype.String(XMLNAME = "name", XMLPROJECTION = "ELEMENT") [ Required ];

/// The value for the parameter that will be passed on to the external ruleset rule template.
Property value As HS.FHIR.vSTU3.Model.Datatype.String(XMLNAME = "value", XMLPROJECTION = "ELEMENT") [ Required ];

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

/// Set method for the "value" property.
Method SetValue(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..value = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
