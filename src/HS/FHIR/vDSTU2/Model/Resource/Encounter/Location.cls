Class HS.FHIR.vDSTU2.Model.Resource.Encounter.Location Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Encounter.Location";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Encounter.Location";

/// The location where the encounter takes place.
Property location As HS.FHIR.vDSTU2.Model.Base.Reference(XMLNAME = "location") [ Required ];

/// The status of the participants' presence at the specified location during the period specified. If the participant is is no longer at the location, then the period will have an end date/time.
Property status As HS.FHIR.vDSTU2.Model.Base.EncounterLocationStatus(XMLNAME = "status");

/// Time period during which the patient was present at the location.
Property period As HS.FHIR.vDSTU2.Model.Base.Period(XMLNAME = "period");

/// Set method for the "location" property.
Method SetLocation(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed") Quit
		Set ..location = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "status" property.
Method SetStatus(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.EncounterLocationStatus).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR EncounterLocationStatus object failed") Quit
		Set ..status = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "period" property.
Method SetPeriod(pStart As %String = "", pEnd As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Period).%New(pStart, pEnd, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Period object failed") Quit
		Set ..period = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
