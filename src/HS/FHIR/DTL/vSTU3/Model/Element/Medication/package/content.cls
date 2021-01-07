/// What is in the package.
Class HS.FHIR.DTL.vSTU3.Model.Element.Medication.package.content Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// The item in the package.
/// <p>
/// any FHIR3 code from any ValueSet may be used.
Property itemCodeableConcept As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "itemCodeableConcept", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// The item in the package.
/// <p>
/// Medication.
Property itemReference As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "itemReference", XMLPROJECTION = "ELEMENT") [ Required ];

/// SimpleQuantity
/// <p>
/// Quantity present in the package.
Property amount As HS.FHIR.DTL.vSTU3.Model.Datatype.SimpleQuantity(XMLNAME = "amount", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Medication.package.content";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Medication.package.content";

}
