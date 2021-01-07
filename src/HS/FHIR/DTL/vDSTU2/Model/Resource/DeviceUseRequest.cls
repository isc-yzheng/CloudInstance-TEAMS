/// A request for a patient to use or be given a medical device.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.DeviceUseRequest Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// Target body site.
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property bodySiteCodeableConcept As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "bodySiteCodeableConcept", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Target body site.
/// <p>
/// BodySite.
Property bodySiteReference As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "bodySiteReference", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// proposed | planned | requested | received | accepted | in-progress | completed | suspended | rejected | aborted
/// <p>
/// device-use-request-status is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend device-use-request-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Device requested.
/// <p>
/// Device
Property device As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "device", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Encounter motivating request.
/// <p>
/// Encounter
Property encounter As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "encounter", XMLPROJECTION = "ELEMENT");

/// Identifier
/// <p>
/// Request identifier.
Property identifier As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Reason for request.
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property indication As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "indication", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Notes or comments.
Property notes As list Of %String(MAXLEN = 1000000, XMLNAME = "notes", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// PRN.
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property prnReason As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "prnReason", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// When ordered.
Property orderedOn As %String(MAXLEN = 1000000, XMLNAME = "orderedOn", XMLPROJECTION = "ATTRIBUTE");

/// dateTime
/// <p>
/// When recorded.
Property recordedOn As %String(MAXLEN = 1000000, XMLNAME = "recordedOn", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Focus of request.
/// <p>
/// Patient
Property subject As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "subject", XMLPROJECTION = "ELEMENT") [ Required ];

/// dateTime
/// <p>
/// Schedule for use.
Property timingDateTime As %String(MAXLEN = 1000000, XMLNAME = "timingDateTime", XMLPROJECTION = "ATTRIBUTE");

/// Period
/// <p>
/// Schedule for use.
Property timingPeriod As HS.FHIR.DTL.vDSTU2.Model.Datatype.Period(XMLNAME = "timingPeriod", XMLPROJECTION = "ELEMENT");

/// Timing
/// <p>
/// Schedule for use.
Property timingTiming As HS.FHIR.DTL.vDSTU2.Model.Datatype.Timing(XMLNAME = "timingTiming", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// routine | urgent | stat | asap
/// <p>
/// device-use-request-priority is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend device-use-request-priority and you may NOT use codes from other ValueSets.
Property priority As %String(MAXLEN = 1000000, XMLNAME = "priority", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "DeviceUseRequest";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "DeviceUseRequest";

}
