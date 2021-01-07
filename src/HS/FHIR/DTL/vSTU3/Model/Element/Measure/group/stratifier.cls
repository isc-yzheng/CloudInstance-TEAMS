/// Stratifier criteria for the measure.
Class HS.FHIR.DTL.vSTU3.Model.Element.Measure.group.stratifier Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// The identifier for the stratifier used to coordinate the reported data back to this stratifier.
Property identifier As HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// How the measure should be stratified.
Property criteria As %String(MAXLEN = 1000000, XMLNAME = "criteria", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Path to the stratifier.
Property path As %String(MAXLEN = 1000000, XMLNAME = "path", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Measure.group.stratifier";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Measure.group.stratifier";

}
