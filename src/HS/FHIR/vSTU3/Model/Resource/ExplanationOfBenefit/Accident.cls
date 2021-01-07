/// This resource provides: the claim details; adjudication details from the processing of a Claim; and optionally account balance information, for informing the subscriber of the benefits provided.
Class HS.FHIR.vSTU3.Model.Resource.ExplanationOfBenefit.Accident Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ExplanationOfBenefit.Accident";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ExplanationOfBenefit.Accident";

Parameter JSONTYPEFIELD;

/// Date of an accident which these services are addressing.
Property date As HS.FHIR.vSTU3.Model.Datatype.Date(XMLNAME = "date", XMLPROJECTION = "ELEMENT");

/// Type of accident: work, auto, etc.
Property type As HS.FHIR.vSTU3.Model.Base.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

Property locationAddress As HS.FHIR.vSTU3.Model.Base.Address(XMLNAME = "locationAddress", XMLPROJECTION = "ELEMENT");

Property locationReference As HS.FHIR.vSTU3.Model.Base.Reference(XMLNAME = "locationReference", XMLPROJECTION = "ELEMENT");

/// Set method for the "date" property.
Method SetDate(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Date).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Date object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..date = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "type" property.
Method SetType(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..type = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "locationReference" property.
Method SetLocationReference(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..locationReference = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
