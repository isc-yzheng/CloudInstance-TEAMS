/// The reference to a TestScript:rule.
Class HS.FHIR.DTL.vSTU3.Model.Element.TestScript.setup.action.assert.rule Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// id
/// <p>
/// Id of the TestScript:rule.
Property ruleId As %String(MAXLEN = 1000000, XMLNAME = "ruleId", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// BackboneElement
/// <p>
/// Rule parameter template.
Property param As list Of HS.FHIR.DTL.vSTU3.Model.Element.TestScript.setup.action.assert.rule.param(XMLNAME = "param", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "TestScript.setup.action.assert.rule";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "TestScript.setup.action.assert.rule";

}
