/// This is a variation on Quantity: A measured amount (or an amount that can potentially be measured). 
/// There SHALL be a code if there is a value and it SHALL be an expression of currency. 
/// If system is present, 
/// it SHALL be ISO 4217 (system = "urn:iso:std:iso:4217" - currency). 
/// 
Class HS.FHIR.DTL.vSTU3.Model.Datatype.Money Extends HS.FHIR.DTL.vSTU3.Model.Base.Element [ Not ProcedureBlock ]
{

/// decimal
/// <p>
/// Numerical value (with implicit precision)
Property value As %Decimal(XMLNAME = "value", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// < | <= | >= | > - how to understand the value
/// <p>
/// quantity-comparator is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend quantity-comparator and you may NOT use codes from other ValueSets.
Property comparator As %String(MAXLEN = 1000000, XMLNAME = "comparator", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Unit representation.
Property unit As %String(MAXLEN = 1000000, XMLNAME = "unit", XMLPROJECTION = "ATTRIBUTE");

/// uri
/// <p>
/// System that defines coded unit form.
Property system As %String(MAXLEN = 1000000, XMLNAME = "system", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// Coded form of the unit.
/// <p>
/// any FHIR3 code from any ValueSet may be used.
Property code As %String(MAXLEN = 1000000, XMLNAME = "code", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Money";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Money";

}
