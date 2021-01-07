/// A concept defined in the system.
Class HS.FHIR.DTL.vDSTU2.Model.Element.ValueSet.compose.include.concept Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// code
/// <p>
/// Code or expression from system.
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property code As %String(MAXLEN = 1000000, XMLNAME = "code", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// string
/// <p>
/// Test to display for this code for this value set.
Property display As %String(MAXLEN = 1000000, XMLNAME = "display", XMLPROJECTION = "ATTRIBUTE");

/// ValueSet:codeSystem.concept[n].designation
/// <p>
/// Additional representations for this valueset.
Property designation As list Of HS.FHIR.DTL.vDSTU2.Model.Element.ValueSet.codeSystem.concept.designation(XMLNAME = "designation", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ValueSet.compose.include.concept";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ValueSet.compose.include.concept";

}
