/// Links related to this Bundle.
Class HS.FHIR.DTL.vDSTU2.Model.Element.Bundle.link Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// string
/// <p>
/// http://www.iana.org/assignments/link-relations/link-relations.xhtml.
Property relation As %String(MAXLEN = 1000000, XMLNAME = "relation", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// uri
/// <p>
/// Reference details for the link.
Property url As %String(MAXLEN = 1000000, XMLNAME = "url", XMLPROJECTION = "ATTRIBUTE") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Bundle.link";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Bundle.link";

}
