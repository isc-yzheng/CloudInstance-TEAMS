Class HS.FHIR.vDSTU2.Model.Resource.ImplementationGuide.Package Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ImplementationGuide.Package";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ImplementationGuide.Package";

/// The name for the group, as used in page.package.
Property name As HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "name") [ Required ];

/// Human readable text describing the package.
Property description As HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "description");

/// A resource that is part of the implementation guide. Conformance resources (value set, structure definition, conformance statements etc.) are obvious candidates for inclusion, but any kind of resource can be included as an example resource.
Property resource As list Of HS.FHIR.vDSTU2.Model.Resource.ImplementationGuide.Resource(XMLNAME = "resource", XMLPROJECTION = "ELEMENT") [ Required ];

/// Set method for the "name" property.
Method SetName(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
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
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set ..description = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
