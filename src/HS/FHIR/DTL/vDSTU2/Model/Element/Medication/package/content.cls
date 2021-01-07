/// What is  in the package.
Class HS.FHIR.DTL.vDSTU2.Model.Element.Medication.package.content Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Reference
/// <p>
/// A product in the package.
/// <p>
/// Medication
Property item As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "item", XMLPROJECTION = "ELEMENT") [ Required ];

/// SimpleQuantity
/// <p>
/// Quantity present in the package.
Property amount As HS.FHIR.DTL.vDSTU2.Model.Datatype.SimpleQuantity(XMLNAME = "amount", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Medication.package.content";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Medication.package.content";

}
