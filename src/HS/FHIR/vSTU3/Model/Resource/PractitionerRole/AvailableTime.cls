/// A specific set of Roles/Locations/specialties/services that a practitioner may perform at an organization for a period of time.
Class HS.FHIR.vSTU3.Model.Resource.PractitionerRole.AvailableTime Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "PractitionerRole.AvailableTime";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "PractitionerRole.AvailableTime";

Parameter JSONTYPEFIELD;

/// Indicates which days of the week are available between the start and end Times.
Property daysOfWeek As list Of HS.FHIR.vSTU3.Model.Base.DaysOfWeek(XMLNAME = "daysOfWeek", XMLPROJECTION = "ELEMENT");

/// Is this always available? (hence times are irrelevant) e.g. 24 hour service.
Property allDay As HS.FHIR.vSTU3.Model.Datatype.Boolean(XMLNAME = "allDay", XMLPROJECTION = "ELEMENT");

/// The opening time of day. Note: If the AllDay flag is set, then this time is ignored.
Property availableStartTime As HS.FHIR.vSTU3.Model.Datatype.Time(XMLNAME = "availableStartTime", XMLPROJECTION = "ELEMENT");

/// The closing time of day. Note: If the AllDay flag is set, then this time is ignored.
Property availableEndTime As HS.FHIR.vSTU3.Model.Datatype.Time(XMLNAME = "availableEndTime", XMLPROJECTION = "ELEMENT");

/// Insert method for the "daysOfWeek" property.
Method SetDaysOfWeek(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.DaysOfWeek).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR DaysOfWeek object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set tSC = ..daysOfWeek.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "allDay" property.
Method SetAllDay(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Boolean).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Boolean object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..allDay = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "availableStartTime" property.
Method SetAvailableStartTime(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Time).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Time object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..availableStartTime = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "availableEndTime" property.
Method SetAvailableEndTime(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Time).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Time object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..availableEndTime = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
