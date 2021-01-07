/// A structured set of tests against a FHIR server implementation to determine compliance against the FHIR specification.
Class HS.FHIR.vSTU3.Model.Resource.TestScript.Action1 Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "TestScript.Action1";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "TestScript.Action1";

Parameter JSONTYPEFIELD;

/// An operation would involve a REST request to a server.
Property operation As HS.FHIR.vSTU3.Model.Resource.TestScript.Operation(XMLNAME = "operation", XMLPROJECTION = "ELEMENT");

/// Evaluates the results of previous operations to determine if the server under test behaves appropriately.
Property assert As HS.FHIR.vSTU3.Model.Resource.TestScript.Assert(XMLNAME = "assert", XMLPROJECTION = "ELEMENT");

}
