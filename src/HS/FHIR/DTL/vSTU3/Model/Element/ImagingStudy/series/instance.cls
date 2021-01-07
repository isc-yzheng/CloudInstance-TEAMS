/// A single SOP instance from the series.
Class HS.FHIR.DTL.vSTU3.Model.Element.ImagingStudy.series.instance Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// oid
/// <p>
/// Formal DICOM identifier for this instance.
Property uid As %String(MAXLEN = 1000000, XMLNAME = "uid", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// unsignedInt
/// <p>
/// The number of this instance in the series.
Property number As %Integer(XMLNAME = "number", XMLPROJECTION = "ATTRIBUTE");

/// oid
/// <p>
/// DICOM class type.
Property sopClass As %String(MAXLEN = 1000000, XMLNAME = "sopClass", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// string
/// <p>
/// Description of instance.
Property title As %String(MAXLEN = 1000000, XMLNAME = "title", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ImagingStudy.series.instance";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ImagingStudy.series.instance";

}
