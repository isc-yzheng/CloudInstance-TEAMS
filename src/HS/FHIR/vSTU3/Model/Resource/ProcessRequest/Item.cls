/// This resource provides the target, request and response, and action details for an action to be performed by the target on or about existing resources.
Class HS.FHIR.vSTU3.Model.Resource.ProcessRequest.Item Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ProcessRequest.Item";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ProcessRequest.Item";

Parameter JSONTYPEFIELD;

/// A service line number.
Property sequenceLinkId As HS.FHIR.vSTU3.Model.Datatype.Integer(XMLNAME = "sequenceLinkId", XMLPROJECTION = "ELEMENT") [ Required ];

/// Set method for the "sequenceLinkId" property.
Method SetSequenceLinkId(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Integer).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Integer object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..sequenceLinkId = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
