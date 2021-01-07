/// Rule parameter template.
Class HS.FHIR.DTL.vSTU3.Model.Element.TestScript.setup.action.assert.ruleset.rule.param Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// string
/// <p>
/// Parameter name matching external assert ruleset rule parameter.
Property name As %String(MAXLEN = 1000000, XMLNAME = "name", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// string
/// <p>
/// Parameter value defined either explicitly or dynamically.
Property value As %String(MAXLEN = 1000000, XMLNAME = "value", XMLPROJECTION = "ATTRIBUTE") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "TestScript.setup.action.assert.ruleset.rule.param";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "TestScript.setup.action.assert.ruleset.rule.param";

}
