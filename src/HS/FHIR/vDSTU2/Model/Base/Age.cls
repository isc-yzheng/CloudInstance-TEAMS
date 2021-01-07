Class HS.FHIR.vDSTU2.Model.Base.Age Extends HS.FHIR.vDSTU2.Model.Base.AbstractBase [ CompileAfter = HS.FHIR.vDSTU2.Model.Datatype.IdPrimitive, ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Age";

Parameter XMLSEQUENCE = 1;

/// Exception as inherited from Element
Property extension As list Of HS.FHIR.vDSTU2.Model.Base.Extension(XMLNAME = "extension", XMLPROJECTION = "ELEMENT");

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

Property id As HS.FHIR.vDSTU2.Model.Datatype.IdPrimitive(XMLNAME = "id", XMLPROJECTION = "ATTRIBUTE");

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

}
