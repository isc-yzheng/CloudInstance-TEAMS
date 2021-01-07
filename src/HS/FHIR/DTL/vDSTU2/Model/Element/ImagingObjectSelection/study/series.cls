/// Series identity of the selected instances.
Class HS.FHIR.DTL.vDSTU2.Model.Element.ImagingObjectSelection.study.series Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// oid
/// <p>
/// Series instance UID.
Property uid As %String(MAXLEN = 1000000, XMLNAME = "uid", XMLPROJECTION = "ATTRIBUTE");

/// uri
/// <p>
/// Retrieve series URL.
Property url As %String(MAXLEN = 1000000, XMLNAME = "url", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// The selected instance.
Property instance As list Of HS.FHIR.DTL.vDSTU2.Model.Element.ImagingObjectSelection.study.series.instance(XMLNAME = "instance", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ImagingObjectSelection.study.series";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ImagingObjectSelection.study.series";

}
