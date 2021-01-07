Class HS.FHIR.vDSTU2.Model.Resource.ClaimResponse.Item Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ClaimResponse.Item";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ClaimResponse.Item";

/// A service line number.
Property sequenceLinkId As HS.FHIR.vDSTU2.Model.Datatype.PositiveInt(XMLNAME = "sequenceLinkId") [ Required ];

/// A list of note references to the notes provided below.
Property noteNumber As list Of HS.FHIR.vDSTU2.Model.Datatype.PositiveInt(XMLNAME = "noteNumber", XMLPROJECTION = "ELEMENT");

/// The adjudications results.
Property adjudication As list Of HS.FHIR.vDSTU2.Model.Resource.ClaimResponse.Adjudication(XMLNAME = "adjudication", XMLPROJECTION = "ELEMENT");

/// The second tier service adjudications for submitted services.
Property detail As list Of HS.FHIR.vDSTU2.Model.Resource.ClaimResponse.Detail(XMLNAME = "detail", XMLPROJECTION = "ELEMENT");

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

/// Insert method for the "noteNumber" property.
Method SetNoteNumber(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.PositiveInt).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR PositiveInt object failed") Quit
		Set tSC = ..noteNumber.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
