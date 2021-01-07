/// Contract Term Actor List.
Class HS.FHIR.DTL.vDSTU2.Model.Element.Contract.term.actor Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Reference
/// <p>
/// Contract Term Actor.
/// <p>
/// Contract | Device | Group | Location | Organization | Patient | Practitioner | RelatedPerson | Substance
Property entity As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "entity", XMLPROJECTION = "ELEMENT") [ Required ];

/// CodeableConcept
/// <p>
/// Contract Term Actor Role.
/// <p>
/// any FHIR2 code may be used; 
/// contract-actorrole shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property role As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "role", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Contract.term.actor";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Contract.term.actor";

}
