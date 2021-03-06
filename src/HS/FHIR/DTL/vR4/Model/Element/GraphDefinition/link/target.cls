/// Potential target for the link.
Class HS.FHIR.DTL.vR4.Model.Element.GraphDefinition.link.target Extends HS.FHIR.DTL.vR4.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// code
/// <p>
/// Type of resource this link refers to.
/// <p>
/// resource-types|4.0.1 is the REQUIRED FHIR4 ValueSet for codes; 
/// you may NOT extend resource-types|4.0.1 and you may NOT use codes from other ValueSets.
Property type As %String(MAXLEN = 1000000, XMLNAME = "type", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// string
/// <p>
/// Criteria for reverse lookup.
Property params As %String(MAXLEN = 1000000, XMLNAME = "params", XMLPROJECTION = "ATTRIBUTE");

/// canonical
/// <p>
/// Profile for the target resource.
/// <p>
/// TO DO: Unrecognized value type for the FHIR4 model
Property profile As %String(MAXLEN = 1000000, XMLNAME = "profile", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Compartment Consistency Rules.
Property compartment As list Of HS.FHIR.DTL.vR4.Model.Element.GraphDefinition.link.target.compartment(XMLNAME = "compartment", XMLPROJECTION = "ELEMENT");

/// GraphDefinition:link
/// <p>
/// Additional links from target resource.
Property link As list Of HS.FHIR.DTL.vR4.Model.Element.GraphDefinition.link(XMLNAME = "link", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "GraphDefinition.link.target";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "GraphDefinition.link.target";

}
