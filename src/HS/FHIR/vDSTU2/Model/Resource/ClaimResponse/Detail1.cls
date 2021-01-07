Class HS.FHIR.vDSTU2.Model.Resource.ClaimResponse.Detail1 Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ClaimResponse.Detail1";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ClaimResponse.Detail1";

/// A code to indicate the Professional Service or Product supplied.
Property service As HS.FHIR.vDSTU2.Model.Base.Coding(XMLNAME = "service") [ Required ];

/// The fee charged for the professional service or product..
Property fee As HS.FHIR.vDSTU2.Model.Base.Money(XMLNAME = "fee");

/// The adjudications results.
Property adjudication As list Of HS.FHIR.vDSTU2.Model.Resource.ClaimResponse.Adjudication4(XMLNAME = "adjudication", XMLPROJECTION = "ELEMENT");

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

}
