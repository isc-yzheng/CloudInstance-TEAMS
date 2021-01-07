/// Who | what controlled by this consent (or group, 
/// by role)
Class HS.FHIR.DTL.vSTU3.Model.Element.Consent.actor Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// How the actor is involved.
/// <p>
/// security-role-type is the REQUIRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in security-role-type, 
/// you may formally EXTEND security-role-type to add codes to it.
Property role As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "role", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Resource for the actor (or group, 
/// by role)
/// <p>
/// Device | Group | CareTeam | Organization | Patient | Practitioner | RelatedPerson
Property reference As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "reference", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Consent.actor";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Consent.actor";

}
