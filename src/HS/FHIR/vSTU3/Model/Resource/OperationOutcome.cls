/// A collection of error, warning or information messages that result from a system action.<br>
/// If the element is present, it must have either a @value, an @id, or extensions
Class HS.FHIR.vSTU3.Model.Resource.OperationOutcome Extends HS.FHIR.vSTU3.Model.Base.DomainResource [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "OperationOutcome";

Parameter XMLSEQUENCE = 1;

/// An error, warning or information message that results from a system action.
Property issue As list Of HS.FHIR.vSTU3.Model.Resource.OperationOutcome.Issue(XMLNAME = "issue", XMLPROJECTION = "ELEMENT");

}
