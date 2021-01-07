/// Each study has one or more series of instances.
Class HS.FHIR.DTL.vSTU3.Model.Element.ImagingStudy.series Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// oid
/// <p>
/// Formal DICOM identifier for this series.
Property uid As %String(MAXLEN = 1000000, XMLNAME = "uid", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// unsignedInt
/// <p>
/// Numeric identifier of this series.
Property number As %Integer(XMLNAME = "number", XMLPROJECTION = "ATTRIBUTE");

/// Coding
/// <p>
/// The modality of the instances in the series.
/// <p>
/// dicom-cid29 is the REQUIRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in dicom-cid29, 
/// you may formally EXTEND dicom-cid29 to add codes to it.
Property modality As HS.FHIR.DTL.vSTU3.Model.Datatype.Coding(XMLNAME = "modality", XMLPROJECTION = "ELEMENT") [ Required ];

/// string
/// <p>
/// A short human readable summary of the series.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

/// unsignedInt
/// <p>
/// Number of Series Related Instances.
Property numberOfInstances As %Integer(XMLNAME = "numberOfInstances", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// ONLINE | OFFLINE | NEARLINE | UNAVAILABLE
/// <p>
/// instance-availability is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend instance-availability and you may NOT use codes from other ValueSets.
Property availability As %String(MAXLEN = 1000000, XMLNAME = "availability", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Series access endpoint.
/// <p>
/// Endpoint
Property endpoint As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "endpoint", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// Body part examined.
/// <p>
/// any FHIR3 code may be used; 
/// body-site shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property bodySite As HS.FHIR.DTL.vSTU3.Model.Datatype.Coding(XMLNAME = "bodySite", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// Body part laterality.
/// <p>
/// any FHIR3 code may be used; 
/// bodysite-laterality shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property laterality As HS.FHIR.DTL.vSTU3.Model.Datatype.Coding(XMLNAME = "laterality", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// When the series started.
Property started As %String(MAXLEN = 1000000, XMLNAME = "started", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Who performed the series.
/// <p>
/// Practitioner
Property performer As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "performer", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// A single SOP instance from the series.
Property instance As list Of HS.FHIR.DTL.vSTU3.Model.Element.ImagingStudy.series.instance(XMLNAME = "instance", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ImagingStudy.series";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ImagingStudy.series";

}
