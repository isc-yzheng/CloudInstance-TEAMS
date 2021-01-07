Class HS.FHIR.vDSTU2.Model.Base.Quantity Extends HS.FHIR.vDSTU2.Model.Base.Element [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Quantity";

Parameter XMLSEQUENCE = 1;

/// The value of the measured amount. The value includes an implicit precision in the presentation of the value.
Property value As HS.FHIR.vDSTU2.Model.Datatype.Decimal(XMLNAME = "value");

/// How the value should be understood and represented - whether the actual value is greater or less than the stated value due to measurement issues; e.g. if the comparator is"<" , then the real value is< stated value.
Property comparator As HS.FHIR.vDSTU2.Model.Base.QuantityComparator(XMLNAME = "comparator");

/// A human-readable form of the unit.
Property unit As HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "unit");

/// The identification of the system that provides the coded form of the unit.
Property system As HS.FHIR.vDSTU2.Model.Datatype.Uri(XMLNAME = "system");

/// A computer processable form of the unit in some unit representation system.
Property code As HS.FHIR.vDSTU2.Model.Datatype.Code(XMLNAME = "code");

/// Set method for the "value" property.
Method SetValue(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Decimal).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Decimal object failed") Quit
		Set ..value = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "comparator" property.
Method SetComparator(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.QuantityComparator).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR QuantityComparator object failed") Quit
		Set ..comparator = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "unit" property.
Method SetUnit(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set ..unit = tObj
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

/// Get new object, populated with specified data.
Method %OnNew(pValue As %String, pComparator As %String, pUnit As %String, pSystem As %String, pCode As %String, pExtension As %RegisteredObject) As %Status
{
	Set tSC = $$$OK
	Try {
		If ($Data(pValue)=0)&&($Data(pComparator)=0)&&($Data(pUnit)=0)&&($Data(pSystem)=0)&&($Data(pCode)=0)&&($Data(pExtension)=0) Quit
		If $Get(pValue)'="" Set tSC = ..SetValue(pValue) Quit:$$$ISERR(tSC)
		If $Get(pComparator)'="" Set tSC = ..SetComparator(pComparator) Quit:$$$ISERR(tSC)
		If $Get(pUnit)'="" Set tSC = ..SetUnit(pUnit) Quit:$$$ISERR(tSC)
		If $Get(pSystem)'="" Set tSC = ..SetSystem(pSystem) Quit:$$$ISERR(tSC)
		If $Get(pCode)'="" Set tSC = ..SetCode(pCode) Quit:$$$ISERR(tSC)
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
