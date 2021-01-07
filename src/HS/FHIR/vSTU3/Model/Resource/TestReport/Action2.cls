/// A summary of information based on the results of executing a TestScript.
Class HS.FHIR.vSTU3.Model.Resource.TestReport.Action2 Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "TestReport.Action2";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "TestReport.Action2";

Parameter JSONTYPEFIELD;

/// An operation would involve a REST request to a server.
Property operation As HS.FHIR.vSTU3.Model.Resource.TestReport.Operation(XMLNAME = "operation", XMLPROJECTION = "ELEMENT") [ Required ];

}
