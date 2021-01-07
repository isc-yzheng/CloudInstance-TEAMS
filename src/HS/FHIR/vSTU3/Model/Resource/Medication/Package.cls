/// This resource is primarily used for the identification and definition of a medication. It covers the ingredients and the packaging for a medication.
Class HS.FHIR.vSTU3.Model.Resource.Medication.Package Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Medication.Package";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Medication.Package";

Parameter JSONTYPEFIELD;

/// The kind of container that this package comes as.
Property container As HS.FHIR.vSTU3.Model.Base.CodeableConcept(XMLNAME = "container", XMLPROJECTION = "ELEMENT");

/// A set of components that go to make up the described item.
Property content As list Of HS.FHIR.vSTU3.Model.Resource.Medication.Content(XMLNAME = "content", XMLPROJECTION = "ELEMENT");

/// Information about a group of medication produced or packaged from one production run.
Property batch As list Of HS.FHIR.vSTU3.Model.Resource.Medication.Batch(XMLNAME = "batch", XMLPROJECTION = "ELEMENT");

/// Set method for the "container" property.
Method SetContainer(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..container = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
