Class HS.FHIR.vDSTU2.Model.Resource.Conformance.Resource Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Conformance.Resource";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Conformance.Resource";

/// A type of resource exposed via the restful interface.
Property type As HS.FHIR.vDSTU2.Model.Datatype.Code(XMLNAME = "type") [ Required ];

/// A specification of the profile that describes the solution's overall support for the resource, including any constraints on cardinality, bindings, lengths or other limitations. See further discussion in [Using Profiles]{profiling.html#profile-uses}.
Property profile As HS.FHIR.vDSTU2.Model.Base.Reference(XMLNAME = "profile");

/// Identifies a restful operation supported by the solution.
Property interaction As list Of HS.FHIR.vDSTU2.Model.Resource.Conformance.Interaction(XMLNAME = "interaction", XMLPROJECTION = "ELEMENT") [ Required ];

/// This field is set to no-version to specify that the system does not support (server) or use (client) versioning for this resource type. If this has some other value, the server must at least correctly track and populate the versionId meta-property on resources. If the value is 'versioned-update', then the server supports all the versioning features, including using e-tags for version integrity in the API.
Property versioning As HS.FHIR.vDSTU2.Model.Base.ResourceVersionPolicy(XMLNAME = "versioning");

/// A flag for whether the server is able to return past versions as part of the vRead operation.
Property readHistory As HS.FHIR.vDSTU2.Model.Datatype.Boolean(XMLNAME = "readHistory");

/// A flag to indicate that the server allows or needs to allow the client to create new identities on the server (e.g. that is, the client PUTs to a location where there is no existing resource). Allowing this operation means that the server allows the client to create new identities on the server.
Property updateCreate As HS.FHIR.vDSTU2.Model.Datatype.Boolean(XMLNAME = "updateCreate");

/// A flag that indicates that the server supports conditional create.
Property conditionalCreate As HS.FHIR.vDSTU2.Model.Datatype.Boolean(XMLNAME = "conditionalCreate");

/// A flag that indicates that the server supports conditional update.
Property conditionalUpdate As HS.FHIR.vDSTU2.Model.Datatype.Boolean(XMLNAME = "conditionalUpdate");

/// A code that indicates how the server supports conditional delete.
Property conditionalDelete As HS.FHIR.vDSTU2.Model.Base.ConditionalDeleteStatus(XMLNAME = "conditionalDelete");

/// A list of _include values supported by the server.
Property searchInclude As list Of HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "searchInclude", XMLPROJECTION = "ELEMENT");

/// A list of _revinclude (reverse include) values supported by the server.
Property searchRevInclude As list Of HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "searchRevInclude", XMLPROJECTION = "ELEMENT");

/// Search parameters for implementations to support and/or make use of - either references to ones defined in the specification, or additional ones defined for/by the implementation.
Property searchParam As list Of HS.FHIR.vDSTU2.Model.Resource.Conformance.SearchParam(XMLNAME = "searchParam", XMLPROJECTION = "ELEMENT");

/// Set method for the "type" property.
Method SetType(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Code).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Code object failed") Quit
		Set ..type = tObj
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
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed") Quit
		Set ..profile = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "versioning" property.
Method SetVersioning(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.ResourceVersionPolicy).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR ResourceVersionPolicy object failed") Quit
		Set ..versioning = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "readHistory" property.
Method SetReadHistory(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Boolean).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Boolean object failed") Quit
		Set ..readHistory = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "updateCreate" property.
Method SetUpdateCreate(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Boolean).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Boolean object failed") Quit
		Set ..updateCreate = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "conditionalCreate" property.
Method SetConditionalCreate(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Boolean).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Boolean object failed") Quit
		Set ..conditionalCreate = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "conditionalUpdate" property.
Method SetConditionalUpdate(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Boolean).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Boolean object failed") Quit
		Set ..conditionalUpdate = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "conditionalDelete" property.
Method SetConditionalDelete(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.ConditionalDeleteStatus).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR ConditionalDeleteStatus object failed") Quit
		Set ..conditionalDelete = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Insert method for the "searchInclude" property.
Method SetSearchInclude(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set tSC = ..searchInclude.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Insert method for the "searchRevInclude" property.
Method SetSearchRevInclude(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set tSC = ..searchRevInclude.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
