Class HS.FHIR.vDSTU2.Model.Base.ContactPoint Extends HS.FHIR.vDSTU2.Model.Base.Element [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ContactPoint";

Parameter XMLSEQUENCE = 1;

/// Telecommunications form for contact point - what communications system is required to make use of the contact.
Property system As HS.FHIR.vDSTU2.Model.Base.ContactPointSystem(XMLNAME = "system");

/// The actual contact point details, in a form that is meaningful to the designated communication system (i.e. phone number or email address).
Property value As HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "value");

/// Identifies the purpose for the contact point.
Property use As HS.FHIR.vDSTU2.Model.Base.ContactPointUse(XMLNAME = "use");

/// Specifies a preferred order in which to use a set of contacts. Contacts are ranked with lower values coming before higher values.
Property rank As HS.FHIR.vDSTU2.Model.Datatype.PositiveInt(XMLNAME = "rank");

/// Time period when the contact point was/is in use.
Property period As HS.FHIR.vDSTU2.Model.Base.Period(XMLNAME = "period");

/// Set method for the "system" property.
Method SetSystem(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.ContactPointSystem).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR ContactPointSystem object failed") Quit
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

/// Set method for the "use" property.
Method SetUse(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.ContactPointUse).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR ContactPointUse object failed") Quit
		Set ..use = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "rank" property.
Method SetRank(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.PositiveInt).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR PositiveInt object failed") Quit
		Set ..rank = tObj
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

/// Get new object, populated with specified data.
Method %OnNew(pValue As %String, pSystem As %String, pUse As %String, pRank As %String, pStart As %String, pEnd As %String, pExtension As %RegisteredObject) As %Status
{
	Set tSC = $$$OK
	Try {
		If ($Data(pValue)=0)&&($Data(pSystem)=0)&&($Data(pUse)=0)&&($Data(pRank)=0)&&($Data(pStart)=0)&&($Data(pEnd)=0)&&($Data(pExtension)=0) Quit
		If $Get(pValue)'="" Set tSC = ..SetValue(pValue) Quit:$$$ISERR(tSC)
		If $Get(pSystem)'="" Set tSC = ..SetSystem(pSystem) Quit:$$$ISERR(tSC)
		If $Get(pUse)'="" Set tSC = ..SetUse(pUse) Quit:$$$ISERR(tSC)
		If $Get(pRank)'="" Set tSC = ..SetRank(pRank) Quit:$$$ISERR(tSC)
		If ($Get(pStart)'="")||($Get(pEnd)'="") Set tSC = ..SetPeriod($Get(pStart), $Get(pEnd)) Quit:$$$ISERR(tSC)
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
