/// A statement of relationships from one set of concepts to one or more other concepts - either code systems or data elements, or classes in class models.
Class HS.FHIR.vSTU3.Model.Resource.ConceptMap.Group Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ConceptMap.Group";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ConceptMap.Group";

Parameter JSONTYPEFIELD;

/// An absolute URI that identifies the Code System (if the source is a value set that crosses more than one code system).
Property source As HS.FHIR.vSTU3.Model.Datatype.Uri(XMLNAME = "source", XMLPROJECTION = "ELEMENT");

/// The specific version of the code system, as determined by the code system authority.
Property sourceVersion As HS.FHIR.vSTU3.Model.Datatype.String(XMLNAME = "sourceVersion", XMLPROJECTION = "ELEMENT");

/// An absolute URI that identifies the code system of the target code (if the target is a value set that cross code systems).
Property target As HS.FHIR.vSTU3.Model.Datatype.Uri(XMLNAME = "target", XMLPROJECTION = "ELEMENT");

/// The specific version of the code system, as determined by the code system authority.
Property targetVersion As HS.FHIR.vSTU3.Model.Datatype.String(XMLNAME = "targetVersion", XMLPROJECTION = "ELEMENT");

/// Mappings for an individual concept in the source to one or more concepts in the target.
Property element As list Of HS.FHIR.vSTU3.Model.Resource.ConceptMap.Element(XMLNAME = "element", XMLPROJECTION = "ELEMENT");

/// What to do when there is no match in the mappings in the group.
Property unmapped As HS.FHIR.vSTU3.Model.Resource.ConceptMap.Unmapped(XMLNAME = "unmapped", XMLPROJECTION = "ELEMENT");

/// Set method for the "source" property.
Method SetSource(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Uri).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Uri object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..source = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "sourceVersion" property.
Method SetSourceVersion(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..sourceVersion = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "target" property.
Method SetTarget(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Uri).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Uri object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..target = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "targetVersion" property.
Method SetTargetVersion(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..targetVersion = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
