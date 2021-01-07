/// *** <b>THIS CLASS IS DEPRECATED.</b> Please use HS.FHIR.<b>vDSTU2.</b>Model.Resource.ClaimResponse.Detail1 when working with FHIR DSTU2.
Class HS.FHIR.Model.Resource.ClaimResponse.Detail1 Extends HS.FHIR.Model.Base.BackboneElement [ Deprecated, ProcedureBlock ]
{

///  
Parameter JSONTYPEFIELD;

///  
Parameter ELEMENTQUALIFIED = 1;

///  
Parameter XMLNAME = "ClaimResponse.Detail1";

///  
Parameter XMLSEQUENCE = 1;

///  
Parameter XMLTYPE = "ClaimResponse.Detail1";

///  
Property service As HS.FHIR.Model.Base.Coding(XMLNAME = "service") [ Required ];

///  
Property fee As HS.FHIR.Model.Base.Money(XMLNAME = "fee");

///  
Property adjudication As list Of HS.FHIR.Model.Resource.ClaimResponse.Adjudication4(XMLNAME = "adjudication", XMLPROJECTION = "ELEMENT");

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

}
