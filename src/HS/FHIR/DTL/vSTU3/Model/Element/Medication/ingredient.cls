/// Active or inactive ingredient.
Class HS.FHIR.DTL.vSTU3.Model.Element.Medication.ingredient Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// The product contained.
/// <p>
/// any FHIR3 code from any ValueSet may be used.
Property itemCodeableConcept As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "itemCodeableConcept", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// The product contained.
/// <p>
/// Substance | Medication
Property itemReference As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "itemReference", XMLPROJECTION = "ELEMENT") [ Required ];

/// boolean
/// <p>
/// Active ingredient indicator.
Property isActive As %Boolean(XMLNAME = "isActive", XMLPROJECTION = "ATTRIBUTE");

/// Ratio
/// <p>
/// Quantity of ingredient present.
Property amount As HS.FHIR.DTL.vSTU3.Model.Datatype.Ratio(XMLNAME = "amount", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Medication.ingredient";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Medication.ingredient";

}
