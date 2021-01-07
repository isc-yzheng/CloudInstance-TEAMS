Class HS.FHIR.vDSTU2.Model.Resource.Conformance.Rest Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Conformance.Rest";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Conformance.Rest";

/// Identifies whether this portion of the statement is describing ability to initiate or receive restful operations.
Property mode As HS.FHIR.vDSTU2.Model.Base.RestfulConformanceMode(XMLNAME = "mode") [ Required ];

/// Information about the system's restful capabilities that apply across all applications, such as security.
Property documentation As HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "documentation");

/// Information about security implementation from an interface perspective - what a client needs to know.
Property security As HS.FHIR.vDSTU2.Model.Resource.Conformance.Security(XMLNAME = "security");

/// A specification of the restful capabilities of the solution for a specific resource type.
Property resource As list Of HS.FHIR.vDSTU2.Model.Resource.Conformance.Resource(XMLNAME = "resource", XMLPROJECTION = "ELEMENT") [ Required ];

/// A specification of restful operations supported by the system.
Property interaction As list Of HS.FHIR.vDSTU2.Model.Resource.Conformance.Interaction1(XMLNAME = "interaction", XMLPROJECTION = "ELEMENT");

/// A code that indicates how transactions are supported.
Property transactionMode As HS.FHIR.vDSTU2.Model.Base.TransactionMode(XMLNAME = "transactionMode");

/// Search parameters that are supported for searching all resources for implementations to support and/or make use of - either references to ones defined in the specification, or additional ones defined for/by the implementation.
Property searchParam As list Of HS.FHIR.vDSTU2.Model.Resource.Conformance.SearchParam(XMLNAME = "searchParam", XMLPROJECTION = "ELEMENT");

/// Definition of an operation or a named query and with its parameters and their meaning and type.
Property operation As list Of HS.FHIR.vDSTU2.Model.Resource.Conformance.Operation(XMLNAME = "operation", XMLPROJECTION = "ELEMENT");

/// An absolute URI which is a reference to the definition of a compartment hosted by the system.
Property compartment As list Of HS.FHIR.vDSTU2.Model.Datatype.Uri(XMLNAME = "compartment", XMLPROJECTION = "ELEMENT");

/// Set method for the "mode" property.
Method SetMode(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.RestfulConformanceMode).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR RestfulConformanceMode object failed") Quit
		Set ..mode = tObj
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
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set ..documentation = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "transactionMode" property.
Method SetTransactionMode(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.TransactionMode).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR TransactionMode object failed") Quit
		Set ..transactionMode = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Insert method for the "compartment" property.
Method SetCompartment(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Uri).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Uri object failed") Quit
		Set tSC = ..compartment.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
