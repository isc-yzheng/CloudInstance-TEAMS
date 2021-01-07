/// A formal computable definition of an operation (on the RESTful interface) or a named query (using the search interaction).
Class HS.FHIR.vSTU3.Model.Resource.OperationDefinition.Binding Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "OperationDefinition.Binding";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "OperationDefinition.Binding";

Parameter JSONTYPEFIELD;

/// Indicates the degree of conformance expectations associated with this binding - that is, the degree to which the provided value set must be adhered to in the instances.
Property strength As HS.FHIR.vSTU3.Model.Base.BindingStrength(XMLNAME = "strength", XMLPROJECTION = "ELEMENT") [ Required ];

Property valueSetUri As HS.FHIR.vSTU3.Model.Datatype.Uri(XMLNAME = "valueSetUri", XMLPROJECTION = "ELEMENT");

Property valueSetReference As HS.FHIR.vSTU3.Model.Base.Reference(XMLNAME = "valueSetReference", XMLPROJECTION = "ELEMENT");

/// Set method for the "strength" property.
Method SetStrength(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.BindingStrength).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR BindingStrength object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..strength = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "valueSetUri" property.
Method SetValueSetUri(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Uri).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Uri object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..valueSetUri = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "valueSetReference" property.
Method SetValueSetReference(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..valueSetReference = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
