/// Measurements and simple assertions made about a patient, device or other subject.
Class HS.FHIR.vSTU3.Model.Resource.Observation.Related Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Observation.Related";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Observation.Related";

Parameter JSONTYPEFIELD;

/// A code specifying the kind of relationship that exists with the target resource.
Property type As HS.FHIR.vSTU3.Model.Base.ObservationRelationshipType(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

/// A reference to the observation or [[[QuestionnaireResponse]]] resource that is related to this observation.
Property target As HS.FHIR.vSTU3.Model.Base.Reference(XMLNAME = "target", XMLPROJECTION = "ELEMENT") [ Required ];

/// Set method for the "type" property.
Method SetType(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.ObservationRelationshipType).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR ObservationRelationshipType object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..type = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "target" property.
Method SetTarget(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..target = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
