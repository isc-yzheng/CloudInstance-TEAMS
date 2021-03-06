/// Used to record and send details about a request for referral service or transfer of a patient to the care of another provider or provider organization.
Class HS.FHIR.vSTU3.Model.Resource.ReferralRequest.Requester Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ReferralRequest.Requester";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ReferralRequest.Requester";

Parameter JSONTYPEFIELD;

/// The device, practitioner, etc. who initiated the request.
Property agent As HS.FHIR.vSTU3.Model.Base.Reference(XMLNAME = "agent", XMLPROJECTION = "ELEMENT") [ Required ];

/// The organization the device or practitioner was acting on behalf of.
Property onBehalfOf As HS.FHIR.vSTU3.Model.Base.Reference(XMLNAME = "onBehalfOf", XMLPROJECTION = "ELEMENT");

/// Set method for the "agent" property.
Method SetAgent(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..agent = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "onBehalfOf" property.
Method SetOnBehalfOf(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..onBehalfOf = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
