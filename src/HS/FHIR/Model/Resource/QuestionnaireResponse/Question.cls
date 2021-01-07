/// *** <b>THIS CLASS IS DEPRECATED.</b> Please use HS.FHIR.<b>vDSTU2.</b>Model.Resource.QuestionnaireResponse.Question when working with FHIR DSTU2.
Class HS.FHIR.Model.Resource.QuestionnaireResponse.Question Extends HS.FHIR.Model.Base.BackboneElement [ Deprecated, ProcedureBlock ]
{

///  
Parameter JSONTYPEFIELD;

///  
Parameter ELEMENTQUALIFIED = 1;

///  
Parameter XMLNAME = "QuestionnaireResponse.Question";

///  
Parameter XMLSEQUENCE = 1;

///  
Parameter XMLTYPE = "QuestionnaireResponse.Question";

///  
Property linkId As HS.FHIR.Model.Datatype.String(XMLNAME = "linkId");

///  
Property text As HS.FHIR.Model.Datatype.String(XMLNAME = "text");

///  
Property answer As list Of HS.FHIR.Model.Resource.QuestionnaireResponse.Answer(XMLNAME = "answer", XMLPROJECTION = "ELEMENT");

///  
Method SetLinkId(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set ..linkId = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  
Method SetText(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set ..text = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
