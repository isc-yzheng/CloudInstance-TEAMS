/// Contract Term Agent List.
Class HS.FHIR.DTL.vSTU3.Model.Element.Contract.term.agent Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Reference
/// <p>
/// Contract Term Agent Subject.
/// <p>
/// Contract | Device | Group | Location | Organization | Patient | Practitioner | RelatedPerson | Substance
Property actor As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "actor", XMLPROJECTION = "ELEMENT") [ Required ];

/// CodeableConcept
/// <p>
/// Type of the Contract Term Agent.
/// <p>
/// any FHIR3 code may be used; 
/// contract-actorrole shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property role As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "role", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Contract.term.agent";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Contract.term.agent";

}
