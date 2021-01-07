/// A human-readable formatted text, including images.<br>
/// If the element is present, it must have a value for at least one of the defined elements, an @id referenced from the Narrative, or extensions
Class HS.FHIR.vSTU3.Model.Base.Narrative Extends HS.FHIR.vSTU3.Model.Base.Element [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Narrative";

Parameter XMLSEQUENCE = 1;

Parameter JSONTYPEFIELD;

/// The status of the narrative - whether it's entirely generated (from just the defined data or the extensions too), or whether a human authored it and it may contain additional data.
Property status As HS.FHIR.vSTU3.Model.Base.NarrativeStatus(XMLNAME = "status", XMLPROJECTION = "ELEMENT") [ Required ];

/// The actual narrative content, a stripped down version of XHTML.
Property div As %String(MAXLEN = 1000000, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://www.w3.org/1999/xhtml", XMLNAME = "div", XMLPROJECTION = "ELEMENT", XMLREF = 1) [ Required ];

/// Set method for the "status" property.
Method SetStatus(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.NarrativeStatus).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR NarrativeStatus object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..status = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Get new object, populated with specified data.
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
