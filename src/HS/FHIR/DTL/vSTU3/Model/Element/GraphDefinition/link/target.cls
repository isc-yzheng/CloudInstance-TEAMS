/// Potential target for the link.
Class HS.FHIR.DTL.vSTU3.Model.Element.GraphDefinition.link.target Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// code
/// <p>
/// Type of resource this link refers to.
/// <p>
/// resource-types is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend resource-types and you may NOT use codes from other ValueSets.
Property type As %String(MAXLEN = 1000000, XMLNAME = "type", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// uri
/// <p>
/// Profile for the target resource.
Property profile As %String(MAXLEN = 1000000, XMLNAME = "profile", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Compartment Consistency Rules.
Property compartment As list Of HS.FHIR.DTL.vSTU3.Model.Element.GraphDefinition.link.target.compartment(XMLNAME = "compartment", XMLPROJECTION = "ELEMENT");

/// GraphDefinition:link
/// <p>
/// Additional links from target resource.
Property link As list Of HS.FHIR.DTL.vSTU3.Model.Element.GraphDefinition.link(XMLNAME = "link", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "GraphDefinition.link.target";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "GraphDefinition.link.target";

}
