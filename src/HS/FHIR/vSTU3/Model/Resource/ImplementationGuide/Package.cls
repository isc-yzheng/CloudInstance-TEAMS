/// A set of rules of how FHIR is used to solve a particular problem. This resource is used to gather all the parts of an implementation guide into a logical whole and to publish a computable definition of all the parts.
Class HS.FHIR.vSTU3.Model.Resource.ImplementationGuide.Package Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ImplementationGuide.Package";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ImplementationGuide.Package";

Parameter JSONTYPEFIELD;

/// The name for the group, as used in page.package.
Property name As HS.FHIR.vSTU3.Model.Datatype.String(XMLNAME = "name", XMLPROJECTION = "ELEMENT") [ Required ];

/// Human readable text describing the package.
Property description As HS.FHIR.vSTU3.Model.Datatype.String(XMLNAME = "description", XMLPROJECTION = "ELEMENT");

/// A resource that is part of the implementation guide. Conformance resources (value set, structure definition, capability statements etc.) are obvious candidates for inclusion, but any kind of resource can be included as an example resource.
Property resource As list Of HS.FHIR.vSTU3.Model.Resource.ImplementationGuide.Resource(XMLNAME = "resource", XMLPROJECTION = "ELEMENT");

/// Set method for the "name" property.
Method SetName(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..name = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "description" property.
Method SetDescription(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..description = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
