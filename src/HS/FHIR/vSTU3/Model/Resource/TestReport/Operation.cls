/// A summary of information based on the results of executing a TestScript.
Class HS.FHIR.vSTU3.Model.Resource.TestReport.Operation Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "TestReport.Operation";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "TestReport.Operation";

Parameter JSONTYPEFIELD;

/// The result of this operation.
Property result As HS.FHIR.vSTU3.Model.Base.TestReportActionResult(XMLNAME = "result", XMLPROJECTION = "ELEMENT") [ Required ];

/// An explanatory message associated with the result.
Property message As HS.FHIR.vSTU3.Model.Datatype.Markdown(XMLNAME = "message", XMLPROJECTION = "ELEMENT");

/// A link to further details on the result.
Property detail As HS.FHIR.vSTU3.Model.Datatype.Uri(XMLNAME = "detail", XMLPROJECTION = "ELEMENT");

/// Set method for the "result" property.
Method SetResult(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.TestReportActionResult).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR TestReportActionResult object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..result = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "message" property.
Method SetMessage(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Markdown).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Markdown object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..message = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "detail" property.
Method SetDetail(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Uri).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Uri object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..detail = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
