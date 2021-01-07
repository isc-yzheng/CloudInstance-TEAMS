/// The selected instance.
Class HS.FHIR.DTL.vSTU3.Model.Element.ImagingManifest.study.series.instance Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// oid
/// <p>
/// SOP class UID of instance.
Property sopClass As %String(MAXLEN = 1000000, XMLNAME = "sopClass", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// oid
/// <p>
/// Selected instance UID.
Property uid As %String(MAXLEN = 1000000, XMLNAME = "uid", XMLPROJECTION = "ATTRIBUTE") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ImagingManifest.study.series.instance";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ImagingManifest.study.series.instance";

}
