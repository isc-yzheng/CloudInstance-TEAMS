/// A structured set of tests against a FHIR server implementation to determine compliance against the FHIR specification.
Class HS.FHIR.vSTU3.Model.Resource.TestScript.Teardown Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "TestScript.Teardown";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "TestScript.Teardown";

Parameter JSONTYPEFIELD;

/// The teardown action will only contain an operation.
Property action As list Of HS.FHIR.vSTU3.Model.Resource.TestScript.Action2(XMLNAME = "action", XMLPROJECTION = "ELEMENT");

}
