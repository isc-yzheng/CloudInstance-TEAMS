Class HS.FHIR.vDSTU2.Model.Resource.ValueSet.Filter Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ValueSet.Filter";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ValueSet.Filter";

/// A code that identifies a property defined in the code system.
Property property As HS.FHIR.vDSTU2.Model.Datatype.Code(XMLNAME = "property") [ Required ];

/// The kind of operation to perform as a part of the filter criteria.
Property op As HS.FHIR.vDSTU2.Model.Base.FilterOperator(XMLNAME = "op") [ Required ];

/// The match value may be either a code defined by the system, or a string value which is used a regex match on the literal string of the property value.
Property value As HS.FHIR.vDSTU2.Model.Datatype.Code(XMLNAME = "value") [ Required ];

/// Set method for the "property" property.
Method SetProperty(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Code).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Code object failed") Quit
		Set ..property = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "op" property.
Method SetOp(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.FilterOperator).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR FilterOperator object failed") Quit
		Set ..op = tObj
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
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Code).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Code object failed") Quit
		Set ..value = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
