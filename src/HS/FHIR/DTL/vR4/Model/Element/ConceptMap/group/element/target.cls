/// Concept in target system for element.
Class HS.FHIR.DTL.vR4.Model.Element.ConceptMap.group.element.target Extends HS.FHIR.DTL.vR4.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// code
/// <p>
/// Code that identifies the target element.
/// <p>
/// any FHIR4 code from any ValueSet may be used.
Property code As %String(MAXLEN = 1000000, XMLNAME = "code", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Display for the code.
Property display As %String(MAXLEN = 1000000, XMLNAME = "display", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// relatedto | equivalent | equal | wider | subsumes | narrower | specializes | inexact | unmatched | disjoint
/// <p>
/// concept-map-equivalence|4.0.1 is the REQUIRED FHIR4 ValueSet for codes; 
/// you may NOT extend concept-map-equivalence|4.0.1 and you may NOT use codes from other ValueSets.
Property equivalence As %String(MAXLEN = 1000000, XMLNAME = "equivalence", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// string
/// <p>
/// Description of status/issues in mapping.
Property comment As %String(MAXLEN = 1000000, XMLNAME = "comment", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Other elements required for this mapping (from context)
Property dependsOn As list Of HS.FHIR.DTL.vR4.Model.Element.ConceptMap.group.element.target.dependsOn(XMLNAME = "dependsOn", XMLPROJECTION = "ELEMENT");

/// ConceptMap:group[n].element[n].target[n].dependsOn
/// <p>
/// Other concepts that this mapping also produces.
Property product As list Of HS.FHIR.DTL.vR4.Model.Element.ConceptMap.group.element.target.dependsOn(XMLNAME = "product", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ConceptMap.group.element.target";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ConceptMap.group.element.target";

}
