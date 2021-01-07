/// A value set specifies a set of codes drawn from one or more code systems.
Class HS.FHIR.vSTU3.Model.Resource.ValueSet.Include Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ValueSet.Include";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ValueSet.Include";

Parameter JSONTYPEFIELD;

/// An absolute URI which is the code system from which the selected codes come from.
Property system As HS.FHIR.vSTU3.Model.Datatype.Uri(XMLNAME = "system", XMLPROJECTION = "ELEMENT");

/// The version of the code system that the codes are selected from.
Property version As HS.FHIR.vSTU3.Model.Datatype.String(XMLNAME = "version", XMLPROJECTION = "ELEMENT");

/// Specifies a concept to be included or excluded.
Property concept As list Of HS.FHIR.vSTU3.Model.Resource.ValueSet.Concept(XMLNAME = "concept", XMLPROJECTION = "ELEMENT");

/// Select concepts by specify a matching criteria based on the properties (including relationships) defined by the system. If multiple filters are specified, they SHALL all be true.
Property filter As list Of HS.FHIR.vSTU3.Model.Resource.ValueSet.Filter(XMLNAME = "filter", XMLPROJECTION = "ELEMENT");

/// Selects concepts found in this value set. This is an absolute URI that is a reference to ValueSet.url.
Property valueSet As list Of HS.FHIR.vSTU3.Model.Datatype.Uri(XMLNAME = "valueSet", XMLPROJECTION = "ELEMENT");

/// Set method for the "system" property.
Method SetSystem(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Uri).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Uri object failed"_$Select(err="":"",1:" - "_err)) Quit
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
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..version = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Insert method for the "valueSet" property.
Method SetValueSet(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Uri).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Uri object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set tSC = ..valueSet.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
