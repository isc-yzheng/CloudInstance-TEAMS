/// A formal computable definition of a graph of resources - that is, a coherent set of resources that form a graph by following references. The Graph Definition resource defines a set and makes rules about the set.
Class HS.FHIR.vSTU3.Model.Resource.GraphDefinition.Target Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "GraphDefinition.Target";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "GraphDefinition.Target";

Parameter JSONTYPEFIELD;

/// Type of resource this link refers to.
Property type As HS.FHIR.vSTU3.Model.Base.ResourceType(XMLNAME = "type", XMLPROJECTION = "ELEMENT") [ Required ];

/// Profile for the target resource.
Property profile As HS.FHIR.vSTU3.Model.Datatype.Uri(XMLNAME = "profile", XMLPROJECTION = "ELEMENT");

/// Compartment Consistency Rules.
Property compartment As list Of HS.FHIR.vSTU3.Model.Resource.GraphDefinition.Compartment(XMLNAME = "compartment", XMLPROJECTION = "ELEMENT");

/// Additional links from target resource.
Property link As list Of HS.FHIR.vSTU3.Model.Resource.GraphDefinition.Link(XMLNAME = "link", XMLPROJECTION = "ELEMENT");

/// Set method for the "type" property.
Method SetType(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.ResourceType).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR ResourceType object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..type = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "profile" property.
Method SetProfile(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Uri).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Uri object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..profile = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
