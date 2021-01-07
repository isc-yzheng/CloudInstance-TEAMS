/// A photo, 
/// video, 
/// or audio recording acquired or used in healthcare. 
/// The actual content may be inline or provided by direct reference.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.Media Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// code
/// <p>
/// photo | video | audio
/// <p>
/// digital-media-type is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend digital-media-type and you may NOT use codes from other ValueSets.
Property type As %String(MAXLEN = 1000000, XMLNAME = "type", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// CodeableConcept
/// <p>
/// The type of acquisition equipment/process.
/// <p>
/// any FHIR2 code may be used; 
/// digital-media-subtype shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property subtype As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "subtype", XMLPROJECTION = "ELEMENT");

/// Identifier
/// <p>
/// Identifier(s) for the image.
Property identifier As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Who/What this Media is a record of.
/// <p>
/// Patient | Practitioner | Group | Device | Specimen
Property subject As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "subject", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// The person who generated the image.
/// <p>
/// Practitioner
Property operator As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "operator", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Imaging view, 
/// e.g. 
/// Lateral or Antero-posterior.
/// <p>
/// any FHIR2 code may be used; 
/// media-view shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property view As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "view", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Name of the device/manufacturer.
Property deviceName As %String(MAXLEN = 1000000, XMLNAME = "deviceName", XMLPROJECTION = "ATTRIBUTE");

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
Property content As HS.FHIR.DTL.vDSTU2.Model.Datatype.Attachment(XMLNAME = "content", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Media";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Media";

}
