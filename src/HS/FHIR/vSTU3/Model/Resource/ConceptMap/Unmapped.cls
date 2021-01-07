/// A statement of relationships from one set of concepts to one or more other concepts - either code systems or data elements, or classes in class models.
Class HS.FHIR.vSTU3.Model.Resource.ConceptMap.Unmapped Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ConceptMap.Unmapped";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ConceptMap.Unmapped";

Parameter JSONTYPEFIELD;

/// Defines which action to take if there is no match in the group. One of 3 actions is possible: use the unmapped code (this is useful when doing a mapping between versions, and only a few codes have changed), use a fixed code (a default code), or alternatively, a reference to a different concept map can be provided (by canonical URL).
Property mode As HS.FHIR.vSTU3.Model.Base.ConceptMapGroupUnmappedMode(XMLNAME = "mode", XMLPROJECTION = "ELEMENT") [ Required ];

/// The fixed code to use when the mode = 'fixed'  - all unmapped codes are mapped to a single fixed code.
Property code As HS.FHIR.vSTU3.Model.Datatype.Code(XMLNAME = "code", XMLPROJECTION = "ELEMENT");

/// The display for the code. The display is only provided to help editors when editing the concept map.
Property display As HS.FHIR.vSTU3.Model.Datatype.String(XMLNAME = "display", XMLPROJECTION = "ELEMENT");

/// The canonical URL of the map to use if this map contains no mapping.
Property url As HS.FHIR.vSTU3.Model.Datatype.Uri(XMLNAME = "url", XMLPROJECTION = "ELEMENT");

/// Set method for the "mode" property.
Method SetMode(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.ConceptMapGroupUnmappedMode).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR ConceptMapGroupUnmappedMode object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..mode = tObj
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

/// Set method for the "url" property.
Method SetUrl(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Uri).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Uri object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..url = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
