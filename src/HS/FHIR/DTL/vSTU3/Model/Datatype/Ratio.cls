/// A relationship between two Quantity values expressed as a numerator and a denominator.
Class HS.FHIR.DTL.vSTU3.Model.Datatype.Ratio Extends HS.FHIR.DTL.vSTU3.Model.Base.Element [ Not ProcedureBlock ]
{

/// Quantity
/// <p>
/// Numerator value.
Property numerator As HS.FHIR.DTL.vSTU3.Model.Datatype.Quantity(XMLNAME = "numerator", XMLPROJECTION = "ELEMENT");

/// Quantity
/// <p>
/// Denominator value.
Property denominator As HS.FHIR.DTL.vSTU3.Model.Datatype.Quantity(XMLNAME = "denominator", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Ratio";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Ratio";

}
