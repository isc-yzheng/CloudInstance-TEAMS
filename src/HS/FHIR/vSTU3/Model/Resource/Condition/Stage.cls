/// A clinical condition, problem, diagnosis, or other event, situation, issue, or clinical concept that has risen to a level of concern.
Class HS.FHIR.vSTU3.Model.Resource.Condition.Stage Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Condition.Stage";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Condition.Stage";

Parameter JSONTYPEFIELD;

/// A simple summary of the stage such as "Stage 3". The determination of the stage is disease-specific.
Property summary As HS.FHIR.vSTU3.Model.Base.CodeableConcept(XMLNAME = "summary", XMLPROJECTION = "ELEMENT");

/// Reference to a formal record of the evidence on which the staging assessment is based.
Property assessment As list Of HS.FHIR.vSTU3.Model.Base.Reference(XMLNAME = "assessment", XMLPROJECTION = "ELEMENT");

/// Set method for the "summary" property.
Method SetSummary(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..summary = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Insert method for the "assessment" property.
Method SetAssessment(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set tSC = ..assessment.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
