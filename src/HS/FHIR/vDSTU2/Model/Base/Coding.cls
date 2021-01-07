Class HS.FHIR.vDSTU2.Model.Base.Coding Extends HS.FHIR.vDSTU2.Model.Base.Element [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Coding";

Parameter XMLSEQUENCE = 1;

/// The identification of the code system that defines the meaning of the symbol in the code.
Property system As HS.FHIR.vDSTU2.Model.Datatype.Uri(XMLNAME = "system");

/// The version of the code system which was used when choosing this code. Note that a well-maintained code system does not need the version reported, because the meaning of codes is consistent across versions. However this cannot consistently be assured. and when the meaning is not guaranteed to be consistent, the version SHOULD be exchanged.
Property version As HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "version");

/// A symbol in syntax defined by the system. The symbol may be a predefined code or an expression in a syntax defined by the coding system (e.g. post-coordination).
Property code As HS.FHIR.vDSTU2.Model.Datatype.Code(XMLNAME = "code");

/// A representation of the meaning of the code in the system, following the rules of the system.
Property display As HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "display");

/// Indicates that this coding was chosen by a user directly - i.e. off a pick list of available items (codes or displays).
Property userSelected As HS.FHIR.vDSTU2.Model.Datatype.Boolean(XMLNAME = "userSelected");

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

/// Set method for the "version" property.
Method SetVersion(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set ..version = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "code" property.
Method SetCode(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Code).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Code object failed") Quit
		Set ..code = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "display" property.
Method SetDisplay(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set ..display = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "userSelected" property.
Method SetUserSelected(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Boolean).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Boolean object failed") Quit
		Set ..userSelected = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Get new object, populated with specified data.
Method %OnNew(pCode As %String, pDisplay As %String, pSystem As %String, pVersion As %String, pUserSelected As %String, pId As %String, pExtension As %RegisteredObject) As %Status
{
	Set tSC = $$$OK
	Try {
		If ($Data(pCode)=0)&&($Data(pDisplay)=0)&&($Data(pSystem)=0)&&($Data(pVersion)=0)&&($Data(pUserSelected)=0)&&($Data(pId)=0)&&($Data(pExtension)=0) Quit
		If $Get(pCode)'="" Set tSC = ..SetCode(pCode) Quit:$$$ISERR(tSC)
		If $Get(pDisplay)'="" Set tSC = ..SetDisplay(pDisplay) Quit:$$$ISERR(tSC)
		If $Get(pSystem)'="" Set tSC = ..SetSystem(pSystem) Quit:$$$ISERR(tSC)
		If $Get(pVersion)'="" Set tSC = ..SetVersion(pVersion) Quit:$$$ISERR(tSC)
		If $Get(pUserSelected)'="" Set tSC = ..SetUserSelected(pUserSelected) Quit:$$$ISERR(tSC)
		If $Get(pId)'="" Set ..id = pId Quit:$$$ISERR(tSC)
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
