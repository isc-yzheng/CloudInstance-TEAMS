/// This resource provides the insurance enrollment details to the insurer regarding a specified coverage. 
/// NOTE: This resource has not yet undergone proper review by FM. 
/// At this time it is a 'stub', 
/// is known to be incomplete, 
/// and is to be considered as a draft.
Class HS.FHIR.DTL.vSTU3.Model.Resource.EnrollmentRequest Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Business Identifier.
Property identifier As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// active | cancelled | draft | entered-in-error
/// <p>
/// fm-status is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend fm-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE");

/// dateTime
/// <p>
/// Creation date.
Property created As %String(MAXLEN = 1000000, XMLNAME = "created", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Target.
/// <p>
/// Organization
Property insurer As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "insurer", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Responsible practitioner.
/// <p>
/// Practitioner
Property provider As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "provider", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Responsible organization.
/// <p>
/// Organization
Property organization As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "organization", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// The subject of the Products and Services.
/// <p>
/// Patient
Property subject As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "subject", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Insurance information.
/// <p>
/// Coverage
Property coverage As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "coverage", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "EnrollmentRequest";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "EnrollmentRequest";

}
