/// The reference to a TestScript:ruleset.
Class HS.FHIR.DTL.vSTU3.Model.Element.TestScript.setup.action.assert.ruleset Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// id
/// <p>
/// Id of the TestScript:ruleset.
Property rulesetId As %String(MAXLEN = 1000000, XMLNAME = "rulesetId", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// BackboneElement
/// <p>
/// The referenced rule within the ruleset.
Property rule As list Of HS.FHIR.DTL.vSTU3.Model.Element.TestScript.setup.action.assert.ruleset.rule(XMLNAME = "rule", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "TestScript.setup.action.assert.ruleset";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "TestScript.setup.action.assert.ruleset";

}
