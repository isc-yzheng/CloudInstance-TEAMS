Class HS.FHIR.vDSTU2.Model.Resource.Questionnaire.Group Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Questionnaire.Group";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Questionnaire.Group";

/// An identifier that is unique within the Questionnaire allowing linkage to the equivalent group in a QuestionnaireResponse resource.
Property linkId As HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "linkId");

/// The human-readable name for this section of the questionnaire.
Property title As HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "title");

/// Identifies a how this group of questions is known in a particular terminology such as LOINC.
Property concept As list Of HS.FHIR.vDSTU2.Model.Base.Coding(XMLNAME = "concept", XMLPROJECTION = "ELEMENT");

/// Additional text for the group, used for display purposes.
Property text As HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "text");

/// If true, indicates that the group must be present and have required questions within it answered.  If false, the group may be skipped when answering the questionnaire.
Property required As HS.FHIR.vDSTU2.Model.Datatype.Boolean(XMLNAME = "required");

/// Whether the group may occur multiple times in the instance, containing multiple sets of answers.
Property repeats As HS.FHIR.vDSTU2.Model.Datatype.Boolean(XMLNAME = "repeats");

/// A sub-group within a group. The ordering of groups within this group is relevant.
Property group As list Of HS.FHIR.vDSTU2.Model.Resource.Questionnaire.Group(XMLNAME = "group", XMLPROJECTION = "ELEMENT") [ SqlFieldName = _group ];

/// Set of questions within this group. The order of questions within the group is relevant.
Property question As list Of HS.FHIR.vDSTU2.Model.Resource.Questionnaire.Question(XMLNAME = "question", XMLPROJECTION = "ELEMENT");

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

/// Set method for the "title" property.
Method SetTitle(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set ..title = tObj
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

}
