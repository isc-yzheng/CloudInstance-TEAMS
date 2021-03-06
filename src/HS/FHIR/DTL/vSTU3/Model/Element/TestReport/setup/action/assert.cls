/// The assertion to perform.
Class HS.FHIR.DTL.vSTU3.Model.Element.TestReport.setup.action.assert Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// code
/// <p>
/// pass | skip | fail | warning | error
/// <p>
/// report-action-result-codes is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend report-action-result-codes and you may NOT use codes from other ValueSets.
Property result As %String(MAXLEN = 1000000, XMLNAME = "result", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// markdown
/// <p>
/// A message associated with the result.
Property message As %String(MAXLEN = 1000000, XMLNAME = "message", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// A link to further details on the result.
Property detail As %String(MAXLEN = 1000000, XMLNAME = "detail", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "TestReport.setup.action.assert";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "TestReport.setup.action.assert";

}
