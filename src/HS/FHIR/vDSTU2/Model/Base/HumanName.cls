Class HS.FHIR.vDSTU2.Model.Base.HumanName Extends HS.FHIR.vDSTU2.Model.Base.Element [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "HumanName";

Parameter XMLSEQUENCE = 1;

/// Identifies the purpose for this name.
Property use As HS.FHIR.vDSTU2.Model.Base.NameUse(XMLNAME = "use");

/// A full text representation of the name.
Property text As HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "text");

/// The part of a name that links to the genealogy. In some cultures (e.g. Eritrea) the family name of a son is the first name of his father.
Property family As list Of HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "family", XMLPROJECTION = "ELEMENT");

/// Given name.
Property given As list Of HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "given", XMLPROJECTION = "ELEMENT");

/// Part of the name that is acquired as a title due to academic, legal, employment or nobility status, etc. and that appears at the start of the name.
Property prefix As list Of HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "prefix", XMLPROJECTION = "ELEMENT");

/// Part of the name that is acquired as a title due to academic, legal, employment or nobility status, etc. and that appears at the end of the name.
Property suffix As list Of HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "suffix", XMLPROJECTION = "ELEMENT");

/// Indicates the period of time when this name was valid for the named person.
Property period As HS.FHIR.vDSTU2.Model.Base.Period(XMLNAME = "period");

/// Set method for the "use" property.
Method SetUse(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.NameUse).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR NameUse object failed") Quit
		Set ..use = tObj
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
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set ..text = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Insert method for the "family" property.
Method SetFamily(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set tSC = ..family.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Insert method for the "given" property.
Method SetGiven(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set tSC = ..given.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Insert method for the "prefix" property.
Method SetPrefix(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set tSC = ..prefix.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Insert method for the "suffix" property.
Method SetSuffix(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set tSC = ..suffix.Insert(tObj) Quit:$$$ISERR(tSC)
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
Method %OnNew(pLastName As %String, pFirstName As %String, pMiddleName As %String, pPrefix As %String, pSuffix As %String, pUse As %String, pText As %String, pStart As %String, pEnd As %String, pId As %String, pExtension As %RegisteredObject) As %Status
{
	Set tSC = $$$OK
	Try {
		If ($Data(pLastName)=0)&&($Data(pFirstName)=0)&&($Data(pMiddleName)=0)&&($Data(pPrefix)=0)&&($Data(pSuffix)=0)&&($Data(pUse)=0)&&($Data(pText)=0)&&($Data(pStart)=0)&&($Data(pEnd)=0)&&($Data(pId)=0)&&($Data(pExtension)=0) Quit
		If $Get(pLastName)'="" Set tSC = ..SetFamily(pLastName) Quit:$$$ISERR(tSC)
		If $Get(pFirstName)'="" Set tSC = ..SetGiven(pFirstName) Quit:$$$ISERR(tSC)
		If $Get(pMiddleName)'="" Set tSC = ..SetGiven(pMiddleName) Quit:$$$ISERR(tSC)
		If $Get(pPrefix)'="" Set tSC = ..SetPrefix(pPrefix) Quit:$$$ISERR(tSC)
		If $Get(pSuffix)'="" Set tSC = ..SetSuffix(pSuffix) Quit:$$$ISERR(tSC)
		If $Get(pUse)'="" Set tSC = ..SetUse(pUse) Quit:$$$ISERR(tSC)
		If $Get(pText)'="" Set tSC = ..SetText(pText) Quit:$$$ISERR(tSC)
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
