/// A summary of information based on the results of executing a TestScript.
Class HS.FHIR.vSTU3.Model.Resource.TestReport.Setup Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "TestReport.Setup";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "TestReport.Setup";

Parameter JSONTYPEFIELD;

/// Action would contain either an operation or an assertion.
Property action As list Of HS.FHIR.vSTU3.Model.Resource.TestReport.Action(XMLNAME = "action", XMLPROJECTION = "ELEMENT");

}
