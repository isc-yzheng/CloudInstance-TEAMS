/// *** <b>THIS CLASS IS DEPRECATED.</b> Please use HS.FHIR.<b>vDSTU2.</b>Model.Base.CodeableConcept when working with FHIR DSTU2.
Class HS.FHIR.Model.Base.CodeableConcept Extends HS.FHIR.Model.Base.Element [ Deprecated, ProcedureBlock ]
{

///  
Parameter JSONTYPEFIELD;

///  
Parameter ELEMENTQUALIFIED = 1;

///  
Parameter XMLNAME = "CodeableConcept";

///  
Parameter XMLSEQUENCE = 1;

///  
Property coding As list Of HS.FHIR.Model.Base.Coding(XMLNAME = "coding", XMLPROJECTION = "ELEMENT");

///  
Property text As HS.FHIR.Model.Datatype.String(XMLNAME = "text");

///  
Method SetCoding(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Base.Coding).%New(pCode, pDisplay, pSystem, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Coding object failed") Quit
		Set tSC = ..coding.Insert(tObj) Quit:$$$ISERR(tSC)
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

///  
Method %OnNew(pCode As %String, pDisplay As %String, pSystem As %String, pText As %String, pVersion As %String, pUserSelected As %String, pId As %String, pExtension As %RegisteredObject) As %Status
{
	Set tSC = $$$OK
	Try {
		If ($Data(pCode)=0)&&($Data(pDisplay)=0)&&($Data(pSystem)=0)&&($Data(pText)=0)&&($Data(pVersion)=0)&&($Data(pUserSelected)=0)&&($Data(pId)=0)&&($Data(pExtension)=0) Quit
		If ($Get(pCode)'="")||($Get(pDisplay)'="") Set tSC = ..SetCoding($Get(pCode), $Get(pDisplay), $Get(pSystem), $Get(pVersion), $Get(pUserSelected), $Get(pId)) Quit:$$$ISERR(tSC)
		If $Get(pText)="" Set pText = $Get(pDisplay)
		If $Get(pText)'="" Set tSC = ..SetText(pText) Quit:$$$ISERR(tSC)
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
