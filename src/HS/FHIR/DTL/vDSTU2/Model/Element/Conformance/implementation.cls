/// If this describes a specific instance.
Class HS.FHIR.DTL.vDSTU2.Model.Element.Conformance.implementation Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// string
/// <p>
/// Describes this specific instance.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// uri
/// <p>
/// Base URL for the installation.
Property url As %String(MAXLEN = 1000000, XMLNAME = "url", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Conformance.implementation";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Conformance.implementation";

}
