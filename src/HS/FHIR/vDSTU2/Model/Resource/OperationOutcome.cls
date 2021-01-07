Class HS.FHIR.vDSTU2.Model.Resource.OperationOutcome Extends HS.FHIR.vDSTU2.Model.Base.DomainResource [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "OperationOutcome";

Parameter XMLSEQUENCE = 1;

/// An error, warning or information message that results from a system action.
Property issue As list Of HS.FHIR.vDSTU2.Model.Resource.OperationOutcome.Issue(XMLNAME = "issue", XMLPROJECTION = "ELEMENT") [ Required ];

}
