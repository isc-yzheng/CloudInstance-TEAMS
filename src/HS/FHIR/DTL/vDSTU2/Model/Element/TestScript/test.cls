/// A test in this script.
Class HS.FHIR.DTL.vDSTU2.Model.Element.TestScript.test Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// string
/// <p>
/// Tracking/logging name of this test.
Property name As %String(MAXLEN = 1000000, XMLNAME = "name", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Tracking/reporting short description of the test.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

/// TestScript:metadata
/// <p>
/// Capabilities that are expected to function correctly on the FHIR server being tested.
Property metadata As HS.FHIR.DTL.vDSTU2.Model.Element.TestScript.metadata(XMLNAME = "metadata", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// A test operation or assert to perform.
Property action As list Of HS.FHIR.DTL.vDSTU2.Model.Element.TestScript.test.action(XMLNAME = "action", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "TestScript.test";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "TestScript.test";

}
