/// A Capability Statement documents a set of capabilities (behaviors) of a FHIR Server that may be used as a statement of actual server functionality or a statement of required or desired server implementation.
Class HS.FHIR.vSTU3.Model.Resource.CapabilityStatement.Rest Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "CapabilityStatement.Rest";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "CapabilityStatement.Rest";

Parameter JSONTYPEFIELD;

/// Identifies whether this portion of the statement is describing the ability to initiate or receive restful operations.
Property mode As HS.FHIR.vSTU3.Model.Base.RestfulCapabilityMode(XMLNAME = "mode", XMLPROJECTION = "ELEMENT") [ Required ];

/// Information about the system's restful capabilities that apply across all applications, such as security.
Property documentation As HS.FHIR.vSTU3.Model.Datatype.String(XMLNAME = "documentation", XMLPROJECTION = "ELEMENT");

/// Information about security implementation from an interface perspective - what a client needs to know.
Property security As HS.FHIR.vSTU3.Model.Resource.CapabilityStatement.Security(XMLNAME = "security", XMLPROJECTION = "ELEMENT");

/// A specification of the restful capabilities of the solution for a specific resource type.
Property resource As list Of HS.FHIR.vSTU3.Model.Resource.CapabilityStatement.Resource(XMLNAME = "resource", XMLPROJECTION = "ELEMENT");

/// A specification of restful operations supported by the system.
Property interaction As list Of HS.FHIR.vSTU3.Model.Resource.CapabilityStatement.Interaction1(XMLNAME = "interaction", XMLPROJECTION = "ELEMENT");

/// Search parameters that are supported for searching all resources for implementations to support and/or make use of - either references to ones defined in the specification, or additional ones defined for/by the implementation.
Property searchParam As list Of HS.FHIR.vSTU3.Model.Resource.CapabilityStatement.SearchParam(XMLNAME = "searchParam", XMLPROJECTION = "ELEMENT");

/// Definition of an operation or a named query together with its parameters and their meaning and type.
Property operation As list Of HS.FHIR.vSTU3.Model.Resource.CapabilityStatement.Operation(XMLNAME = "operation", XMLPROJECTION = "ELEMENT");

/// An absolute URI which is a reference to the definition of a compartment that the system supports. The reference is to a CompartmentDefinition resource by its canonical URL .
Property compartment As list Of HS.FHIR.vSTU3.Model.Datatype.Uri(XMLNAME = "compartment", XMLPROJECTION = "ELEMENT");

/// Set method for the "mode" property.
Method SetMode(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.RestfulCapabilityMode).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR RestfulCapabilityMode object failed"_$Select(err="":"",1:" - "_err)) Quit
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
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..documentation = tObj
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
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Uri).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Uri object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set tSC = ..compartment.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
