/// Measurement, 
/// calculation or setting capability of a medical device.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.DeviceMetric Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// Type of metric.
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property type As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT") [ Required ];

/// Identifier
/// <p>
/// Unique identifier of this DeviceMetric.
Property identifier As HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT") [ Required ];

/// CodeableConcept
/// <p>
/// Unit of metric.
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property unit As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "unit", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Describes the link to the source Device.
/// <p>
/// Device
Property source As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "source", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Describes the link to the parent DeviceComponent.
/// <p>
/// DeviceComponent
Property parent As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "parent", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// on | off | standby
/// <p>
/// metric-operational-status is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend metric-operational-status and you may NOT use codes from other ValueSets.
Property operationalStatus As %String(MAXLEN = 1000000, XMLNAME = "operationalStatus", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// black | red | green | yellow | blue | magenta | cyan | white
/// <p>
/// metric-color is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend metric-color and you may NOT use codes from other ValueSets.
Property color As %String(MAXLEN = 1000000, XMLNAME = "color", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// measurement | setting | calculation | unspecified
/// <p>
/// metric-category is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend metric-category and you may NOT use codes from other ValueSets.
Property category As %String(MAXLEN = 1000000, XMLNAME = "category", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Timing
/// <p>
/// Describes the measurement repetition time.
Property measurementPeriod As HS.FHIR.DTL.vDSTU2.Model.Datatype.Timing(XMLNAME = "measurementPeriod", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Describes the calibrations that have been performed or that are required to be performed.
Property calibration As list Of HS.FHIR.DTL.vDSTU2.Model.Element.DeviceMetric.calibration(XMLNAME = "calibration", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "DeviceMetric";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "DeviceMetric";

}
