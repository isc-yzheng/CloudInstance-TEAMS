/// Assert rule used within the test script.
Class HS.FHIR.DTL.vSTU3.Model.Element.TestScript.rule Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Reference
/// <p>
/// Assert rule resource reference.
/// <p>
/// Any FHIR3 Resource may be indicated by this Reference
Property resource As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "resource", XMLPROJECTION = "ELEMENT") [ Required ];

/// BackboneElement
/// <p>
/// Rule parameter template.
Property param As list Of HS.FHIR.DTL.vSTU3.Model.Element.TestScript.rule.param(XMLNAME = "param", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "TestScript.rule";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "TestScript.rule";

}
