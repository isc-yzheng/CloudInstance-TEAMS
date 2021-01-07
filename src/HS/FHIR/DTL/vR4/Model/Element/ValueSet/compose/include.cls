/// Include one or more codes from a code system or other value set(s)
Class HS.FHIR.DTL.vR4.Model.Element.ValueSet.compose.include Extends HS.FHIR.DTL.vR4.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// uri
/// <p>
/// The system the codes come from.
Property system As %String(MAXLEN = 1000000, XMLNAME = "system", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Specific version of the code system referred to.
Property version As %String(MAXLEN = 1000000, XMLNAME = "version", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// A concept defined in the system.
Property concept As list Of HS.FHIR.DTL.vR4.Model.Element.ValueSet.compose.include.concept(XMLNAME = "concept", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Select codes/concepts by their properties (including relationships)
Property filter As list Of HS.FHIR.DTL.vR4.Model.Element.ValueSet.compose.include.filter(XMLNAME = "filter", XMLPROJECTION = "ELEMENT");

/// canonical
/// <p>
/// Select the contents included in this value set.
/// <p>
/// TO DO: Unrecognized value type for the FHIR4 model
Property valueSet As list Of %String(MAXLEN = 1000000, XMLNAME = "valueSet", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ValueSet.compose.include";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ValueSet.compose.include";

}
