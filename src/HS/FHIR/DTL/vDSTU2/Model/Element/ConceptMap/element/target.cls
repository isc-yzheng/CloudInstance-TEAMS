/// Concept in target system for element.
Class HS.FHIR.DTL.vDSTU2.Model.Element.ConceptMap.element.target Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// uri
/// <p>
/// System of the target (if necessary)
Property codeSystem As %String(MAXLEN = 1000000, XMLNAME = "codeSystem", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// Code that identifies the target element.
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property code As %String(MAXLEN = 1000000, XMLNAME = "code", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// equivalent | equal | wider | subsumes | narrower | specializes | inexact | unmatched | disjoint
/// <p>
/// concept-map-equivalence is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend concept-map-equivalence and you may NOT use codes from other ValueSets.
Property equivalence As %String(MAXLEN = 1000000, XMLNAME = "equivalence", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// string
/// <p>
/// Description of status/issues in mapping.
Property comments As %String(MAXLEN = 1000000, XMLNAME = "comments", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Other elements required for this mapping (from context)
Property dependsOn As list Of HS.FHIR.DTL.vDSTU2.Model.Element.ConceptMap.element.target.dependsOn(XMLNAME = "dependsOn", XMLPROJECTION = "ELEMENT");

/// ConceptMap:element[n].target[n].dependsOn
/// <p>
/// Other concepts that this mapping also produces.
Property product As list Of HS.FHIR.DTL.vDSTU2.Model.Element.ConceptMap.element.target.dependsOn(XMLNAME = "product", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ConceptMap.element.target";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ConceptMap.element.target";

}
