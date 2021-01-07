/// Who performed event.
Class HS.FHIR.DTL.vSTU3.Model.Element.Immunization.practitioner Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// What type of performance was done.
/// <p>
/// immunization-role is the REQUIRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in immunization-role, 
/// you may formally EXTEND immunization-role to add codes to it.
Property role As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "role", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Individual who was performing.
/// <p>
/// Practitioner
Property actor As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "actor", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Immunization.practitioner";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Immunization.practitioner";

}
