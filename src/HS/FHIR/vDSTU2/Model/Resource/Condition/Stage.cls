Class HS.FHIR.vDSTU2.Model.Resource.Condition.Stage Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Condition.Stage";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Condition.Stage";

/// A simple summary of the stage such as"Stage 3". The determination of the stage is disease-specific.
Property summary As HS.FHIR.vDSTU2.Model.Base.CodeableConcept(XMLNAME = "summary");

/// Reference to a formal record of the evidence on which the staging assessment is based.
Property assessment As list Of HS.FHIR.vDSTU2.Model.Base.Reference(XMLNAME = "assessment", XMLPROJECTION = "ELEMENT");

/// Set method for the "summary" property.
Method SetSummary(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed") Quit
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
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed") Quit
		Set tSC = ..assessment.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
