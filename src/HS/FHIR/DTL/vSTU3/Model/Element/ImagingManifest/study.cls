/// Study identity of the selected instances.
Class HS.FHIR.DTL.vSTU3.Model.Element.ImagingManifest.study Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// oid
/// <p>
/// Study instance UID.
Property uid As %String(MAXLEN = 1000000, XMLNAME = "uid", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Reference
/// <p>
/// Reference to ImagingStudy.
/// <p>
/// ImagingStudy
Property imagingStudy As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "imagingStudy", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Study access service endpoint.
/// <p>
/// Endpoint
Property endpoint As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "endpoint", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Series identity of the selected instances.
Property series As list Of HS.FHIR.DTL.vSTU3.Model.Element.ImagingManifest.study.series(XMLNAME = "series", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ImagingManifest.study";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ImagingManifest.study";

}
