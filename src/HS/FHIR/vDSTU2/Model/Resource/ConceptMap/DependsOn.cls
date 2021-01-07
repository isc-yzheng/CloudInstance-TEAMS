Class HS.FHIR.vDSTU2.Model.Resource.ConceptMap.DependsOn Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ConceptMap.DependsOn";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ConceptMap.DependsOn";

/// A reference to a specific concept that holds a coded value. This can be an element in a FHIR resource, or a specific reference to a data element in a different specification (e.g. HL7 v2) or a general reference to a kind of data field, or a reference to a value set with an appropriately narrow definition.
Property element As HS.FHIR.vDSTU2.Model.Datatype.Uri(XMLNAME = "element") [ Required ];

/// An absolute URI that identifies the code system of the dependency code (if the source/dependency is a value set that crosses code systems).
Property codeSystem As HS.FHIR.vDSTU2.Model.Datatype.Uri(XMLNAME = "codeSystem") [ Required ];

/// Identity (code or path) or the element/item/ValueSet that the map depends on / refers to.
Property code As HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "code") [ Required ];

/// Set method for the "element" property.
Method SetElement(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Uri).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Uri object failed") Quit
		Set ..element = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "codeSystem" property.
Method SetCodeSystem(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Uri).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Uri object failed") Quit
		Set ..codeSystem = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "code" property.
Method SetCode(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set ..code = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
