/// The frame set.
Class HS.FHIR.DTL.vDSTU2.Model.Element.ImagingObjectSelection.study.series.instance.frames Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// unsignedInt
/// <p>
/// Frame numbers.
Property frameNumbers As list Of %Integer(XMLNAME = "frameNumbers", XMLPROJECTION = "ELEMENT") [ Required ];

/// uri
/// <p>
/// Retrieve frame URL.
Property url As %String(MAXLEN = 1000000, XMLNAME = "url", XMLPROJECTION = "ATTRIBUTE") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ImagingObjectSelection.study.series.instance.frames";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ImagingObjectSelection.study.series.instance.frames";

}
