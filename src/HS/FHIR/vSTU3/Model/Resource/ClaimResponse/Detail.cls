/// This resource provides the adjudication details from the processing of a Claim resource.
Class HS.FHIR.vSTU3.Model.Resource.ClaimResponse.Detail Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ClaimResponse.Detail";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ClaimResponse.Detail";

Parameter JSONTYPEFIELD;

/// A service line number.
Property sequenceLinkId As HS.FHIR.vSTU3.Model.Datatype.PositiveInt(XMLNAME = "sequenceLinkId", XMLPROJECTION = "ELEMENT") [ Required ];

/// A list of note references to the notes provided below.
Property noteNumber As list Of HS.FHIR.vSTU3.Model.Datatype.PositiveInt(XMLNAME = "noteNumber", XMLPROJECTION = "ELEMENT");

/// The adjudications results.
Property adjudication As list Of HS.FHIR.vSTU3.Model.Resource.ClaimResponse.Adjudication(XMLNAME = "adjudication", XMLPROJECTION = "ELEMENT");

/// The third tier service adjudications for submitted services.
Property subDetail As list Of HS.FHIR.vSTU3.Model.Resource.ClaimResponse.SubDetail(XMLNAME = "subDetail", XMLPROJECTION = "ELEMENT");

/// Set method for the "sequenceLinkId" property.
Method SetSequenceLinkId(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.PositiveInt).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR PositiveInt object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..sequenceLinkId = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Insert method for the "noteNumber" property.
Method SetNoteNumber(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.PositiveInt).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR PositiveInt object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set tSC = ..noteNumber.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
