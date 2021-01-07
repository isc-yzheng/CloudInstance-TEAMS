Class HS.FHIR.vDSTU2.Model.Base.Range Extends HS.FHIR.vDSTU2.Model.Base.Element [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Range";

Parameter XMLSEQUENCE = 1;

/// The low limit. The boundary is inclusive.
Property low As HS.FHIR.vDSTU2.Model.Base.SimpleQuantity(XMLNAME = "low");

/// The high limit. The boundary is inclusive.
Property high As HS.FHIR.vDSTU2.Model.Base.SimpleQuantity(XMLNAME = "high");

}
