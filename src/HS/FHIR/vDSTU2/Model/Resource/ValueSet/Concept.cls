Class HS.FHIR.vDSTU2.Model.Resource.ValueSet.Concept Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ValueSet.Concept";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ValueSet.Concept";

/// A code - a text symbol - that uniquely identifies the concept within the code system.
Property code As HS.FHIR.vDSTU2.Model.Datatype.Code(XMLNAME = "code") [ Required ];

/// If this code is not for use as a real concept.
Property abstract As HS.FHIR.vDSTU2.Model.Datatype.Boolean(XMLNAME = "abstract");

/// A human readable string that is the recommended default way to present this concept to a user.
Property display As HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "display");

/// The formal definition of the concept. The value set resource does not make formal definitions required, because of the prevalence of legacy systems. However, they are highly recommended, as without them there is no formal meaning associated with the concept.
Property definition As HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "definition");

/// Additional representations for the concept - other languages, aliases, specialized purposes, used for particular purposes, etc.
Property designation As list Of HS.FHIR.vDSTU2.Model.Resource.ValueSet.Designation(XMLNAME = "designation", XMLPROJECTION = "ELEMENT");

/// Defines children of a concept to produce a hierarchy of concepts. The nature of the relationships is variable (is-a/contains/categorizes) and can only be determined by examining the definitions of the concepts.
Property concept As list Of HS.FHIR.vDSTU2.Model.Resource.ValueSet.Concept(XMLNAME = "concept", XMLPROJECTION = "ELEMENT");

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

/// Set method for the "abstract" property.
Method SetAbstract(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Boolean).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Boolean object failed") Quit
		Set ..abstract = tObj
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
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set ..display = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "definition" property.
Method SetDefinition(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set ..definition = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
