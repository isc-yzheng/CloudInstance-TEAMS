Class HS.FHIR.vDSTU2.Model.Base.Resource Extends HS.FHIR.vDSTU2.Model.Base.AbstractBase [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Resource";

Parameter XMLSEQUENCE = 1;

/// The logical id of the resource, as used in the URL for the resource. Once assigned, this value never changes.
Property id As HS.FHIR.vDSTU2.Model.Datatype.Id(XMLNAME = "id");

/// The metadata about the resource. This is content that is maintained by the infrastructure. Changes to the content may not always be associated with version changes to the resource.
Property meta As HS.FHIR.vDSTU2.Model.Base.Meta(XMLNAME = "meta");

/// A reference to a set of rules that were followed when the resource was constructed, and which must be understood when processing the content.
Property implicitRules As HS.FHIR.vDSTU2.Model.Datatype.Uri(XMLNAME = "implicitRules");

/// The base language in which the resource is written.
Property language As HS.FHIR.vDSTU2.Model.Datatype.Code(XMLNAME = "language") [ SqlFieldName = _language ];

/// Set method for the "id" property.
Method SetId(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Id).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Id object failed") Quit
		Set ..id = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "implicitRules" property.
Method SetImplicitRules(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Uri).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Uri object failed") Quit
		Set ..implicitRules = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "language" property.
Method SetLanguage(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Code).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Code object failed") Quit
		Set ..language = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
