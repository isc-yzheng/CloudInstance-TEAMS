/// A series of required setup operations before tests are executed.
Class HS.FHIR.DTL.vR4.Model.Element.TestScript.setup Extends HS.FHIR.DTL.vR4.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// BackboneElement
/// <p>
/// A setup operation or assert to perform.
Property action As list Of HS.FHIR.DTL.vR4.Model.Element.TestScript.setup.action(XMLNAME = "action", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "TestScript.setup";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "TestScript.setup";

}
