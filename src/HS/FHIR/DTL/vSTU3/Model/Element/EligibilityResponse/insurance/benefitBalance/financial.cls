/// Benefit Summary.
Class HS.FHIR.DTL.vSTU3.Model.Element.EligibilityResponse.insurance.benefitBalance.financial Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// Deductable, 
/// visits, 
/// benefit amount.
/// <p>
/// any FHIR3 code may be used; 
/// benefit-type shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property type As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT") [ Required ];

/// Money
/// <p>
///  Benefits allowed.
Property allowedMoney As HS.FHIR.DTL.vSTU3.Model.Datatype.Money(XMLNAME = "allowedMoney", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
///  Benefits allowed.
Property allowedString As %String(MAXLEN = 1000000, XMLNAME = "allowedString", XMLPROJECTION = "ATTRIBUTE");

/// unsignedInt
/// <p>
///  Benefits allowed.
Property allowedUnsignedInt As %Integer(XMLNAME = "allowedUnsignedInt", XMLPROJECTION = "ATTRIBUTE");

/// Money
/// <p>
///  Benefits used.
Property usedMoney As HS.FHIR.DTL.vSTU3.Model.Datatype.Money(XMLNAME = "usedMoney", XMLPROJECTION = "ELEMENT");

/// unsignedInt
/// <p>
///  Benefits used.
Property usedUnsignedInt As %Integer(XMLNAME = "usedUnsignedInt", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "EligibilityResponse.insurance.benefitBalance.financial";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "EligibilityResponse.insurance.benefitBalance.financial";

}
