/// A structured set of tests against a FHIR server implementation to determine compliance against the FHIR specification.
Class HS.FHIR.vSTU3.Model.Resource.TestScript.Metadata Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "TestScript.Metadata";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "TestScript.Metadata";

Parameter JSONTYPEFIELD;

/// A link to the FHIR specification that this test is covering.
Property link As list Of HS.FHIR.vSTU3.Model.Resource.TestScript.Link(XMLNAME = "link", XMLPROJECTION = "ELEMENT");

/// Capabilities that must exist and are assumed to function correctly on the FHIR server being tested.
Property capability As list Of HS.FHIR.vSTU3.Model.Resource.TestScript.Capability(XMLNAME = "capability", XMLPROJECTION = "ELEMENT");

}
