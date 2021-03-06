/// Country where the name applies.
Class HS.FHIR.DTL.vR4.Model.Element.MedicinalProduct.name.countryLanguage Extends HS.FHIR.DTL.vR4.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// Country code for where this name applies.
/// <p>
/// any FHIR4 code from any ValueSet may be used.
Property country As HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "country", XMLPROJECTION = "ELEMENT") [ Required ];

/// CodeableConcept
/// <p>
/// Jurisdiction code for where this name applies.
/// <p>
/// any FHIR4 code from any ValueSet may be used.
Property jurisdiction As HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "jurisdiction", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Language code for this name.
/// <p>
/// any FHIR4 code from any ValueSet may be used.
Property language As HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "language", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "MedicinalProduct.name.countryLanguage";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "MedicinalProduct.name.countryLanguage";

}
