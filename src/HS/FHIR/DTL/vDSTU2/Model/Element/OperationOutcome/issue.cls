/// A single issue associated with the action.
Class HS.FHIR.DTL.vDSTU2.Model.Element.OperationOutcome.issue Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// code
/// <p>
/// fatal | error | warning | information
/// <p>
/// issue-severity is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend issue-severity and you may NOT use codes from other ValueSets.
Property severity As %String(MAXLEN = 1000000, XMLNAME = "severity", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// code
/// <p>
/// Error or warning code.
/// <p>
/// issue-type is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend issue-type and you may NOT use codes from other ValueSets.
Property code As %String(MAXLEN = 1000000, XMLNAME = "code", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// CodeableConcept
/// <p>
/// Additional details about the error.
/// <p>
/// any FHIR2 code may be used; 
/// operation-outcome shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property details As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "details", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Additional diagnostic information about the issue.
Property diagnostics As %String(MAXLEN = 1000000, XMLNAME = "diagnostics", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// XPath of element(s) related to issue.
Property location As list Of %String(MAXLEN = 1000000, XMLNAME = "location", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "OperationOutcome.issue";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "OperationOutcome.issue";

}
