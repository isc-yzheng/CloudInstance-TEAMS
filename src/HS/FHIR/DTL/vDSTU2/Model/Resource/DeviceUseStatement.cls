/// 
Class HS.FHIR.DTL.vDSTU2.Model.Resource.DeviceUseStatement Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
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

/// Period
Property whenUsed As HS.FHIR.DTL.vDSTU2.Model.Datatype.Period(XMLNAME = "whenUsed", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Device
Property device As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "device", XMLPROJECTION = "ELEMENT") [ Required ];

/// Identifier
Property identifier As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property indication As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "indication", XMLPROJECTION = "ELEMENT");

/// string
Property notes As list Of %String(MAXLEN = 1000000, XMLNAME = "notes", XMLPROJECTION = "ELEMENT");

/// dateTime
Property recordedOn As %String(MAXLEN = 1000000, XMLNAME = "recordedOn", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Patient
Property subject As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "subject", XMLPROJECTION = "ELEMENT") [ Required ];

/// dateTime
Property timingDateTime As %String(MAXLEN = 1000000, XMLNAME = "timingDateTime", XMLPROJECTION = "ATTRIBUTE");

/// Period
Property timingPeriod As HS.FHIR.DTL.vDSTU2.Model.Datatype.Period(XMLNAME = "timingPeriod", XMLPROJECTION = "ELEMENT");

/// Timing
Property timingTiming As HS.FHIR.DTL.vDSTU2.Model.Datatype.Timing(XMLNAME = "timingTiming", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "DeviceUseStatement";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "DeviceUseStatement";

}
