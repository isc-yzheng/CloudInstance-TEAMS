/// A statement of relationships from one set of concepts to one or more other concepts - either code systems or data elements, or classes in class models.
Class HS.FHIR.vSTU3.Model.Resource.ConceptMap.Element Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ConceptMap.Element";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ConceptMap.Element";

Parameter JSONTYPEFIELD;

/// Identity (code or path) or the element/item being mapped.
Property code As HS.FHIR.vSTU3.Model.Datatype.Code(XMLNAME = "code", XMLPROJECTION = "ELEMENT");

/// The display for the code. The display is only provided to help editors when editing the concept map.
Property display As HS.FHIR.vSTU3.Model.Datatype.String(XMLNAME = "display", XMLPROJECTION = "ELEMENT");

/// A concept from the target value set that this concept maps to.
Property target As list Of HS.FHIR.vSTU3.Model.Resource.ConceptMap.Target(XMLNAME = "target", XMLPROJECTION = "ELEMENT");

/// Set method for the "code" property.
Method SetCode(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Code).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Code object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..code = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "display" property.
Method SetDisplay(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..display = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
