Class HS.FHIR.vDSTU2.Model.Resource.DeviceMetric.Calibration Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "DeviceMetric.Calibration";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "DeviceMetric.Calibration";

/// Describes the type of the calibration method.
Property type As HS.FHIR.vDSTU2.Model.Base.DeviceMetricCalibrationType(XMLNAME = "type");

/// Describes the state of the calibration.
Property state As HS.FHIR.vDSTU2.Model.Base.DeviceMetricCalibrationState(XMLNAME = "state");

/// Describes the time last calibration has been performed.
Property time As HS.FHIR.vDSTU2.Model.Datatype.Instant(XMLNAME = "time") [ SqlFieldName = _time ];

/// Set method for the "type" property.
Method SetType(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.DeviceMetricCalibrationType).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR DeviceMetricCalibrationType object failed") Quit
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
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.DeviceMetricCalibrationState).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR DeviceMetricCalibrationState object failed") Quit
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
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Instant).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Instant object failed") Quit
		Set ..time = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
