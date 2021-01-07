/// The assertion to perform.
Class HS.FHIR.DTL.vSTU3.Model.Element.TestScript.setup.action.assert Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// string
/// <p>
/// Tracking/logging assertion label.
Property label As %String(MAXLEN = 1000000, XMLNAME = "label", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Tracking/reporting assertion description.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// response | request
/// <p>
/// assert-direction-codes is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend assert-direction-codes and you may NOT use codes from other ValueSets.
Property direction As %String(MAXLEN = 1000000, XMLNAME = "direction", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Id of the source fixture to be evaluated.
Property compareToSourceId As %String(MAXLEN = 1000000, XMLNAME = "compareToSourceId", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// The fluentpath expression to evaluate against the source fixture.
Property compareToSourceExpression As %String(MAXLEN = 1000000, XMLNAME = "compareToSourceExpression", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// XPath or JSONPath expression to evaluate against the source fixture.
Property compareToSourcePath As %String(MAXLEN = 1000000, XMLNAME = "compareToSourcePath", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// xml | json | ttl | none
/// <p>
/// content-type is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend content-type and you may NOT use codes from other ValueSets.
Property contentType As %String(MAXLEN = 1000000, XMLNAME = "contentType", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// The fluentpath expression to be evaluated.
Property expression As %String(MAXLEN = 1000000, XMLNAME = "expression", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// HTTP header field name.
Property headerField As %String(MAXLEN = 1000000, XMLNAME = "headerField", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Fixture Id of minimum content resource.
Property minimumId As %String(MAXLEN = 1000000, XMLNAME = "minimumId", XMLPROJECTION = "ATTRIBUTE");

/// boolean
/// <p>
/// Perform validation on navigation links?
Property navigationLinks As %Boolean(XMLNAME = "navigationLinks", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// equals | notEquals | in | notIn | greaterThan | lessThan | empty | notEmpty | contains | notContains | eval
/// <p>
/// assert-operator-codes is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend assert-operator-codes and you may NOT use codes from other ValueSets.
Property operator As %String(MAXLEN = 1000000, XMLNAME = "operator", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// XPath or JSONPath expression.
Property path As %String(MAXLEN = 1000000, XMLNAME = "path", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// delete | get | options | patch | post | put
/// <p>
/// http-operations is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend http-operations and you may NOT use codes from other ValueSets.
Property requestMethod As %String(MAXLEN = 1000000, XMLNAME = "requestMethod", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Request URL comparison value.
Property requestURL As %String(MAXLEN = 1000000, XMLNAME = "requestURL", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// Resource type.
/// <p>
/// defined-types is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend defined-types and you may NOT use codes from other ValueSets.
Property resource As %String(MAXLEN = 1000000, XMLNAME = "resource", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// okay | created | noContent | notModified | bad | forbidden | notFound | methodNotAllowed | conflict | gone | preconditionFailed | unprocessable
/// <p>
/// assert-response-code-types is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend assert-response-code-types and you may NOT use codes from other ValueSets.
Property response As %String(MAXLEN = 1000000, XMLNAME = "response", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// HTTP response code to test.
Property responseCode As %String(MAXLEN = 1000000, XMLNAME = "responseCode", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// The reference to a TestScript:rule.
Property rule As HS.FHIR.DTL.vSTU3.Model.Element.TestScript.setup.action.assert.rule(XMLNAME = "rule", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// The reference to a TestScript:ruleset.
Property ruleset As HS.FHIR.DTL.vSTU3.Model.Element.TestScript.setup.action.assert.ruleset(XMLNAME = "ruleset", XMLPROJECTION = "ELEMENT");

/// id
/// <p>
/// Fixture Id of source expression or headerField.
Property sourceId As %String(MAXLEN = 1000000, XMLNAME = "sourceId", XMLPROJECTION = "ATTRIBUTE");

/// id
/// <p>
/// Profile Id of validation profile reference.
Property validateProfileId As %String(MAXLEN = 1000000, XMLNAME = "validateProfileId", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// The value to compare to.
Property value As %String(MAXLEN = 1000000, XMLNAME = "value", XMLPROJECTION = "ATTRIBUTE");

/// boolean
/// <p>
/// Will this assert produce a warning only on error?
Property warningOnly As %Boolean(XMLNAME = "warningOnly", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "TestScript.setup.action.assert";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "TestScript.setup.action.assert";

}
