/// Group of properties which are applicable under the same conditions.
Class HS.FHIR.DTL.vR4.Model.Element.ChargeItemDefinition.propertyGroup Extends HS.FHIR.DTL.vR4.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// ChargeItemDefinition:applicability
/// <p>
/// Conditions under which the priceComponent is applicable.
Property applicability As list Of HS.FHIR.DTL.vR4.Model.Element.ChargeItemDefinition.applicability(XMLNAME = "applicability", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Components of total line item price.
Property priceComponent As list Of HS.FHIR.DTL.vR4.Model.Element.ChargeItemDefinition.propertyGroup.priceComponent(XMLNAME = "priceComponent", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ChargeItemDefinition.propertyGroup";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ChargeItemDefinition.propertyGroup";

}
