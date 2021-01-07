/// A structured set of questions and their answers. The questions are ordered and grouped into coherent subsets, corresponding to the structure of the grouping of the questionnaire being responded to.
Class HS.FHIR.vSTU3.Model.Resource.QuestionnaireResponse.Item Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "QuestionnaireResponse.Item";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "QuestionnaireResponse.Item";

Parameter JSONTYPEFIELD;

/// The item from the Questionnaire that corresponds to this item in the QuestionnaireResponse resource.
Property linkId As HS.FHIR.vSTU3.Model.Datatype.String(XMLNAME = "linkId", XMLPROJECTION = "ELEMENT") [ Required ];

/// A reference to an [[[ElementDefinition]]] that provides the details for the item.
Property definition As HS.FHIR.vSTU3.Model.Datatype.Uri(XMLNAME = "definition", XMLPROJECTION = "ELEMENT");

/// Text that is displayed above the contents of the group or as the text of the question being answered.
Property text As HS.FHIR.vSTU3.Model.Datatype.String(XMLNAME = "text", XMLPROJECTION = "ELEMENT");

/// More specific subject this section's answers are about, details the subject given in QuestionnaireResponse.
Property subject As HS.FHIR.vSTU3.Model.Base.Reference(XMLNAME = "subject", XMLPROJECTION = "ELEMENT");

/// The respondent's answer(s) to the question.
Property answer As list Of HS.FHIR.vSTU3.Model.Resource.QuestionnaireResponse.Answer(XMLNAME = "answer", XMLPROJECTION = "ELEMENT");

/// Questions or sub-groups nested beneath a question or group.
Property item As list Of HS.FHIR.vSTU3.Model.Resource.QuestionnaireResponse.Item(XMLNAME = "item", XMLPROJECTION = "ELEMENT");

/// Set method for the "linkId" property.
Method SetLinkId(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..linkId = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "definition" property.
Method SetDefinition(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Uri).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Uri object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..definition = tObj
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
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed"_$Select(err="":"",1:" - "_err)) Quit
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
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..subject = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
