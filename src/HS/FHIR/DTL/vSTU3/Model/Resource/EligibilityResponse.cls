/// This resource provides eligibility and plan details from the processing of an Eligibility resource.
Class HS.FHIR.DTL.vSTU3.Model.Resource.EligibilityResponse Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
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
/// Responsible practitioner.
/// <p>
/// Practitioner
Property requestProvider As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "requestProvider", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Responsible organization.
/// <p>
/// Organization
Property requestOrganization As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "requestOrganization", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Eligibility reference.
/// <p>
/// EligibilityRequest
Property request As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "request", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// complete | error | partial
/// <p>
/// remittance-outcome is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend remittance-outcome and you may NOT use codes from other ValueSets.
Property outcome As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "outcome", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Disposition Message.
Property disposition As %String(MAXLEN = 1000000, XMLNAME = "disposition", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Insurer issuing the coverage.
/// <p>
/// Organization
Property insurer As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "insurer", XMLPROJECTION = "ELEMENT");

/// boolean
/// <p>
/// Coverage inforce indicator.
Property inforce As %Boolean(XMLNAME = "inforce", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Details by insurance coverage.
Property insurance As list Of HS.FHIR.DTL.vSTU3.Model.Element.EligibilityResponse.insurance(XMLNAME = "insurance", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Printed Form Identifier.
/// <p>
/// any FHIR3 code may be used; 
/// forms shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property form As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "form", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Processing errors.
Property error As list Of HS.FHIR.DTL.vSTU3.Model.Element.EligibilityResponse.error(XMLNAME = "error", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "EligibilityResponse";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "EligibilityResponse";

}
