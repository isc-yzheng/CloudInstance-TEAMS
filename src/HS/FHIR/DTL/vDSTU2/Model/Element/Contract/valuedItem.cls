/// Contract Valued Item.
Class HS.FHIR.DTL.vDSTU2.Model.Element.Contract.valuedItem Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// Contract Valued Item Type.
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property entityCodeableConcept As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "entityCodeableConcept", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Contract Valued Item Type.
/// <p>
/// Any FHIR2 Resource may be indicated by this Reference.
Property entityReference As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "entityReference", XMLPROJECTION = "ELEMENT");

/// Identifier
/// <p>
/// Contract Valued Item Identifier.
Property identifier As HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// Contract Valued Item Effective Tiem.
Property effectiveTime As %String(MAXLEN = 1000000, XMLNAME = "effectiveTime", XMLPROJECTION = "ATTRIBUTE");

/// SimpleQuantity
/// <p>
/// Count of Contract Valued Items.
Property quantity As HS.FHIR.DTL.vDSTU2.Model.Datatype.SimpleQuantity(XMLNAME = "quantity", XMLPROJECTION = "ELEMENT");

/// Money
/// <p>
/// Contract Valued Item fee, 
/// charge, 
/// or cost.
Property unitPrice As HS.FHIR.DTL.vDSTU2.Model.Datatype.Money(XMLNAME = "unitPrice", XMLPROJECTION = "ELEMENT");

/// decimal
/// <p>
/// Contract Valued Item Price Scaling Factor.
Property factor As %Decimal(XMLNAME = "factor", XMLPROJECTION = "ATTRIBUTE");

/// decimal
/// <p>
/// Contract Valued Item Difficulty Scaling Factor.
Property points As %Decimal(XMLNAME = "points", XMLPROJECTION = "ATTRIBUTE");

/// Money
/// <p>
/// Total Contract Valued Item Value.
Property net As HS.FHIR.DTL.vDSTU2.Model.Datatype.Money(XMLNAME = "net", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Contract.valuedItem";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Contract.valuedItem";

}
