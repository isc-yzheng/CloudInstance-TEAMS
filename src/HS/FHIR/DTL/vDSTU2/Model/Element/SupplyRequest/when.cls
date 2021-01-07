/// When the request should be fulfilled.
Class HS.FHIR.DTL.vDSTU2.Model.Element.SupplyRequest.when Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// Fulfilment code.
/// <p>
/// any FHIR2 code may be used; 
/// supplyrequest-when shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property code As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "code", XMLPROJECTION = "ELEMENT");

/// Timing
/// <p>
/// Formal fulfillment schedule.
Property schedule As HS.FHIR.DTL.vDSTU2.Model.Datatype.Timing(XMLNAME = "schedule", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "SupplyRequest.when";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "SupplyRequest.when";

}
