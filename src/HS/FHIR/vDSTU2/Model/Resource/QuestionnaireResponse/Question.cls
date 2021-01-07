Class HS.FHIR.vDSTU2.Model.Resource.QuestionnaireResponse.Question Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "QuestionnaireResponse.Question";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "QuestionnaireResponse.Question";

/// Identifies the question from the Questionnaire that corresponds to this question in the QuestionnaireResponse resource.
Property linkId As HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "linkId");

/// The actual question as shown to the user to prompt them for an answer.
Property text As HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "text");

/// The respondent's answer(s) to the question.
Property answer As list Of HS.FHIR.vDSTU2.Model.Resource.QuestionnaireResponse.Answer(XMLNAME = "answer", XMLPROJECTION = "ELEMENT");

/// Set method for the "linkId" property.
Method SetLinkId(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set ..linkId = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "text" property.
Method SetText(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set ..text = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
