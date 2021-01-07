/// Party to be paid any benefits payable.
Class HS.FHIR.DTL.vSTU3.Model.Element.Claim.payee Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// Type of party: Subscriber, 
/// Provider, 
/// other.
/// <p>
/// any FHIR3 code may be used; 
/// payeetype shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property type As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT") [ Required ];

/// Coding
/// <p>
/// organization | patient | practitioner | relatedperson
/// <p>
/// any FHIR3 code may be used; 
/// ex-payee-resource-type shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property resourceType As HS.FHIR.DTL.vSTU3.Model.Datatype.Coding(XMLNAME = "resourceType", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Party to receive the payable.
/// <p>
/// Practitioner | Organization | Patient | RelatedPerson
Property party As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "party", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Claim.payee";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Claim.payee";

}
