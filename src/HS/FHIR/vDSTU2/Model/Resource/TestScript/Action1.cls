Class HS.FHIR.vDSTU2.Model.Resource.TestScript.Action1 Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "TestScript.Action1";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "TestScript.Action1";

/// An operation would involve a REST request to a server.
Property operation As HS.FHIR.vDSTU2.Model.Resource.TestScript.Operation(XMLNAME = "operation");

/// Evaluates the results of previous operations to determine if the server under test behaves appropriately.
Property assert As HS.FHIR.vDSTU2.Model.Resource.TestScript.Assert(XMLNAME = "assert");

}
