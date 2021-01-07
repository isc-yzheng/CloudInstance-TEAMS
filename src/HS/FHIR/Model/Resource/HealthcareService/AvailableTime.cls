/// *** <b>THIS CLASS IS DEPRECATED.</b> Please use HS.FHIR.<b>vDSTU2.</b>Model.Resource.HealthcareService.AvailableTime when working with FHIR DSTU2.
Class HS.FHIR.Model.Resource.HealthcareService.AvailableTime Extends HS.FHIR.Model.Base.BackboneElement [ Deprecated, ProcedureBlock ]
{

///  
Parameter JSONTYPEFIELD;

///  
Parameter ELEMENTQUALIFIED = 1;

///  
Parameter XMLNAME = "HealthcareService.AvailableTime";

///  
Parameter XMLSEQUENCE = 1;

///  
Parameter XMLTYPE = "HealthcareService.AvailableTime";

///  
Property daysOfWeek As list Of HS.FHIR.Model.Base.DaysOfWeek(XMLNAME = "daysOfWeek", XMLPROJECTION = "ELEMENT");

///  
Property allDay As HS.FHIR.Model.Datatype.Boolean(XMLNAME = "allDay");

///  
Property availableStartTime As HS.FHIR.Model.Datatype.Time(XMLNAME = "availableStartTime");

///  
Property availableEndTime As HS.FHIR.Model.Datatype.Time(XMLNAME = "availableEndTime");

///  
Method SetDaysOfWeek(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Base.DaysOfWeek).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR DaysOfWeek object failed") Quit
		Set tSC = ..daysOfWeek.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  
Method SetAllDay(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Datatype.Boolean).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Boolean object failed") Quit
		Set ..allDay = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  
Method SetAvailableStartTime(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Datatype.Time).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Time object failed") Quit
		Set ..availableStartTime = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  
Method SetAvailableEndTime(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Datatype.Time).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Time object failed") Quit
		Set ..availableEndTime = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
