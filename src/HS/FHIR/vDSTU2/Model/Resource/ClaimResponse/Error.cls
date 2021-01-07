Class HS.FHIR.vDSTU2.Model.Resource.ClaimResponse.Error Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ClaimResponse.Error";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ClaimResponse.Error";

/// The sequence number of the line item submitted which contains the error. This value is omitted when the error is elsewhere.
Property sequenceLinkId As HS.FHIR.vDSTU2.Model.Datatype.PositiveInt(XMLNAME = "sequenceLinkId");

/// The sequence number of the addition within the line item submitted which contains the error. This value is omitted when the error is not related to an Addition.
Property detailSequenceLinkId As HS.FHIR.vDSTU2.Model.Datatype.PositiveInt(XMLNAME = "detailSequenceLinkId");

/// The sequence number of the addition within the line item submitted which contains the error. This value is omitted when the error is not related to an Addition.
Property subdetailSequenceLinkId As HS.FHIR.vDSTU2.Model.Datatype.PositiveInt(XMLNAME = "subdetailSequenceLinkId");

/// An error code,froma specified code system, which details why the claim could not be adjudicated.
Property code As HS.FHIR.vDSTU2.Model.Base.Coding(XMLNAME = "code") [ Required ];

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

/// Set method for the "detailSequenceLinkId" property.
Method SetDetailSequenceLinkId(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.PositiveInt).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR PositiveInt object failed") Quit
		Set ..detailSequenceLinkId = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "subdetailSequenceLinkId" property.
Method SetSubdetailSequenceLinkId(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.PositiveInt).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR PositiveInt object failed") Quit
		Set ..subdetailSequenceLinkId = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "code" property.
Method SetCode(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Coding).%New(pCode, pDisplay, pSystem, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Coding object failed") Quit
		Set ..code = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
