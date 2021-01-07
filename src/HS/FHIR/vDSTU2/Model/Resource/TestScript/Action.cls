Class HS.FHIR.vDSTU2.Model.Resource.TestScript.Action Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "TestScript.Action";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "TestScript.Action";

/// The operation to perform.
Property operation As HS.FHIR.vDSTU2.Model.Resource.TestScript.Operation(XMLNAME = "operation");

/// Evaluates the results of previous operations to determine if the server under test behaves appropriately.
Property assert As HS.FHIR.vDSTU2.Model.Resource.TestScript.Assert(XMLNAME = "assert");

}
