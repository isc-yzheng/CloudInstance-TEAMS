Class HS.FHIR.vDSTU2.Model.Base.Identifier Extends HS.FHIR.vDSTU2.Model.Base.Element [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Identifier";

Parameter XMLSEQUENCE = 1;

/// The purpose of this identifier.
Property use As HS.FHIR.vDSTU2.Model.Base.IdentifierUse(XMLNAME = "use");

/// A coded type for the identifier that can be used to determine which identifier to use for a specific purpose.
Property type As HS.FHIR.vDSTU2.Model.Base.CodeableConcept(XMLNAME = "type");

/// Establishes the namespace in which set of possible id values is unique.
Property system As HS.FHIR.vDSTU2.Model.Datatype.Uri(XMLNAME = "system");

/// The portion of the identifier typically displayed to the user and which is unique within the context of the system.
Property value As HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "value");

/// Time period during which identifier is/was valid for use.
Property period As HS.FHIR.vDSTU2.Model.Base.Period(XMLNAME = "period");

/// Organization that issued/manages the identifier.
Property assigner As HS.FHIR.vDSTU2.Model.Base.Reference(XMLNAME = "assigner");

/// Set method for the "use" property.
Method SetUse(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.IdentifierUse).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR IdentifierUse object failed") Quit
		Set ..use = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "type" property.
Method SetType(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed") Quit
		Set ..type = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "system" property.
Method SetSystem(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Uri).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Uri object failed") Quit
		Set ..system = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "value" property.
Method SetValue(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set ..value = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "period" property.
Method SetPeriod(pStart As %String = "", pEnd As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Period).%New(pStart, pEnd, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Period object failed") Quit
		Set ..period = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "assigner" property.
Method SetAssigner(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed") Quit
		Set ..assigner = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Get new object, populated with specified data.
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
