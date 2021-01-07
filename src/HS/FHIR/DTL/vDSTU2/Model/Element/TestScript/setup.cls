/// A series of required setup operations before tests are executed.
Class HS.FHIR.DTL.vDSTU2.Model.Element.TestScript.setup Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// TestScript:metadata
/// <p>
/// Capabilities that are assumed to function correctly on the FHIR server being tested.
Property metadata As HS.FHIR.DTL.vDSTU2.Model.Element.TestScript.metadata(XMLNAME = "metadata", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// A setup operation or assert to perform.
Property action As list Of HS.FHIR.DTL.vDSTU2.Model.Element.TestScript.setup.action(XMLNAME = "action", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "TestScript.setup";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "TestScript.setup";

}
