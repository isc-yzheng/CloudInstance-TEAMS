Class HS.FHIR.vDSTU2.Model.Resource.ConceptMap.Target Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ConceptMap.Target";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ConceptMap.Target";

/// An absolute URI that identifies the code system of the target code (if the target is a value set that cross code systems).
Property codeSystem As HS.FHIR.vDSTU2.Model.Datatype.Uri(XMLNAME = "codeSystem");

/// Identity (code or path) or the element/item that the map refers to.
Property code As HS.FHIR.vDSTU2.Model.Datatype.Code(XMLNAME = "code");

/// The equivalence between the source and target concepts (counting for the dependencies and products). The equivalence is read from target to source (e.g. the target is 'wider' than the source).
Property equivalence As HS.FHIR.vDSTU2.Model.Datatype.Code(XMLNAME = "equivalence") [ Required ];

/// A description of status/issues in mapping that conveys additional information not represented in  the structured data.
Property comments As HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "comments");

/// A set of additional dependencies for this mapping to hold. This mapping is only applicable if the specified element can be resolved, and it has the specified value.
Property dependsOn As list Of HS.FHIR.vDSTU2.Model.Resource.ConceptMap.DependsOn(XMLNAME = "dependsOn", XMLPROJECTION = "ELEMENT");

/// A set of additional outcomes from this mapping to other elements. To properly execute this mapping, the specified element must be mapped to some data element or source that is in context. The mapping may still be useful without a place for the additional data elements, but the equivalence cannot be relied on.
Property product As list Of HS.FHIR.vDSTU2.Model.Resource.ConceptMap.DependsOn(XMLNAME = "product", XMLPROJECTION = "ELEMENT");

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
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Code).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Code object failed") Quit
		Set ..code = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "equivalence" property.
Method SetEquivalence(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Code).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Code object failed") Quit
		Set ..equivalence = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "comments" property.
Method SetComments(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set ..comments = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
