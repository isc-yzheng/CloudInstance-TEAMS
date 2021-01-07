/// *** <b>THIS CLASS IS DEPRECATED.</b> Please use HS.FHIR.<b>vDSTU2.</b>Model.Base.Narrative when working with FHIR DSTU2.
Class HS.FHIR.Model.Base.Narrative Extends HS.FHIR.Model.Base.Element [ Deprecated, ProcedureBlock ]
{

///  
Parameter JSONTYPEFIELD;

///  
Parameter ELEMENTQUALIFIED = 1;

///  
Parameter XMLNAME = "Narrative";

///  
Parameter XMLSEQUENCE = 1;

///  
Property status As HS.FHIR.Model.Base.NarrativeStatus(XMLNAME = "status") [ Required ];

///  
Property div As %String(MAXLEN = 1000000, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://www.w3.org/1999/xhtml", XMLNAME = "div", XMLREF = 1) [ Required ];

///  
Method SetStatus(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Base.NarrativeStatus).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR NarrativeStatus object failed") Quit
		Set ..status = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  
Method %OnNew(pStatus As %String, pDiv As %String) As %Status
{
	Set tSC = $$$OK
	Try {
		If ($Data(pStatus)=0)&&($Data(pDiv)=0) Quit
		If $Get(pStatus)'="" Set tSC = ..SetStatus(pStatus) Quit:$$$ISERR(tSC)
		If $Get(pDiv)'="" Set ..div = pDiv
		#; pExtension may be a single Extension object or a collection of Extension objects.
		If $IsObject($Get(pExtension)) {
			If (pExtension.%Extends("%Collection.ListOfObj")=0)&&(pExtension.%Extends("%Library.ListOfObjects")=0) {
				Set tSC = ..extension.Insert(pExtension) Quit:$$$ISERR(tSC)
			} Else {
				Set ..extension = pExtension
			}
		}
		Set tSC = ..%ValidateObject()
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
