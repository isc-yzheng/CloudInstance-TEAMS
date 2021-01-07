Class HS.FHIR.vDSTU2.Model.Resource.TestScript.Teardown Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "TestScript.Teardown";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "TestScript.Teardown";

/// The teardown action will only contain an operation.
Property action As list Of HS.FHIR.vDSTU2.Model.Resource.TestScript.Action2(XMLNAME = "action", XMLPROJECTION = "ELEMENT") [ Required ];

}
