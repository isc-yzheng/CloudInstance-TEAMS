Class HS.FHIR.vDSTU2.Model.Resource.ProcessRequest.Item Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ProcessRequest.Item";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ProcessRequest.Item";

/// A service line number.
Property sequenceLinkId As HS.FHIR.vDSTU2.Model.Datatype.Integer(XMLNAME = "sequenceLinkId") [ Required ];

/// Set method for the "sequenceLinkId" property.
Method SetSequenceLinkId(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Integer).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Integer object failed") Quit
		Set ..sequenceLinkId = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
