Class HS.FHIR.vDSTU2.Model.Resource.ClaimResponse.SubDetail Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ClaimResponse.SubDetail";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ClaimResponse.SubDetail";

/// A service line number.
Property sequenceLinkId As HS.FHIR.vDSTU2.Model.Datatype.PositiveInt(XMLNAME = "sequenceLinkId") [ Required ];

/// The adjudications results.
Property adjudication As list Of HS.FHIR.vDSTU2.Model.Resource.ClaimResponse.Adjudication2(XMLNAME = "adjudication", XMLPROJECTION = "ELEMENT");

/// Set method for the "sequenceLinkId" property.
Method SetSequenceLinkId(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.PositiveInt).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR PositiveInt object failed") Quit
		Set ..sequenceLinkId = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
