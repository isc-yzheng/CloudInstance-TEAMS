/// Composition information about the substance.
Class HS.FHIR.DTL.vDSTU2.Model.Element.Substance.ingredient Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Ratio
/// <p>
/// Optional amount (concentration)
Property quantity As HS.FHIR.DTL.vDSTU2.Model.Datatype.Ratio(XMLNAME = "quantity", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// A component of the substance.
/// <p>
/// Substance
Property substance As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "substance", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Substance.ingredient";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Substance.ingredient";

}
