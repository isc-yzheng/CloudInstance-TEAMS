/// Fixture in the test script - by reference (uri)
Class HS.FHIR.DTL.vDSTU2.Model.Element.TestScript.fixture Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// boolean
/// <p>
/// Whether or not to implicitly create the fixture during setup.
Property autocreate As %Boolean(XMLNAME = "autocreate", XMLPROJECTION = "ATTRIBUTE");

/// boolean
/// <p>
/// Whether or not to implicitly delete the fixture during teardown.
Property autodelete As %Boolean(XMLNAME = "autodelete", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Reference of the resource.
/// <p>
/// Any FHIR2 Resource may be indicated by this Reference
Property resource As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "resource", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "TestScript.fixture";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "TestScript.fixture";

}
