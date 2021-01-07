/// A summary of information based on the results of executing a TestScript.
Class HS.FHIR.vSTU3.Model.Resource.TestReport.Teardown Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "TestReport.Teardown";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "TestReport.Teardown";

Parameter JSONTYPEFIELD;

/// The teardown action will only contain an operation.
Property action As list Of HS.FHIR.vSTU3.Model.Resource.TestReport.Action2(XMLNAME = "action", XMLPROJECTION = "ELEMENT");

}
