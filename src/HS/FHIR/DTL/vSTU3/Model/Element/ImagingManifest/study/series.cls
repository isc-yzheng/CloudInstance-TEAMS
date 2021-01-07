/// Series identity of the selected instances.
Class HS.FHIR.DTL.vSTU3.Model.Element.ImagingManifest.study.series Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// oid
/// <p>
/// Series instance UID.
Property uid As %String(MAXLEN = 1000000, XMLNAME = "uid", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Reference
/// <p>
/// Series access endpoint.
/// <p>
/// Endpoint
Property endpoint As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "endpoint", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// The selected instance.
Property instance As list Of HS.FHIR.DTL.vSTU3.Model.Element.ImagingManifest.study.series.instance(XMLNAME = "instance", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ImagingManifest.study.series";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ImagingManifest.study.series";

}
