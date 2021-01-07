/// Concepts in the code system.
Class HS.FHIR.DTL.vDSTU2.Model.Element.ValueSet.codeSystem.concept Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// code
/// <p>
/// Code that identifies concept.
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property code As %String(MAXLEN = 1000000, XMLNAME = "code", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// boolean
/// <p>
/// If this code is not for use as a real concept.
Property abstract As %Boolean(XMLNAME = "abstract", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Text to display to the user.
Property display As %String(MAXLEN = 1000000, XMLNAME = "display", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Formal definition.
Property definition As %String(MAXLEN = 1000000, XMLNAME = "definition", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Additional representations for the concept.
Property designation As list Of HS.FHIR.DTL.vDSTU2.Model.Element.ValueSet.codeSystem.concept.designation(XMLNAME = "designation", XMLPROJECTION = "ELEMENT");

/// ValueSet:codeSystem.concept
/// <p>
/// Child Concepts (is-a/contains/categorizes)
Property concept As list Of HS.FHIR.DTL.vDSTU2.Model.Element.ValueSet.codeSystem.concept(XMLNAME = "concept", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ValueSet.codeSystem.concept";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ValueSet.codeSystem.concept";

}
