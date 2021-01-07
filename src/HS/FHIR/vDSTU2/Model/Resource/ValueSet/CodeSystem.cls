Class HS.FHIR.vDSTU2.Model.Resource.ValueSet.CodeSystem Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ValueSet.CodeSystem";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ValueSet.CodeSystem";

/// An absolute URI that is used to reference this code system, including in [Coding]{datatypes.html#Coding}.system.
Property system As HS.FHIR.vDSTU2.Model.Datatype.Uri(XMLNAME = "system") [ Required ];

/// The version of this code system that defines the codes. Note that the version is optional because a well maintained code system does not suffer from versioning, and therefore the version does not need to be maintained. However many code systems are not well maintained, and the version needs to be defined and tracked.
Property version As HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "version");

/// If code comparison is case sensitive when codes within this system are compared to each other.
Property caseSensitive As HS.FHIR.vDSTU2.Model.Datatype.Boolean(XMLNAME = "caseSensitive");

/// Concepts that are in the code system. The concept definitions are inherently hierarchical, but the definitions must be consulted to determine what the meaning of the hierarchical relationships are.
Property concept As list Of HS.FHIR.vDSTU2.Model.Resource.ValueSet.Concept(XMLNAME = "concept", XMLPROJECTION = "ELEMENT") [ Required ];

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

/// Set method for the "version" property.
Method SetVersion(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set ..version = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "caseSensitive" property.
Method SetCaseSensitive(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Boolean).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Boolean object failed") Quit
		Set ..caseSensitive = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
