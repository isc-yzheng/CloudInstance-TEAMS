/// This patient is known to be an animal (non-human)
Class HS.FHIR.DTL.vDSTU2.Model.Element.Patient.animal Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// E.g. 
/// Dog, 
/// Cow.
/// <p>
/// any FHIR2 code may be used; 
/// animal-species shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property species As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "species", XMLPROJECTION = "ELEMENT") [ Required ];

/// CodeableConcept
/// <p>
/// E.g. 
/// Poodle, 
/// Angus.
/// <p>
/// any FHIR2 code may be used; 
/// animal-breeds shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property breed As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "breed", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// E.g. 
/// Neutered, 
/// Intact.
/// <p>
/// any FHIR2 code may be used; 
/// animal-genderstatus shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property genderStatus As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "genderStatus", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Patient.animal";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Patient.animal";

}
