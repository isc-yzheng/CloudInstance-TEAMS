Class HS.FHIR.vDSTU2.Model.Resource.ValueSet.Include Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ValueSet.Include";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ValueSet.Include";

/// An absolute URI which is the code system from which the selected codes come from.
Property system As HS.FHIR.vDSTU2.Model.Datatype.Uri(XMLNAME = "system") [ Required ];

/// The version of the code system that the codes are selected from.
Property version As HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "version");

/// Specifies a concept to be included or excluded.
Property concept As list Of HS.FHIR.vDSTU2.Model.Resource.ValueSet.Concept1(XMLNAME = "concept", XMLPROJECTION = "ELEMENT");

/// Select concepts by specify a matching criteria based on the properties (including relationships) defined by the system. If multiple filters are specified, they SHALL all be true.
Property filter As list Of HS.FHIR.vDSTU2.Model.Resource.ValueSet.Filter(XMLNAME = "filter", XMLPROJECTION = "ELEMENT");

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

}
