Class HS.FHIR.vDSTU2.Model.Resource.HealthcareService.AvailableTime Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "HealthcareService.AvailableTime";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "HealthcareService.AvailableTime";

/// Indicates which days of the week are available between the start and end Times.
Property daysOfWeek As list Of HS.FHIR.vDSTU2.Model.Base.DaysOfWeek(XMLNAME = "daysOfWeek", XMLPROJECTION = "ELEMENT");

/// Is this always available? (hence times are irrelevant) e.g. 24 hour service.
Property allDay As HS.FHIR.vDSTU2.Model.Datatype.Boolean(XMLNAME = "allDay");

/// The opening time of day. Note: If the AllDay flag is set, then this time is ignored.
Property availableStartTime As HS.FHIR.vDSTU2.Model.Datatype.Time(XMLNAME = "availableStartTime");

/// The closing time of day. Note: If the AllDay flag is set, then this time is ignored.
Property availableEndTime As HS.FHIR.vDSTU2.Model.Datatype.Time(XMLNAME = "availableEndTime");

/// Insert method for the "daysOfWeek" property.
Method SetDaysOfWeek(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.DaysOfWeek).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR DaysOfWeek object failed") Quit
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
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Boolean).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Boolean object failed") Quit
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
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Time).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Time object failed") Quit
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
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Time).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Time object failed") Quit
		Set ..availableEndTime = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
