/// Related Claims which may be revelant to processing this claimn.
Class HS.FHIR.DTL.vSTU3.Model.Element.Claim.related Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Reference
/// <p>
/// Reference to the related claim.
/// <p>
/// Claim
Property claim As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "claim", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// How the reference claim is related.
/// <p>
/// any FHIR3 code may be used; 
/// related-claim-relationship shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property relationship As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "relationship", XMLPROJECTION = "ELEMENT");

/// Identifier
/// <p>
/// Related file or case reference.
Property reference As HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "reference", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Claim.related";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Claim.related";

}
