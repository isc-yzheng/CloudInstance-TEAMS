/// *** <b>THIS CLASS IS DEPRECATED.</b> Please use HS.FHIR.<b>vDSTU2.</b>Model.Resource.ClaimResponse.Error when working with FHIR DSTU2.
Class HS.FHIR.Model.Resource.ClaimResponse.Error Extends HS.FHIR.Model.Base.BackboneElement [ Deprecated, ProcedureBlock ]
{

///  
Parameter JSONTYPEFIELD;

///  
Parameter ELEMENTQUALIFIED = 1;

///  
Parameter XMLNAME = "ClaimResponse.Error";

///  
Parameter XMLSEQUENCE = 1;

///  
Parameter XMLTYPE = "ClaimResponse.Error";

///  
Property sequenceLinkId As HS.FHIR.Model.Datatype.PositiveInt(XMLNAME = "sequenceLinkId");

///  
Property detailSequenceLinkId As HS.FHIR.Model.Datatype.PositiveInt(XMLNAME = "detailSequenceLinkId");

///  
Property subdetailSequenceLinkId As HS.FHIR.Model.Datatype.PositiveInt(XMLNAME = "subdetailSequenceLinkId");

///  
Property code As HS.FHIR.Model.Base.Coding(XMLNAME = "code") [ Required ];

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

///  
Method SetDetailSequenceLinkId(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Datatype.PositiveInt).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR PositiveInt object failed") Quit
		Set ..detailSequenceLinkId = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  
Method SetSubdetailSequenceLinkId(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Datatype.PositiveInt).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR PositiveInt object failed") Quit
		Set ..subdetailSequenceLinkId = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  
Method SetCode(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Base.Coding).%New(pCode, pDisplay, pSystem, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Coding object failed") Quit
		Set ..code = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
