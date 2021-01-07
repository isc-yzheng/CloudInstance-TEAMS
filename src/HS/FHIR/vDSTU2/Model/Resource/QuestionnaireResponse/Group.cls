Class HS.FHIR.vDSTU2.Model.Resource.QuestionnaireResponse.Group Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "QuestionnaireResponse.Group";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "QuestionnaireResponse.Group";

/// Identifies the group from the Questionnaire that corresponds to this group in the QuestionnaireResponse resource.
Property linkId As HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "linkId");

/// Text that is displayed above the contents of the group.
Property title As HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "title");

/// Additional text for the group, used for display purposes.
Property text As HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "text");

/// More specific subject this section's answers are about, details the subject given in QuestionnaireResponse.
Property subject As HS.FHIR.vDSTU2.Model.Base.Reference(XMLNAME = "subject");

/// A sub-group within a group. The ordering of groups within this group is relevant.
Property group As list Of HS.FHIR.vDSTU2.Model.Resource.QuestionnaireResponse.Group(XMLNAME = "group", XMLPROJECTION = "ELEMENT") [ SqlFieldName = _group ];

/// Set of questions within this group. The order of questions within the group is relevant.
Property question As list Of HS.FHIR.vDSTU2.Model.Resource.QuestionnaireResponse.Question(XMLNAME = "question", XMLPROJECTION = "ELEMENT");

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

/// Set method for the "subject" property.
Method SetSubject(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed") Quit
		Set ..subject = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
