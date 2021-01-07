/// This is the base resource type for everything.
Class HS.FHIR.vSTU3.Model.Base.Resource Extends HS.FHIR.vSTU3.Model.Base.AbstractBase [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Resource";

Parameter XMLSEQUENCE = 1;

/// The logical id of the resource, as used in the URL for the resource. Once assigned, this value never changes.
Property id As HS.FHIR.vSTU3.Model.Datatype.Id(XMLNAME = "id", XMLPROJECTION = "ELEMENT");

/// The metadata about the resource. This is content that is maintained by the infrastructure. Changes to the content may not always be associated with version changes to the resource.
Property meta As HS.FHIR.vSTU3.Model.Base.Meta(XMLNAME = "meta", XMLPROJECTION = "ELEMENT");

/// A reference to a set of rules that were followed when the resource was constructed, and which must be understood when processing the content.
Property implicitRules As HS.FHIR.vSTU3.Model.Datatype.Uri(XMLNAME = "implicitRules", XMLPROJECTION = "ELEMENT");

/// The base language in which the resource is written.
Property language As HS.FHIR.vSTU3.Model.Datatype.Code(XMLNAME = "language", XMLPROJECTION = "ELEMENT");

/// Set method for the "id" property.
Method SetId(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Id).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Id object failed"_$Select(err="":"",1:" - "_err)) Quit
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
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Uri).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Uri object failed"_$Select(err="":"",1:" - "_err)) Quit
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
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Code).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Code object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..language = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
