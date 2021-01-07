/// A single SOP instance from the series.
Class HS.FHIR.DTL.vDSTU2.Model.Element.ImagingStudy.series.instance Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// unsignedInt
/// <p>
/// The number of this instance in the series.
Property number As %Integer(XMLNAME = "number", XMLPROJECTION = "ATTRIBUTE");

/// oid
/// <p>
/// Formal identifier for this instance.
Property uid As %String(MAXLEN = 1000000, XMLNAME = "uid", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// oid
/// <p>
/// DICOM class type.
Property sopClass As %String(MAXLEN = 1000000, XMLNAME = "sopClass", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// string
/// <p>
/// Type of instance (image etc.)
Property type As %String(MAXLEN = 1000000, XMLNAME = "type", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Description of instance.
Property title As %String(MAXLEN = 1000000, XMLNAME = "title", XMLPROJECTION = "ATTRIBUTE");

/// Attachment
/// <p>
/// Content of the instance.
Property content As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Attachment(XMLNAME = "content", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ImagingStudy.series.instance";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ImagingStudy.series.instance";

}
