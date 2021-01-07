/// A photo, 
/// video, 
/// or audio recording acquired or used in healthcare. 
/// The actual content may be inline or provided by direct reference.
Class HS.FHIR.DTL.vSTU3.Model.Resource.Media Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Identifier(s) for the image.
Property identifier As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Procedure that caused this media to be created.
/// <p>
/// ProcedureRequest
Property basedOn As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "basedOn", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// photo | video | audio
/// <p>
/// digital-media-type is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend digital-media-type and you may NOT use codes from other ValueSets.
Property type As %String(MAXLEN = 1000000, XMLNAME = "type", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// CodeableConcept
/// <p>
/// The type of acquisition equipment/process.
/// <p>
/// any FHIR3 code may be used; 
/// digital-media-subtype shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property subtype As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "subtype", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Imaging view, 
/// e.g. 
/// Lateral or Antero-posterior.
/// <p>
/// any FHIR3 code may be used; 
/// media-view shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property view As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "view", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Who/What this Media is a record of.
/// <p>
/// Patient | Practitioner | Group | Device | Specimen
Property subject As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "subject", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Encounter / Episode associated with media.
/// <p>
/// Encounter | EpisodeOfCare
Property context As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "context", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// When Media was collected.
Property occurrenceDateTime As %String(MAXLEN = 1000000, XMLNAME = "occurrenceDateTime", XMLPROJECTION = "ATTRIBUTE");

/// Period
/// <p>
/// When Media was collected.
Property occurrencePeriod As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "occurrencePeriod", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// The person who generated the image.
/// <p>
/// Practitioner
Property operator As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "operator", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Why was event performed?
/// <p>
/// any FHIR3 code may be used; 
/// procedure-reason shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property reasonCode As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "reasonCode", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Body part in media.
/// <p>
/// any FHIR3 code may be used; 
/// body-site shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property bodySite As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "bodySite", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Observing Device.
/// <p>
/// Device | DeviceMetric
Property device As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "device", XMLPROJECTION = "ELEMENT");

/// positiveInt
/// <p>
/// Height of the image in pixels (photo/video)
Property height As %Integer(XMLNAME = "height", XMLPROJECTION = "ATTRIBUTE");

/// positiveInt
/// <p>
/// Width of the image in pixels (photo/video)
Property width As %Integer(XMLNAME = "width", XMLPROJECTION = "ATTRIBUTE");

/// positiveInt
/// <p>
/// Number of frames if > 1 (photo)
Property frames As %Integer(XMLNAME = "frames", XMLPROJECTION = "ATTRIBUTE");

/// unsignedInt
/// <p>
/// Length in seconds (audio / video)
Property duration As %Integer(XMLNAME = "duration", XMLPROJECTION = "ATTRIBUTE");

/// Attachment
/// <p>
/// Actual Media - reference or data.
Property content As HS.FHIR.DTL.vSTU3.Model.Datatype.Attachment(XMLNAME = "content", XMLPROJECTION = "ELEMENT") [ Required ];

/// Annotation
/// <p>
/// Comments made about the media.
Property note As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Annotation(XMLNAME = "note", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Media";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Media";

}
