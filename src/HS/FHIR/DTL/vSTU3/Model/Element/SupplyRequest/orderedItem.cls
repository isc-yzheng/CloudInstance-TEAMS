/// The item being requested.
Class HS.FHIR.DTL.vSTU3.Model.Element.SupplyRequest.orderedItem Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Quantity
/// <p>
/// The requested amount of the item indicated.
Property quantity As HS.FHIR.DTL.vSTU3.Model.Datatype.Quantity(XMLNAME = "quantity", XMLPROJECTION = "ELEMENT") [ Required ];

/// CodeableConcept
/// <p>
/// Medication, 
/// Substance, 
/// or Device requested to be supplied.
/// <p>
/// any FHIR3 code may be used; 
/// supply-item shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property itemCodeableConcept As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "itemCodeableConcept", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Medication, 
/// Substance, 
/// or Device requested to be supplied.
/// <p>
/// Medication | Substance | Device
Property itemReference As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "itemReference", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "SupplyRequest.orderedItem";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "SupplyRequest.orderedItem";

}
