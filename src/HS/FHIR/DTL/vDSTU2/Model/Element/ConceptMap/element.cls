/// Mappings for a concept from the source set.
Class HS.FHIR.DTL.vDSTU2.Model.Element.ConceptMap.element Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// uri
/// <p>
/// Code System (if value set crosses code systems)
Property codeSystem As %String(MAXLEN = 1000000, XMLNAME = "codeSystem", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// Identifies element being mapped.
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property code As %String(MAXLEN = 1000000, XMLNAME = "code", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Concept in target system for element.
Property target As list Of HS.FHIR.DTL.vDSTU2.Model.Element.ConceptMap.element.target(XMLNAME = "target", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ConceptMap.element";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ConceptMap.element";

}
