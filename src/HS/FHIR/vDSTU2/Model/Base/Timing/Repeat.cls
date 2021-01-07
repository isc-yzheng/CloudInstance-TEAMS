Class HS.FHIR.vDSTU2.Model.Base.Timing.Repeat Extends HS.FHIR.vDSTU2.Model.Base.Element [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Timing.Repeat";

Parameter XMLSEQUENCE = 0;

Parameter XMLTYPE = "Timing.Repeat";

Property boundsQuantity As HS.FHIR.vDSTU2.Model.Base.Duration(XMLNAME = "boundsQuantity");

Property boundsRange As HS.FHIR.vDSTU2.Model.Base.Range(XMLNAME = "boundsRange");

Property boundsPeriod As HS.FHIR.vDSTU2.Model.Base.Period(XMLNAME = "boundsPeriod");

/// A total count of the desired number of repetitions.
Property count As HS.FHIR.vDSTU2.Model.Datatype.Integer(XMLNAME = "count") [ SqlFieldName = _count ];

/// How long this thing happens for when it happens.
Property duration As HS.FHIR.vDSTU2.Model.Datatype.Decimal(XMLNAME = "duration");

/// The upper limit of how long this thing happens for when it happens.
Property durationMax As HS.FHIR.vDSTU2.Model.Datatype.Decimal(XMLNAME = "durationMax");

/// The units of time for the duration, in UCUM units.
Property durationUnits As HS.FHIR.vDSTU2.Model.Base.UnitsOfTime(XMLNAME = "durationUnits");

/// The number of times to repeat the action within the specified period / period range (i.e. both period and periodMax provided).
Property frequency As HS.FHIR.vDSTU2.Model.Datatype.Integer(XMLNAME = "frequency");

/// If present, indicates that the frequency is a range - so repeat between [frequency] and [frequencyMax] times within the period or period range.
Property frequencyMax As HS.FHIR.vDSTU2.Model.Datatype.Integer(XMLNAME = "frequencyMax");

/// Indicates the duration of time over which repetitions are to occur; e.g. to express"3 times per day", 3 would be the frequency and"1 day" would be the period.
Property period As HS.FHIR.vDSTU2.Model.Datatype.Decimal(XMLNAME = "period");

/// If present, indicates that the period is a range from [period] to [periodMax], allowing expressing concepts such as"do this once every 3-5 days.
Property periodMax As HS.FHIR.vDSTU2.Model.Datatype.Decimal(XMLNAME = "periodMax");

/// The units of time for the period in UCUM units.
Property periodUnits As HS.FHIR.vDSTU2.Model.Base.UnitsOfTime(XMLNAME = "periodUnits");

/// A real world event that the occurrence of the event should be tied to.
Property when As HS.FHIR.vDSTU2.Model.Base.EventTiming(XMLNAME = "when") [ SqlFieldName = _when ];

/// Set method for the "boundsPeriod" property.
Method SetBoundsPeriod(pStart As %String = "", pEnd As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Period).%New(pStart, pEnd, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Period object failed") Quit
		Set ..boundsPeriod = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "count" property.
Method SetCount(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Integer).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Integer object failed") Quit
		Set ..count = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "duration" property.
Method SetDuration(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Decimal).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Decimal object failed") Quit
		Set ..duration = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "durationMax" property.
Method SetDurationMax(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Decimal).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Decimal object failed") Quit
		Set ..durationMax = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "durationUnits" property.
Method SetDurationUnits(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.UnitsOfTime).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR UnitsOfTime object failed") Quit
		Set ..durationUnits = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "frequency" property.
Method SetFrequency(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Integer).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Integer object failed") Quit
		Set ..frequency = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "frequencyMax" property.
Method SetFrequencyMax(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Integer).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Integer object failed") Quit
		Set ..frequencyMax = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "period" property.
Method SetPeriod(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Decimal).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Decimal object failed") Quit
		Set ..period = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "periodMax" property.
Method SetPeriodMax(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Decimal).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Decimal object failed") Quit
		Set ..periodMax = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "periodUnits" property.
Method SetPeriodUnits(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.UnitsOfTime).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR UnitsOfTime object failed") Quit
		Set ..periodUnits = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "when" property.
Method SetWhen(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.EventTiming).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR EventTiming object failed") Quit
		Set ..when = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
