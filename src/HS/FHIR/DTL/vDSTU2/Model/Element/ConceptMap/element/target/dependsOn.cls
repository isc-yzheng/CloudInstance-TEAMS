/// Other elements required for this mapping (from context)
Class HS.FHIR.DTL.vDSTU2.Model.Element.ConceptMap.element.target.dependsOn Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// uri
/// <p>
/// Reference to element/field/ValueSet mapping depends on.
Property element As %String(MAXLEN = 1000000, XMLNAME = "element", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// uri
/// <p>
/// Code System (if necessary)
Property codeSystem As %String(MAXLEN = 1000000, XMLNAME = "codeSystem", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// string
/// <p>
/// Value of the referenced element.
Property code As %String(MAXLEN = 1000000, XMLNAME = "code", XMLPROJECTION = "ATTRIBUTE") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ConceptMap.element.target.dependsOn";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ConceptMap.element.target.dependsOn";

}
