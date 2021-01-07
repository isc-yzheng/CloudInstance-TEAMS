/// A summary of information based on the results of executing a TestScript.
Class HS.FHIR.vSTU3.Model.Resource.TestReport.Test Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "TestReport.Test";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "TestReport.Test";

Parameter JSONTYPEFIELD;

/// The name of this test used for tracking/logging purposes by test engines.
Property name As HS.FHIR.vSTU3.Model.Datatype.String(XMLNAME = "name", XMLPROJECTION = "ELEMENT");

/// A short description of the test used by test engines for tracking and reporting purposes.
Property description As HS.FHIR.vSTU3.Model.Datatype.String(XMLNAME = "description", XMLPROJECTION = "ELEMENT");

/// Action would contain either an operation or an assertion.
Property action As list Of HS.FHIR.vSTU3.Model.Resource.TestReport.Action1(XMLNAME = "action", XMLPROJECTION = "ELEMENT");

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

/// Set method for the "description" property.
Method SetDescription(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..description = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
