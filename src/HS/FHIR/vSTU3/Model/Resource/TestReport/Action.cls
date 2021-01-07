/// A summary of information based on the results of executing a TestScript.
Class HS.FHIR.vSTU3.Model.Resource.TestReport.Action Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "TestReport.Action";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "TestReport.Action";

Parameter JSONTYPEFIELD;

/// The operation performed.
Property operation As HS.FHIR.vSTU3.Model.Resource.TestReport.Operation(XMLNAME = "operation", XMLPROJECTION = "ELEMENT");

/// The results of the assertion performed on the previous operations.
Property assert As HS.FHIR.vSTU3.Model.Resource.TestReport.Assert(XMLNAME = "assert", XMLPROJECTION = "ELEMENT");

}
