/// This resource provides eligibility and plan details from the processing of an Eligibility resource.
Class HS.FHIR.vSTU3.Model.Resource.EligibilityResponse.Error Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "EligibilityResponse.Error";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "EligibilityResponse.Error";

Parameter JSONTYPEFIELD;

/// An error code,from a specified code system, which details why the eligibility check could not be performed.
Property code As HS.FHIR.vSTU3.Model.Base.CodeableConcept(XMLNAME = "code", XMLPROJECTION = "ELEMENT") [ Required ];

/// Set method for the "code" property.
Method SetCode(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..code = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
