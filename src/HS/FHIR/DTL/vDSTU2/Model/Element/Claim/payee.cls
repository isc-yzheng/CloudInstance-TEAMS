/// Payee.
Class HS.FHIR.DTL.vDSTU2.Model.Element.Claim.payee Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Coding
/// <p>
/// Party to be paid any benefits payable.
/// <p>
/// any FHIR2 code may be used; 
/// payeetype shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property type As HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Provider who is the payee.
/// <p>
/// Practitioner
Property provider As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "provider", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Organization who is the payee.
/// <p>
/// Organization
Property organization As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "organization", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Other person who is the payee.
/// <p>
/// Patient
Property person As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "person", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Claim.payee";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Claim.payee";

}
