Class HS.FHIR.vDSTU2.Model.Resource.TestScript.Setup Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "TestScript.Setup";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "TestScript.Setup";

/// Capabilities that must exist and are assumed to function correctly on the FHIR server being tested.
Property metadata As HS.FHIR.vDSTU2.Model.Resource.TestScript.Metadata(XMLNAME = "metadata");

/// Action would contain either an operation or an assertion.
Property action As list Of HS.FHIR.vDSTU2.Model.Resource.TestScript.Action(XMLNAME = "action", XMLPROJECTION = "ELEMENT") [ Required ];

}
