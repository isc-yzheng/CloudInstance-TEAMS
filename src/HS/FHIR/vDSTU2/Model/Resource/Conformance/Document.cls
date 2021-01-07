Class HS.FHIR.vDSTU2.Model.Resource.Conformance.Document Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Conformance.Document";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Conformance.Document";

/// Mode of this document declaration - whether application is producer or consumer.
Property mode As HS.FHIR.vDSTU2.Model.Base.DocumentMode(XMLNAME = "mode") [ Required ];

/// A description of how the application supports or uses the specified document profile.  For example, when are documents created, what action is taken with consumed documents, etc.
Property documentation As HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "documentation");

/// A constraint on a resource used in the document.
Property profile As HS.FHIR.vDSTU2.Model.Base.Reference(XMLNAME = "profile") [ Required ];

/// Set method for the "mode" property.
Method SetMode(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.DocumentMode).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR DocumentMode object failed") Quit
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

}
