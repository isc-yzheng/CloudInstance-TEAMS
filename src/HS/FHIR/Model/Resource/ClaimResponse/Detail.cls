/// *** <b>THIS CLASS IS DEPRECATED.</b> Please use HS.FHIR.<b>vDSTU2.</b>Model.Resource.ClaimResponse.Detail when working with FHIR DSTU2.
Class HS.FHIR.Model.Resource.ClaimResponse.Detail Extends HS.FHIR.Model.Base.BackboneElement [ Deprecated, ProcedureBlock ]
{

///  
Parameter JSONTYPEFIELD;

///  
Parameter ELEMENTQUALIFIED = 1;

///  
Parameter XMLNAME = "ClaimResponse.Detail";

///  
Parameter XMLSEQUENCE = 1;

///  
Parameter XMLTYPE = "ClaimResponse.Detail";

///  
Property sequenceLinkId As HS.FHIR.Model.Datatype.PositiveInt(XMLNAME = "sequenceLinkId") [ Required ];

///  
Property adjudication As list Of HS.FHIR.Model.Resource.ClaimResponse.Adjudication1(XMLNAME = "adjudication", XMLPROJECTION = "ELEMENT");

///  
Property subDetail As list Of HS.FHIR.Model.Resource.ClaimResponse.SubDetail(XMLNAME = "subDetail", XMLPROJECTION = "ELEMENT");

///  
Method SetSequenceLinkId(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Datatype.PositiveInt).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR PositiveInt object failed") Quit
		Set ..sequenceLinkId = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
