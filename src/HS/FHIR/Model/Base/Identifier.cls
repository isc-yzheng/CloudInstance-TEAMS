/// *** <b>THIS CLASS IS DEPRECATED.</b> Please use HS.FHIR.<b>vDSTU2.</b>Model.Base.Identifier when working with FHIR DSTU2.
Class HS.FHIR.Model.Base.Identifier Extends HS.FHIR.Model.Base.Element [ Deprecated, ProcedureBlock ]
{

///  
Parameter JSONTYPEFIELD;

///  
Parameter ELEMENTQUALIFIED = 1;

///  
Parameter XMLNAME = "Identifier";

///  
Parameter XMLSEQUENCE = 1;

///  
Property use As HS.FHIR.Model.Base.IdentifierUse(XMLNAME = "use");

///  
Property type As HS.FHIR.Model.Base.CodeableConcept(XMLNAME = "type");

///  
Property system As HS.FHIR.Model.Datatype.Uri(XMLNAME = "system");

///  
Property value As HS.FHIR.Model.Datatype.String(XMLNAME = "value");

///  
Property period As HS.FHIR.Model.Base.Period(XMLNAME = "period");

///  
Property assigner As HS.FHIR.Model.Base.Reference(XMLNAME = "assigner");

///  
Method SetUse(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Base.IdentifierUse).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR IdentifierUse object failed") Quit
		Set ..use = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  
Method SetType(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed") Quit
		Set ..type = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  
Method SetSystem(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Datatype.Uri).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Uri object failed") Quit
		Set ..system = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  
Method SetValue(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set ..value = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  
Method SetPeriod(pStart As %String = "", pEnd As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Base.Period).%New(pStart, pEnd, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Period object failed") Quit
		Set ..period = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  
Method SetAssigner(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed") Quit
		Set ..assigner = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  
Method %OnNew(pValue As %String, pSystem As %String, pUse As %String, pTypeCode As %String, pTypeSystem As %String, pTypeDisplay As %String, pTypeText As %String, pId As %String, pStart As %String, pEnd As %String, pAssignerReference As %String, pAssignerDisplay As %String, pExtension As %RegisteredObject) As %Status
{
	Set tSC = $$$OK
	Try {
		If ($Data(pValue)=0)&&($Data(pSystem)=0)&&($Data(pUse)=0)&&($Data(pTypeCode)=0)&&($Data(pTypeSystem)=0)&&($Data(pTypeDisplay)=0)&&($Data(pTypeText)=0)&&($Data(pId)=0)&&($Data(pStart)=0)&&($Data(pEnd)=0)&&($Data(passignerReference)=0)&&($Data(pAssignerDisplay)=0)&&($Data(pExtension)=0) Quit
		If $Get(pUse)'="" Set tSC = ..SetUse(pUse) Quit:$$$ISERR(tSC)
		If ($Get(pTypeCode)'="")||($Get(pTypeDisplay)'="")||($Get(pTypeSystem)'="")||($Get(pTypeText)'="") Set tSC = ..SetType($Get(pTypeCode), $Get(pTypeDisplay), $Get(pTypeSystem), $Get(pTypeText)) Quit:$$$ISERR(tSC)
		If $Get(pSystem)'="" Set tSC = ..SetSystem(pSystem) Quit:$$$ISERR(tSC)
		If $Get(pValue)'="" Set tSC = ..SetValue(pValue) Quit:$$$ISERR(tSC)
		If ($Get(pStart)'="")||($Get(pEnd)'="") Set tSC = ..SetPeriod($Get(pStart), $Get(pEnd)) Quit:$$$ISERR(tSC)
		If ($Get(pAssignerReference)'="")||($Get(pAssignerDisplay)'="") Set tSC = ..SetAssigner($Get(pAssignerReference), $Get(pAssignerDisplay)) Quit:$$$ISERR(tSC)
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
