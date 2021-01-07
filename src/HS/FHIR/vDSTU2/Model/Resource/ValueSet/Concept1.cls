Class HS.FHIR.vDSTU2.Model.Resource.ValueSet.Concept1 Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ValueSet.Concept1";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ValueSet.Concept1";

/// Specifies a code for the concept to be included or excluded.
Property code As HS.FHIR.vDSTU2.Model.Datatype.Code(XMLNAME = "code") [ Required ];

/// The text to display to the user for this concept in the context of this valueset. If no display is provided, then applications using the value set use the display specified for the code by the system.
Property display As HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "display");

/// Additional representations for this concept when used in this value set - other languages, aliases, specialized purposes, used for particular purposes, etc.
Property designation As list Of HS.FHIR.vDSTU2.Model.Resource.ValueSet.Designation(XMLNAME = "designation", XMLPROJECTION = "ELEMENT");

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

}
