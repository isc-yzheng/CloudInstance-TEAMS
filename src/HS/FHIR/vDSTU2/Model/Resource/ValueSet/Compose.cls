Class HS.FHIR.vDSTU2.Model.Resource.ValueSet.Compose Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ValueSet.Compose";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ValueSet.Compose";

/// Includes the contents of the referenced value set as a part of the contents of this value set. This is an absolute URI that is a reference to ValueSet.uri.
Property import As list Of HS.FHIR.vDSTU2.Model.Datatype.Uri(XMLNAME = "import", XMLPROJECTION = "ELEMENT");

/// Include one or more codes from a code system.
Property include As list Of HS.FHIR.vDSTU2.Model.Resource.ValueSet.Include(XMLNAME = "include", XMLPROJECTION = "ELEMENT");

/// Exclude one or more codes from the value set.
Property exclude As list Of HS.FHIR.vDSTU2.Model.Resource.ValueSet.Include(XMLNAME = "exclude", XMLPROJECTION = "ELEMENT");

/// Insert method for the "import" property.
Method SetImport(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Uri).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Uri object failed") Quit
		Set tSC = ..import.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
