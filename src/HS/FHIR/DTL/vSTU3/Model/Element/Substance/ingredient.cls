/// Composition information about the substance.
Class HS.FHIR.DTL.vSTU3.Model.Element.Substance.ingredient Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Ratio
/// <p>
/// Optional amount (concentration)
Property quantity As HS.FHIR.DTL.vSTU3.Model.Datatype.Ratio(XMLNAME = "quantity", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// A component of the substance.
/// <p>
/// any FHIR3 code may be used; 
/// substance-code shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property substanceCodeableConcept As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "substanceCodeableConcept", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// A component of the substance.
/// <p>
/// Substance.
Property substanceReference As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "substanceReference", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Substance.ingredient";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Substance.ingredient";

}
