/// A value set specifies a set of codes drawn from one or more code systems.
Class HS.FHIR.vSTU3.Model.Resource.ValueSet.Filter Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ValueSet.Filter";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ValueSet.Filter";

Parameter JSONTYPEFIELD;

/// A code that identifies a property defined in the code system.
Property property As HS.FHIR.vSTU3.Model.Datatype.Code(XMLNAME = "property", XMLPROJECTION = "ELEMENT") [ Required ];

/// The kind of operation to perform as a part of the filter criteria.
Property op As HS.FHIR.vSTU3.Model.Base.FilterOperator(XMLNAME = "op", XMLPROJECTION = "ELEMENT") [ Required ];

/// The match value may be either a code defined by the system, or a string value, which is a regex match on the literal string of the property value when the operation is 'regex', or one of the values (true and false), when the operation is 'exists'.
Property value As HS.FHIR.vSTU3.Model.Datatype.Code(XMLNAME = "value", XMLPROJECTION = "ELEMENT") [ Required ];

/// Set method for the "property" property.
Method SetProperty(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Code).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Code object failed"_$Select(err="":"",1:" - "_err)) Quit
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
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.FilterOperator).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR FilterOperator object failed"_$Select(err="":"",1:" - "_err)) Quit
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
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Code).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Code object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..value = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
