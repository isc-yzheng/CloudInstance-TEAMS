/// *** <b>THIS CLASS IS DEPRECATED.</b> Please use HS.FHIR.<b>vDSTU2.</b>Model.Resource.ClaimResponse.AddItem when working with FHIR DSTU2.
Class HS.FHIR.Model.Resource.ClaimResponse.AddItem Extends HS.FHIR.Model.Base.BackboneElement [ Deprecated, ProcedureBlock ]
{

///  
Parameter JSONTYPEFIELD;

///  
Parameter ELEMENTQUALIFIED = 1;

///  
Parameter XMLNAME = "ClaimResponse.AddItem";

///  
Parameter XMLSEQUENCE = 1;

///  
Parameter XMLTYPE = "ClaimResponse.AddItem";

///  
Property sequenceLinkId As list Of HS.FHIR.Model.Datatype.PositiveInt(XMLNAME = "sequenceLinkId", XMLPROJECTION = "ELEMENT");

///  
Property service As HS.FHIR.Model.Base.Coding(XMLNAME = "service") [ Required ];

///  
Property fee As HS.FHIR.Model.Base.Money(XMLNAME = "fee");

///  
Property noteNumberLinkId As list Of HS.FHIR.Model.Datatype.PositiveInt(XMLNAME = "noteNumberLinkId", XMLPROJECTION = "ELEMENT");

///  
Property adjudication As list Of HS.FHIR.Model.Resource.ClaimResponse.Adjudication3(XMLNAME = "adjudication", XMLPROJECTION = "ELEMENT");

///  
Property detail As list Of HS.FHIR.Model.Resource.ClaimResponse.Detail1(XMLNAME = "detail", XMLPROJECTION = "ELEMENT");

///  
Method SetSequenceLinkId(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Datatype.PositiveInt).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR PositiveInt object failed") Quit
		Set tSC = ..sequenceLinkId.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  
Method SetService(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Base.Coding).%New(pCode, pDisplay, pSystem, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Coding object failed") Quit
		Set ..service = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  
Method SetNoteNumberLinkId(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Datatype.PositiveInt).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR PositiveInt object failed") Quit
		Set tSC = ..noteNumberLinkId.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
