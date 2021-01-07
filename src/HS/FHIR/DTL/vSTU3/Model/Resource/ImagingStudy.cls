/// Representation of the content produced in a DICOM imaging study. 
/// A study comprises a set of series, 
/// each of which includes a set of Service-Object Pair Instances (SOP Instances - images or other data) acquired or produced in a common context. 
/// A series is of only one modality (e.g. 
/// X-ray, 
/// CT, 
/// MR, 
/// ultrasound), 
/// but a study may have multiple series of different modalities.
Class HS.FHIR.DTL.vSTU3.Model.Resource.ImagingStudy Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// oid
/// <p>
/// Formal DICOM identifier for the study.
Property uid As %String(MAXLEN = 1000000, XMLNAME = "uid", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Identifier
/// <p>
/// Related workflow identifier ("Accession Number")
Property accession As HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "accession", XMLPROJECTION = "ELEMENT");

/// Identifier
/// <p>
/// Other identifiers for the study.
Property identifier As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// ONLINE | OFFLINE | NEARLINE | UNAVAILABLE
/// <p>
/// instance-availability is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend instance-availability and you may NOT use codes from other ValueSets.
Property availability As %String(MAXLEN = 1000000, XMLNAME = "availability", XMLPROJECTION = "ATTRIBUTE");

/// Coding
/// <p>
/// All series modality if actual acquisition modalities.
/// <p>
/// dicom-cid29 is the REQUIRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in dicom-cid29, 
/// you may formally EXTEND dicom-cid29 to add codes to it.
Property modalityList As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Coding(XMLNAME = "modalityList", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Who the images are of.
/// <p>
/// Patient
Property patient As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "patient", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Originating context.
/// <p>
/// Encounter | EpisodeOfCare
Property context As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "context", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// When the study was started.
Property started As %String(MAXLEN = 1000000, XMLNAME = "started", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Request fulfilled.
/// <p>
/// ReferralRequest | CarePlan | ProcedureRequest
Property basedOn As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "basedOn", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Referring physician.
/// <p>
/// Practitioner
Property referrer As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "referrer", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Who interpreted images.
/// <p>
/// Practitioner
Property interpreter As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "interpreter", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Study access endpoint.
/// <p>
/// Endpoint
Property endpoint As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "endpoint", XMLPROJECTION = "ELEMENT");

/// unsignedInt
/// <p>
/// Number of Study Related Series.
Property numberOfSeries As %Integer(XMLNAME = "numberOfSeries", XMLPROJECTION = "ATTRIBUTE");

/// unsignedInt
/// <p>
/// Number of Study Related Instances.
Property numberOfInstances As %Integer(XMLNAME = "numberOfInstances", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// The performed Procedure reference.
/// <p>
/// Procedure
Property procedureReference As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "procedureReference", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// The performed procedure code.
/// <p>
/// any FHIR3 code may be used; 
/// procedure-code shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property procedureCode As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "procedureCode", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Why the study was requested.
/// <p>
/// any FHIR3 code may be used; 
/// procedure-reason shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property reason As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "reason", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Institution-generated description.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Each study has one or more series of instances.
Property series As list Of HS.FHIR.DTL.vSTU3.Model.Element.ImagingStudy.series(XMLNAME = "series", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ImagingStudy";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ImagingStudy";

}
