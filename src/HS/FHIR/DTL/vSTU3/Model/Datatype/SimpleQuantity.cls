/// This is a variation on Quantity: A measured amount (or an amount that can potentially be measured). 
///  The comparator is not used on a SimpleQuantity 
Class HS.FHIR.DTL.vSTU3.Model.Datatype.SimpleQuantity Extends HS.FHIR.DTL.vSTU3.Model.Base.Element [ Not ProcedureBlock ]
{

/// decimal
/// <p>
/// Numerical value (with implicit precision)
Property value As %Decimal(XMLNAME = "value", XMLPROJECTION = "ATTRIBUTE");

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

Parameter XMLNAME = "SimpleQuantity";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "SimpleQuantity";

}
