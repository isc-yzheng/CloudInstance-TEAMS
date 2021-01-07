/// A concept that may be defined by a formal reference to a terminology or ontology or may be provided by text.<br>
/// If the element is present, it must have a value for at least one of the defined elements, an @id referenced from the Narrative, or extensions
Class HS.FHIR.vSTU3.Model.Base.CodeableConcept Extends HS.FHIR.vSTU3.Model.Base.Element [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "CodeableConcept";

Parameter XMLSEQUENCE = 1;

Parameter JSONTYPEFIELD;

/// A reference to a code defined by a terminology system.
Property coding As list Of HS.FHIR.vSTU3.Model.Base.Coding(XMLNAME = "coding", XMLPROJECTION = "ELEMENT");

/// A human language representation of the concept as seen/selected/uttered by the user who entered the data and/or which represents the intended meaning of the user.
Property text As HS.FHIR.vSTU3.Model.Datatype.String(XMLNAME = "text", XMLPROJECTION = "ELEMENT");

/// Insert method for the "coding" property.
Method SetCoding(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Coding).%New(pCode, pDisplay, pSystem, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Coding object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set tSC = ..coding.Insert(tObj) Quit:$$$ISERR(tSC)
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

/// Get new object, populated with specified data.
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
			} ElseIf pExtension.Count()>0 {
				For i = 1:1:pExtension.Count() {
					Set tSC = ..extension.Insert(pExtension.GetAt(i)) Quit:$$$ISERR(tSC)
				}
			}
			Quit:$$$ISERR(tSC)
		}
		Set tSC = ..%ValidateObject()
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
