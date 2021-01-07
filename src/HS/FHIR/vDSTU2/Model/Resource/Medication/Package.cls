Class HS.FHIR.vDSTU2.Model.Resource.Medication.Package Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Medication.Package";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Medication.Package";

/// The kind of container that this package comes as.
Property container As HS.FHIR.vDSTU2.Model.Base.CodeableConcept(XMLNAME = "container");

/// A set of components that go to make up the described item.
Property content As list Of HS.FHIR.vDSTU2.Model.Resource.Medication.Content(XMLNAME = "content", XMLPROJECTION = "ELEMENT");

/// Set method for the "container" property.
Method SetContainer(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed") Quit
		Set ..container = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
