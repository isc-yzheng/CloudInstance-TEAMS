/// A formal computable definition of an operation (on the RESTful interface) or a named query (using the search interaction).
Class HS.FHIR.vSTU3.Model.Resource.OperationDefinition.Overload Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "OperationDefinition.Overload";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "OperationDefinition.Overload";

Parameter JSONTYPEFIELD;

/// Name of parameter to include in overload.
Property parameterName As list Of HS.FHIR.vSTU3.Model.Datatype.String(XMLNAME = "parameterName", XMLPROJECTION = "ELEMENT");

/// Comments to go on overload.
Property comment As HS.FHIR.vSTU3.Model.Datatype.String(XMLNAME = "comment", XMLPROJECTION = "ELEMENT");

/// Insert method for the "parameterName" property.
Method SetParameterName(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set tSC = ..parameterName.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "comment" property.
Method SetComment(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..comment = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
