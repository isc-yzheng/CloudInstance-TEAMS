/// When value set includes codes from elsewhere.
Class HS.FHIR.DTL.vDSTU2.Model.Element.ValueSet.compose Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// uri
/// <p>
/// Import the contents of another value set.
Property import As list Of %String(MAXLEN = 1000000, XMLNAME = "import", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Include one or more codes from a code system.
Property include As list Of HS.FHIR.DTL.vDSTU2.Model.Element.ValueSet.compose.include(XMLNAME = "include", XMLPROJECTION = "ELEMENT");

/// ValueSet:compose.include
/// <p>
/// Explicitly exclude codes.
Property exclude As list Of HS.FHIR.DTL.vDSTU2.Model.Element.ValueSet.compose.include(XMLNAME = "exclude", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ValueSet.compose";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ValueSet.compose";

}
