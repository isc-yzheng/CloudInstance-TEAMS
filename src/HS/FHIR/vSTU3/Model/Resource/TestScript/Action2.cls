/// A structured set of tests against a FHIR server implementation to determine compliance against the FHIR specification.
Class HS.FHIR.vSTU3.Model.Resource.TestScript.Action2 Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "TestScript.Action2";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "TestScript.Action2";

Parameter JSONTYPEFIELD;

/// An operation would involve a REST request to a server.
Property operation As HS.FHIR.vSTU3.Model.Resource.TestScript.Operation(XMLNAME = "operation", XMLPROJECTION = "ELEMENT") [ Required ];

}
