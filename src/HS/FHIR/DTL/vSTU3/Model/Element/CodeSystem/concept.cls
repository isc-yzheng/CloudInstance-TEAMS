/// Concepts in the code system.
Class HS.FHIR.DTL.vSTU3.Model.Element.CodeSystem.concept Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// code
/// <p>
/// Code that identifies concept.
/// <p>
/// any FHIR3 code from any ValueSet may be used.
Property code As %String(MAXLEN = 1000000, XMLNAME = "code", XMLPROJECTION = "ATTRIBUTE") [ Required ];

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
Property designation As list Of HS.FHIR.DTL.vSTU3.Model.Element.CodeSystem.concept.designation(XMLNAME = "designation", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Property value for the concept.
Property property As list Of HS.FHIR.DTL.vSTU3.Model.Element.CodeSystem.concept.property(XMLNAME = "property", XMLPROJECTION = "ELEMENT");

/// CodeSystem:concept
/// <p>
/// Child Concepts (is-a/contains/categorizes)
Property concept As list Of HS.FHIR.DTL.vSTU3.Model.Element.CodeSystem.concept(XMLNAME = "concept", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "CodeSystem.concept";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "CodeSystem.concept";

}
