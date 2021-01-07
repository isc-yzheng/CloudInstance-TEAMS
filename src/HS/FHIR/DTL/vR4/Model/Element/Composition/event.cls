/// The clinical service(s) being documented.
Class HS.FHIR.DTL.vR4.Model.Element.Composition.event Extends HS.FHIR.DTL.vR4.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// Code(s) that apply to the event being documented.
/// <p>
/// any FHIR4 code may be used; 
/// v3-ActCode shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property code As list Of HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "code", XMLPROJECTION = "ELEMENT");

/// Period
/// <p>
/// The period covered by the documentation.
Property period As HS.FHIR.DTL.vR4.Model.Datatype.Period(XMLNAME = "period", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// The event(s) being documented.
/// <p>
/// Any FHIR4 Resource may be indicated by this Reference
Property detail As list Of HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "detail", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Composition.event";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Composition.event";

}
