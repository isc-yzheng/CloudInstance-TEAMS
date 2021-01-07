/// Roles/organizations the practitioner is associated with.
Class HS.FHIR.DTL.vDSTU2.Model.Element.Practitioner.practitionerRole Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Reference
/// <p>
/// Organization where the roles are performed.
/// <p>
/// Organization
Property managingOrganization As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "managingOrganization", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Roles which this practitioner may perform.
/// <p>
/// any FHIR2 code may be used; 
/// practitioner-role shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property role As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "role", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Specific specialty of the practitioner.
/// <p>
/// any FHIR2 code may be used; 
/// practitioner-specialty shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property specialty As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "specialty", XMLPROJECTION = "ELEMENT");

/// Period
/// <p>
/// The period during which the practitioner is authorized to perform in these role(s)
Property period As HS.FHIR.DTL.vDSTU2.Model.Datatype.Period(XMLNAME = "period", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// The location(s) at which this practitioner provides care.
/// <p>
/// Location
Property location As list Of HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "location", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// The list of healthcare services that this worker provides for this role's Organization/Location(s)
/// <p>
/// HealthcareService
Property healthcareService As list Of HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "healthcareService", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Practitioner.practitionerRole";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Practitioner.practitionerRole";

}
