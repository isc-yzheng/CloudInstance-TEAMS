/// Who|what controlled by this rule (or group, 
/// by role)
Class HS.FHIR.DTL.vR4.Model.Element.Consent.provision.actor Extends HS.FHIR.DTL.vR4.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// How the actor is involved.
/// <p>
/// security-role-type is the REQUIRED FHIR4 ValueSet for codes, 
/// but if you need to express meanings not found in security-role-type, 
/// you may formally EXTEND security-role-type to add codes to it.
Property role As HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "role", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Resource for the actor (or group, 
/// by role)
/// <p>
/// Device | Group | CareTeam | Organization | Patient | Practitioner | RelatedPerson | PractitionerRole
Property reference As HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "reference", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Consent.provision.actor";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Consent.provision.actor";

}
