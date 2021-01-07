/// Condition that must evaluate to true.
Class HS.FHIR.DTL.vDSTU2.Model.Element.ElementDefinition.constraint Extends HS.FHIR.DTL.vDSTU2.Model.Base.Element [ Not ProcedureBlock ]
{

/// id
/// <p>
/// Target of 'condition' reference above.
Property key As %String(MAXLEN = 1000000, XMLNAME = "key", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// string
/// <p>
/// Why this constraint is necessary or appropriate.
Property requirements As %String(MAXLEN = 1000000, XMLNAME = "requirements", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// error | warning
/// <p>
/// constraint-severity is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend constraint-severity and you may NOT use codes from other ValueSets.
Property severity As %String(MAXLEN = 1000000, XMLNAME = "severity", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// string
/// <p>
/// Human description of constraint.
Property human As %String(MAXLEN = 1000000, XMLNAME = "human", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// string
/// <p>
/// XPath expression of constraint.
Property xpath As %String(MAXLEN = 1000000, XMLNAME = "xpath", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "constraint";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "constraint";

}
