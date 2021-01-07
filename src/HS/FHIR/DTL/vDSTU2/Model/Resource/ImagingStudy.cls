/// A set of images produced in single study (one or more series of references images)
Class HS.FHIR.DTL.vDSTU2.Model.Resource.ImagingStudy Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// dateTime
/// <p>
/// When the study was started.
Property started As %String(MAXLEN = 1000000, XMLNAME = "started", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Who the images are of.
/// <p>
/// Patient
Property patient As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "patient", XMLPROJECTION = "ELEMENT") [ Required ];

/// oid
/// <p>
/// Formal identifier for the study.
Property uid As %String(MAXLEN = 1000000, XMLNAME = "uid", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Identifier
/// <p>
/// Related workflow identifier ("Accession Number")
Property accession As HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "accession", XMLPROJECTION = "ELEMENT");

/// Identifier
/// <p>
/// Other identifiers for the study.
Property identifier As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Order(s) that caused this study to be performed.
/// <p>
/// DiagnosticOrder
Property order As list Of HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "order", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// All series modality if actual acquisition modalities.
/// <p>
/// dicom-cid29 is the REQUIRED FHIR2 ValueSet for codes, 
/// but if you need to express meanings not found in dicom-cid29, 
/// you may formally EXTEND dicom-cid29 to add codes to it.
Property modalityList As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "modalityList", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Referring physician (0008,0090)
/// <p>
/// Practitioner
Property referrer As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "referrer", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// ONLINE | OFFLINE | NEARLINE | UNAVAILABLE (0008,0056)
/// <p>
/// instance-availability is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend instance-availability and you may NOT use codes from other ValueSets.
Property availability As %String(MAXLEN = 1000000, XMLNAME = "availability", XMLPROJECTION = "ATTRIBUTE");

/// uri
/// <p>
/// Retrieve URI.
Property url As %String(MAXLEN = 1000000, XMLNAME = "url", XMLPROJECTION = "ATTRIBUTE");

/// unsignedInt
/// <p>
/// Number of Study Related Series.
Property numberOfSeries As %Integer(XMLNAME = "numberOfSeries", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// unsignedInt
/// <p>
/// Number of Study Related Instances.
Property numberOfInstances As %Integer(XMLNAME = "numberOfInstances", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Reference
/// <p>
/// Type of procedure performed.
/// <p>
/// Procedure
Property procedure As list Of HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "procedure", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Who interpreted images.
/// <p>
/// Practitioner
Property interpreter As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "interpreter", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Institution-generated description.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Each study has one or more series of instances.
Property series As list Of HS.FHIR.DTL.vDSTU2.Model.Element.ImagingStudy.series(XMLNAME = "series", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ImagingStudy";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ImagingStudy";

}
