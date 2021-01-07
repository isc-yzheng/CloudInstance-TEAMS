/// Describes a measurement, calculation or setting capability of a medical device.
Class HS.FHIR.vSTU3.Model.Resource.DeviceMetric.Calibration Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "DeviceMetric.Calibration";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "DeviceMetric.Calibration";

Parameter JSONTYPEFIELD;

/// Describes the type of the calibration method.
Property type As HS.FHIR.vSTU3.Model.Base.DeviceMetricCalibrationType(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

/// Describes the state of the calibration.
Property state As HS.FHIR.vSTU3.Model.Base.DeviceMetricCalibrationState(XMLNAME = "state", XMLPROJECTION = "ELEMENT");

/// Describes the time last calibration has been performed.
Property time As HS.FHIR.vSTU3.Model.Datatype.Instant(XMLNAME = "time", XMLPROJECTION = "ELEMENT");

/// Set method for the "type" property.
Method SetType(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.DeviceMetricCalibrationType).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR DeviceMetricCalibrationType object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..type = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "state" property.
Method SetState(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.DeviceMetricCalibrationState).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR DeviceMetricCalibrationState object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..state = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "time" property.
Method SetTime(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Instant).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Instant object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..time = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
