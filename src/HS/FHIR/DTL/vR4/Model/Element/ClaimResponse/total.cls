/// Adjudication totals.
Class HS.FHIR.DTL.vR4.Model.Element.ClaimResponse.total Extends HS.FHIR.DTL.vR4.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// Type of adjudication information.
/// <p>
/// any FHIR4 code may be used; 
/// adjudication shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property category As HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "category", XMLPROJECTION = "ELEMENT") [ Required ];

/// Money
/// <p>
/// Financial total for the category.
Property amount As HS.FHIR.DTL.vR4.Model.Datatype.Money(XMLNAME = "amount", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ClaimResponse.total";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ClaimResponse.total";

}
