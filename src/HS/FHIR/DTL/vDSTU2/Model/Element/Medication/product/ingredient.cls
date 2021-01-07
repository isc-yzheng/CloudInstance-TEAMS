/// Active or inactive ingredient.
Class HS.FHIR.DTL.vDSTU2.Model.Element.Medication.product.ingredient Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Reference
/// <p>
/// The product contained.
/// <p>
/// Substance | Medication
Property item As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "item", XMLPROJECTION = "ELEMENT") [ Required ];

/// Ratio
/// <p>
/// Quantity of ingredient present.
Property amount As HS.FHIR.DTL.vDSTU2.Model.Datatype.Ratio(XMLNAME = "amount", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Medication.product.ingredient";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Medication.product.ingredient";

}
