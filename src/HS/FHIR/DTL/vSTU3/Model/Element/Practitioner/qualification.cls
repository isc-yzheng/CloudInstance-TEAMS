/// Qualifications obtained by training and certification.
Class HS.FHIR.DTL.vSTU3.Model.Element.Practitioner.qualification Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// An identifier for this qualification for the practitioner.
Property identifier As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Coded representation of the qualification.
/// <p>
/// any FHIR3 code may be used; 
/// v2-0360/2.7 shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property code As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "code", XMLPROJECTION = "ELEMENT") [ Required ];

/// Period
/// <p>
/// Period during which the qualification is valid.
Property period As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "period", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Organization that regulates and issues the qualification.
/// <p>
/// Organization
Property issuer As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "issuer", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Practitioner.qualification";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Practitioner.qualification";

}
