/// Other practitioners facilitating this episode of care.
Class HS.FHIR.DTL.vDSTU2.Model.Element.EpisodeOfCare.careTeam Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// Role taken by this team member.
/// <p>
/// any FHIR2 code may be used; 
/// participant-role shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property role As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "role", XMLPROJECTION = "ELEMENT");

/// Period
/// <p>
/// Period of time for this role.
Property period As HS.FHIR.DTL.vDSTU2.Model.Datatype.Period(XMLNAME = "period", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// The practitioner (or Organization) within the team.
/// <p>
/// Practitioner | Organization
Property member As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "member", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "EpisodeOfCare.careTeam";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "EpisodeOfCare.careTeam";

}
