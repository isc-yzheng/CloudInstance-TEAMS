/// A set of ordered Quantity values defined by a low and high limit. 
/// A Range specifies a set of possible values; 
/// usually, 
/// one value from the range applies (e.g. 
/// "give the patient between 2 and 4 tablets"). 
/// Ranges are typically used in instructions.
Class HS.FHIR.DTL.vDSTU2.Model.Datatype.Range Extends HS.FHIR.DTL.vDSTU2.Model.Base.Element [ Not ProcedureBlock ]
{

/// SimpleQuantity
/// <p>
/// Low limit.
Property low As HS.FHIR.DTL.vDSTU2.Model.Datatype.SimpleQuantity(XMLNAME = "low", XMLPROJECTION = "ELEMENT");

/// SimpleQuantity
/// <p>
/// High limit.
Property high As HS.FHIR.DTL.vDSTU2.Model.Datatype.SimpleQuantity(XMLNAME = "high", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Range";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Range";

}
