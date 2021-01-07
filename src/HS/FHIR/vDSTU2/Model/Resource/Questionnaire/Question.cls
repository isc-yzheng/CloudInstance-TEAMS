Class HS.FHIR.vDSTU2.Model.Resource.Questionnaire.Question Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Questionnaire.Question";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Questionnaire.Question";

/// An identifier that is unique within the questionnaire allowing linkage to the equivalent group in a [[[QuestionnaireResponse]]] resource.
Property linkId As HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "linkId");

/// Identifies a how this question is known in a particular terminology such as LOINC.
Property concept As list Of HS.FHIR.vDSTU2.Model.Base.Coding(XMLNAME = "concept", XMLPROJECTION = "ELEMENT");

/// The actual question as shown to the user to prompt them for an answer.
Property text As HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "text");

/// The expected format of the answer, e.g. the type of input (string, integer) or whether a (multiple) choice is expected.
Property type As HS.FHIR.vDSTU2.Model.Base.AnswerFormat(XMLNAME = "type");

/// If true, indicates that the question must be answered and have required groups within it also present.  If false, the question and any contained groups may be skipped when answering the questionnaire.
Property required As HS.FHIR.vDSTU2.Model.Datatype.Boolean(XMLNAME = "required");

/// If true, the question may have more than one answer.
Property repeats As HS.FHIR.vDSTU2.Model.Datatype.Boolean(XMLNAME = "repeats");

/// Reference to a value set containing a list of codes representing permitted answers for the question.
Property options As HS.FHIR.vDSTU2.Model.Base.Reference(XMLNAME = "options");

/// For a"choice" question, identifies one of the permitted answers for the question.
Property option As list Of HS.FHIR.vDSTU2.Model.Base.Coding(XMLNAME = "option", XMLPROJECTION = "ELEMENT") [ SqlFieldName = _option ];

/// Nested group, containing nested question for this question. The order of groups within the question is relevant.
Property group As list Of HS.FHIR.vDSTU2.Model.Resource.Questionnaire.Group(XMLNAME = "group", XMLPROJECTION = "ELEMENT") [ SqlFieldName = _group ];

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

/// Insert method for the "concept" property.
Method SetConcept(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Coding).%New(pCode, pDisplay, pSystem, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Coding object failed") Quit
		Set tSC = ..concept.Insert(tObj) Quit:$$$ISERR(tSC)
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

/// Set method for the "type" property.
Method SetType(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.AnswerFormat).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR AnswerFormat object failed") Quit
		Set ..type = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "required" property.
Method SetRequired(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Boolean).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Boolean object failed") Quit
		Set ..required = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "repeats" property.
Method SetRepeats(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Boolean).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Boolean object failed") Quit
		Set ..repeats = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "options" property.
Method SetOptions(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed") Quit
		Set ..options = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Insert method for the "option" property.
Method SetOption(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Coding).%New(pCode, pDisplay, pSystem, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Coding object failed") Quit
		Set tSC = ..option.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
