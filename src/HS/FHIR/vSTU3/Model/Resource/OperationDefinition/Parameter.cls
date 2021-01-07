/// A formal computable definition of an operation (on the RESTful interface) or a named query (using the search interaction).
Class HS.FHIR.vSTU3.Model.Resource.OperationDefinition.Parameter Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "OperationDefinition.Parameter";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "OperationDefinition.Parameter";

Parameter JSONTYPEFIELD;

/// The name of used to identify the parameter.
Property name As HS.FHIR.vSTU3.Model.Datatype.Code(XMLNAME = "name", XMLPROJECTION = "ELEMENT") [ Required ];

/// Whether this is an input or an output parameter.
Property use As HS.FHIR.vSTU3.Model.Base.OperationParameterUse(XMLNAME = "use", XMLPROJECTION = "ELEMENT") [ Required ];

/// The minimum number of times this parameter SHALL appear in the request or response.
Property min As HS.FHIR.vSTU3.Model.Datatype.Integer(XMLNAME = "min", XMLPROJECTION = "ELEMENT") [ Required ];

/// The maximum number of times this element is permitted to appear in the request or response.
Property max As HS.FHIR.vSTU3.Model.Datatype.String(XMLNAME = "max", XMLPROJECTION = "ELEMENT") [ Required ];

/// Describes the meaning or use of this parameter.
Property documentation As HS.FHIR.vSTU3.Model.Datatype.String(XMLNAME = "documentation", XMLPROJECTION = "ELEMENT");

/// The type for this parameter.
Property type As HS.FHIR.vSTU3.Model.Base.FHIRAllTypes(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

/// How the parameter is understood as a search parameter. This is only used if the parameter type is 'string'.
Property searchType As HS.FHIR.vSTU3.Model.Base.SearchParamType(XMLNAME = "searchType", XMLPROJECTION = "ELEMENT");

/// A profile the specifies the rules that this parameter must conform to.
Property profile As HS.FHIR.vSTU3.Model.Base.Reference(XMLNAME = "profile", XMLPROJECTION = "ELEMENT");

/// Binds to a value set if this parameter is coded (code, Coding, CodeableConcept).
Property binding As HS.FHIR.vSTU3.Model.Resource.OperationDefinition.Binding(XMLNAME = "binding", XMLPROJECTION = "ELEMENT");

/// The parts of a nested Parameter.
Property part As list Of HS.FHIR.vSTU3.Model.Resource.OperationDefinition.Parameter(XMLNAME = "part", XMLPROJECTION = "ELEMENT");

/// Set method for the "name" property.
Method SetName(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Code).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Code object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..name = tObj
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
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.OperationParameterUse).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR OperationParameterUse object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..use = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "min" property.
Method SetMin(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Integer).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Integer object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..min = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "max" property.
Method SetMax(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..max = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "documentation" property.
Method SetDocumentation(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..documentation = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "type" property.
Method SetType(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.FHIRAllTypes).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR FHIRAllTypes object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..type = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "searchType" property.
Method SetSearchType(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.SearchParamType).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR SearchParamType object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..searchType = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "profile" property.
Method SetProfile(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..profile = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
