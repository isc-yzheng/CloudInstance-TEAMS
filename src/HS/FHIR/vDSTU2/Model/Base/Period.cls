Class HS.FHIR.vDSTU2.Model.Base.Period Extends HS.FHIR.vDSTU2.Model.Base.Element [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Period";

Parameter XMLSEQUENCE = 1;

/// The start of the period. The boundary is inclusive.
Property start As HS.FHIR.vDSTU2.Model.Datatype.DateTime(XMLNAME = "start");

/// The end of the period. If the end of the period is missing, it means that the period is ongoing. The start may be in the past, and the end date in the future, which means that period is expected/planned to end at that time.
Property end As HS.FHIR.vDSTU2.Model.Datatype.DateTime(XMLNAME = "end") [ SqlFieldName = _end ];

/// Set method for the "start" property.
Method SetStart(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.DateTime).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR DateTime object failed") Quit
		Set ..start = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "end" property.
Method SetEnd(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.DateTime).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR DateTime object failed") Quit
		Set ..end = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Get new object, populated with specified data.
Method %OnNew(pStart As %String, pEnd As %String, pExtension As %RegisteredObject) As %Status
{
	Set tSC = $$$OK
	Try {
		If ($Data(pStart)=0)&&($Data(pEnd)=0)&&($Data(pExtension)=0) Quit
		If $Get(pStart)'="" Set tSC = ..SetStart(pStart) Quit:$$$ISERR(tSC)
		If $Get(pEnd)'="" Set tSC = ..SetEnd(pEnd) Quit:$$$ISERR(tSC)
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
