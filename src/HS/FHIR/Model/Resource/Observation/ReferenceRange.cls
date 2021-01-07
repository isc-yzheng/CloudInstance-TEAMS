/// *** <b>THIS CLASS IS DEPRECATED.</b> Please use HS.FHIR.<b>vDSTU2.</b>Model.Resource.Observation.ReferenceRange when working with FHIR DSTU2.
Class HS.FHIR.Model.Resource.Observation.ReferenceRange Extends HS.FHIR.Model.Base.BackboneElement [ Deprecated, ProcedureBlock ]
{

///  
Parameter JSONTYPEFIELD;

///  
Parameter ELEMENTQUALIFIED = 1;

///  
Parameter XMLNAME = "Observation.ReferenceRange";

///  
Parameter XMLSEQUENCE = 1;

///  
Parameter XMLTYPE = "Observation.ReferenceRange";

///  
Property low As HS.FHIR.Model.Base.SimpleQuantity(XMLNAME = "low");

///  
Property high As HS.FHIR.Model.Base.SimpleQuantity(XMLNAME = "high");

///  
Property meaning As HS.FHIR.Model.Base.CodeableConcept(XMLNAME = "meaning");

///  
Property age As HS.FHIR.Model.Base.Range(XMLNAME = "age");

///  
Property text As HS.FHIR.Model.Datatype.String(XMLNAME = "text");

///  
Method SetMeaning(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed") Quit
		Set ..meaning = tObj
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
