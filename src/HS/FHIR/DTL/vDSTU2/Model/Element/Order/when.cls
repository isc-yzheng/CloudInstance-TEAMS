/// When order should be fulfilled.
Class HS.FHIR.DTL.vDSTU2.Model.Element.Order.when Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// Code specifies when request should be done. 
/// The code may simply be a priority code.
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property code As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "code", XMLPROJECTION = "ELEMENT");

/// Timing
/// <p>
/// A formal schedule.
Property schedule As HS.FHIR.DTL.vDSTU2.Model.Datatype.Timing(XMLNAME = "schedule", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Order.when";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Order.when";

}
