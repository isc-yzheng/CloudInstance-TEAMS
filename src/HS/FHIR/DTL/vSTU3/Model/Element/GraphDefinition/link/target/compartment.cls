/// Compartment Consistency Rules.
Class HS.FHIR.DTL.vSTU3.Model.Element.GraphDefinition.link.target.compartment Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// code
/// <p>
/// Identifies the compartment.
/// <p>
/// compartment-type is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend compartment-type and you may NOT use codes from other ValueSets.
Property code As %String(MAXLEN = 1000000, XMLNAME = "code", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// code
/// <p>
/// identical | matching | different | custom
/// <p>
/// graph-compartment-rule is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend graph-compartment-rule and you may NOT use codes from other ValueSets.
Property rule As %String(MAXLEN = 1000000, XMLNAME = "rule", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// string
/// <p>
/// Custom rule, 
/// as a FHIRPath expression.
Property expression As %String(MAXLEN = 1000000, XMLNAME = "expression", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Documentation for FHIRPath expression.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "GraphDefinition.link.target.compartment";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "GraphDefinition.link.target.compartment";

}
