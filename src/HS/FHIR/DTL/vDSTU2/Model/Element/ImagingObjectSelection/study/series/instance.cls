/// The selected instance.
Class HS.FHIR.DTL.vDSTU2.Model.Element.ImagingObjectSelection.study.series.instance Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// oid
/// <p>
/// SOP class UID of instance.
Property sopClass As %String(MAXLEN = 1000000, XMLNAME = "sopClass", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// oid
/// <p>
/// Selected instance UID.
Property uid As %String(MAXLEN = 1000000, XMLNAME = "uid", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// uri
/// <p>
/// Retrieve instance URL.
Property url As %String(MAXLEN = 1000000, XMLNAME = "url", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// BackboneElement
/// <p>
/// The frame set.
Property frames As list Of HS.FHIR.DTL.vDSTU2.Model.Element.ImagingObjectSelection.study.series.instance.frames(XMLNAME = "frames", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ImagingObjectSelection.study.series.instance";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ImagingObjectSelection.study.series.instance";

}
