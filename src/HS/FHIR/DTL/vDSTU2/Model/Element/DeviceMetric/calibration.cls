/// Describes the calibrations that have been performed or that are required to be performed.
Class HS.FHIR.DTL.vDSTU2.Model.Element.DeviceMetric.calibration Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// code
/// <p>
/// unspecified | offset | gain | two-point
/// <p>
/// metric-calibration-type is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend metric-calibration-type and you may NOT use codes from other ValueSets.
Property type As %String(MAXLEN = 1000000, XMLNAME = "type", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// not-calibrated | calibration-required | calibrated | unspecified
/// <p>
/// metric-calibration-state is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend metric-calibration-state and you may NOT use codes from other ValueSets.
Property state As %String(MAXLEN = 1000000, XMLNAME = "state", XMLPROJECTION = "ATTRIBUTE");

/// instant
/// <p>
/// Describes the time last calibration has been performed.
Property time As %String(MAXLEN = 1000000, XMLNAME = "time", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "DeviceMetric.calibration";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "DeviceMetric.calibration";

}
