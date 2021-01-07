/// A record of a device being used by a patient where the record is the result of a report from the patient or another clinician. 
/// NOTE: These resources have not yet undergone proper review by PC, 
/// CQI, 
/// CDS, 
/// and OO. 
/// At this time, 
/// they are to be considered only as draft resource proposals for potential submission.
Class HS.FHIR.DTL.vSTU3.Model.Resource.DeviceUseStatement Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// External identifier for this record.
Property identifier As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// active | completed | entered-in-error +
/// <p>
/// device-statement-status is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend device-statement-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Reference
/// <p>
/// Patient using device.
/// <p>
/// Patient | Group
Property subject As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "subject", XMLPROJECTION = "ELEMENT") [ Required ];

/// Period
/// <p>
/// Period device was used.
Property whenUsed As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "whenUsed", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
///  How often  the device was used.
Property timingDateTime As %String(MAXLEN = 1000000, XMLNAME = "timingDateTime", XMLPROJECTION = "ATTRIBUTE");

/// Period
/// <p>
///  How often  the device was used.
Property timingPeriod As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "timingPeriod", XMLPROJECTION = "ELEMENT");

/// Timing
/// <p>
///  How often  the device was used.
Property timingTiming As HS.FHIR.DTL.vSTU3.Model.Datatype.Timing(XMLNAME = "timingTiming", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// When statement was recorded.
Property recordedOn As %String(MAXLEN = 1000000, XMLNAME = "recordedOn", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Who made the statement.
/// <p>
/// Patient | Practitioner | RelatedPerson
Property source As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "source", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Reference to device used.
/// <p>
/// Device
Property device As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "device", XMLPROJECTION = "ELEMENT") [ Required ];

/// CodeableConcept
/// <p>
/// Why device was used.
/// <p>
/// any FHIR3 code from any ValueSet may be used.
Property indication As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "indication", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Target body site.
/// <p>
/// any FHIR3 code may be used; 
/// body-site shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property bodySite As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "bodySite", XMLPROJECTION = "ELEMENT");

/// Annotation
/// <p>
/// Addition details (comments, 
/// instructions)
Property note As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Annotation(XMLNAME = "note", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "DeviceUseStatement";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "DeviceUseStatement";

}
