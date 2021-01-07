Class HS.FHIR.vDSTU2.Model.Resource.ConceptMap.Element Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ConceptMap.Element";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ConceptMap.Element";

/// An absolute URI that identifies the Code System (if the source is a value set that crosses more than one code system).
Property codeSystem As HS.FHIR.vDSTU2.Model.Datatype.Uri(XMLNAME = "codeSystem");

/// Identity (code or path) or the element/item being mapped.
Property code As HS.FHIR.vDSTU2.Model.Datatype.Code(XMLNAME = "code");

/// A concept from the target value set that this concept maps to.
Property target As list Of HS.FHIR.vDSTU2.Model.Resource.ConceptMap.Target(XMLNAME = "target", XMLPROJECTION = "ELEMENT");

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

}
