/// The referenced rule within the ruleset.
Class HS.FHIR.DTL.vSTU3.Model.Element.TestScript.ruleset.rule Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// id
/// <p>
/// Id of referenced rule within the ruleset.
Property ruleId As %String(MAXLEN = 1000000, XMLNAME = "ruleId", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// BackboneElement
/// <p>
/// Ruleset rule parameter template.
Property param As list Of HS.FHIR.DTL.vSTU3.Model.Element.TestScript.ruleset.rule.param(XMLNAME = "param", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "TestScript.ruleset.rule";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "TestScript.ruleset.rule";

}
