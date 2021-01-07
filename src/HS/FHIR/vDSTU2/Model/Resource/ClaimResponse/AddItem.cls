Class HS.FHIR.vDSTU2.Model.Resource.ClaimResponse.AddItem Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ClaimResponse.AddItem";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ClaimResponse.AddItem";

/// List of input service items which this service line is intended to replace.
Property sequenceLinkId As list Of HS.FHIR.vDSTU2.Model.Datatype.PositiveInt(XMLNAME = "sequenceLinkId", XMLPROJECTION = "ELEMENT");

/// A code to indicate the Professional Service or Product supplied.
Property service As HS.FHIR.vDSTU2.Model.Base.Coding(XMLNAME = "service") [ Required ];

/// The fee charged for the professional service or product..
Property fee As HS.FHIR.vDSTU2.Model.Base.Money(XMLNAME = "fee");

/// A list of note references to the notes provided below.
Property noteNumberLinkId As list Of HS.FHIR.vDSTU2.Model.Datatype.PositiveInt(XMLNAME = "noteNumberLinkId", XMLPROJECTION = "ELEMENT");

/// The adjudications results.
Property adjudication As list Of HS.FHIR.vDSTU2.Model.Resource.ClaimResponse.Adjudication3(XMLNAME = "adjudication", XMLPROJECTION = "ELEMENT");

/// The second tier service adjudications for payor added services.
Property detail As list Of HS.FHIR.vDSTU2.Model.Resource.ClaimResponse.Detail1(XMLNAME = "detail", XMLPROJECTION = "ELEMENT");

/// Insert method for the "sequenceLinkId" property.
Method SetSequenceLinkId(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.PositiveInt).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR PositiveInt object failed") Quit
		Set tSC = ..sequenceLinkId.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "service" property.
Method SetService(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Coding).%New(pCode, pDisplay, pSystem, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Coding object failed") Quit
		Set ..service = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Insert method for the "noteNumberLinkId" property.
Method SetNoteNumberLinkId(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.PositiveInt).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR PositiveInt object failed") Quit
		Set tSC = ..noteNumberLinkId.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
