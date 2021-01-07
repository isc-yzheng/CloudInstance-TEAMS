/// A structured set of tests against a FHIR server implementation to determine compliance against the FHIR specification.
Class HS.FHIR.vSTU3.Model.Resource.TestScript.Setup Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "TestScript.Setup";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "TestScript.Setup";

Parameter JSONTYPEFIELD;

/// Action would contain either an operation or an assertion.
Property action As list Of HS.FHIR.vSTU3.Model.Resource.TestScript.Action(XMLNAME = "action", XMLPROJECTION = "ELEMENT");

}
