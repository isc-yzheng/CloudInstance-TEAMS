/// 
Class HS.FHIR.DTL.vDSTU2.Model.Element.Medication.product.batch Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// string
Property lotNumber As %String(MAXLEN = 1000000, XMLNAME = "lotNumber", XMLPROJECTION = "ATTRIBUTE");

/// dateTime
Property expirationDate As %String(MAXLEN = 1000000, XMLNAME = "expirationDate", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Medication.product.batch";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Medication.product.batch";

}
