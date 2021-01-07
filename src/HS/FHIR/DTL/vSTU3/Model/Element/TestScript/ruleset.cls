/// Assert ruleset used within the test script.
Class HS.FHIR.DTL.vSTU3.Model.Element.TestScript.ruleset Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Reference
/// <p>
/// Assert ruleset resource reference.
/// <p>
/// Any FHIR3 Resource may be indicated by this Reference
Property resource As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "resource", XMLPROJECTION = "ELEMENT") [ Required ];

/// BackboneElement
/// <p>
/// The referenced rule within the ruleset.
Property rule As list Of HS.FHIR.DTL.vSTU3.Model.Element.TestScript.ruleset.rule(XMLNAME = "rule", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "TestScript.ruleset";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "TestScript.ruleset";

}
