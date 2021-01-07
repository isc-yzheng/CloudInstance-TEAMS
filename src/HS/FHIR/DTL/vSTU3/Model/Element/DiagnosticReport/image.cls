/// Key images associated with this report.
Class HS.FHIR.DTL.vSTU3.Model.Element.DiagnosticReport.image Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// string
/// <p>
/// Comment about the image (e.g. 
/// explanation)
Property comment As %String(MAXLEN = 1000000, XMLNAME = "comment", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Reference to the image source.
/// <p>
/// Media
Property link As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "link", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "DiagnosticReport.image";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "DiagnosticReport.image";

}
