/// Study identity of the selected instances.
Class HS.FHIR.DTL.vDSTU2.Model.Element.ImagingObjectSelection.study Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// oid
/// <p>
/// Study instance UID.
Property uid As %String(MAXLEN = 1000000, XMLNAME = "uid", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// uri
/// <p>
/// Retrieve study URL.
Property url As %String(MAXLEN = 1000000, XMLNAME = "url", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Reference to ImagingStudy.
/// <p>
/// ImagingStudy
Property imagingStudy As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "imagingStudy", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Series identity of the selected instances.
Property series As list Of HS.FHIR.DTL.vDSTU2.Model.Element.ImagingObjectSelection.study.series(XMLNAME = "series", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ImagingObjectSelection.study";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ImagingObjectSelection.study";

}
