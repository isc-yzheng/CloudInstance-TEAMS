/// The EligibilityRequest provides patient and insurance coverage information to an insurer for them to respond, 
/// in the form of an EligibilityResponse, 
/// with information regarding whether the stated coverage is valid and in-force and optionally to provide the insurance details of the policy.
Class HS.FHIR.DTL.vSTU3.Model.Resource.EligibilityRequest Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
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

/// CodeableConcept
/// <p>
/// Desired processing priority.
/// <p>
/// any FHIR3 code may be used; 
/// process-priority shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property priority As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "priority", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// The subject of the Products and Services.
/// <p>
/// Patient
Property patient As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "patient", XMLPROJECTION = "ELEMENT");

/// date
/// <p>
///  Estimated date or dates of Service.
Property servicedDate As %String(MAXLEN = 1000000, XMLNAME = "servicedDate", XMLPROJECTION = "ATTRIBUTE");

/// Period
/// <p>
///  Estimated date or dates of Service.
Property servicedPeriod As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "servicedPeriod", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// Creation date.
Property created As %String(MAXLEN = 1000000, XMLNAME = "created", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Author.
/// <p>
/// Practitioner
Property enterer As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "enterer", XMLPROJECTION = "ELEMENT");

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
/// Target.
/// <p>
/// Organization
Property insurer As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "insurer", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Servicing Facility.
/// <p>
/// Location
Property facility As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "facility", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Insurance or medical plan.
/// <p>
/// Coverage
Property coverage As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "coverage", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Business agreement.
Property businessArrangement As %String(MAXLEN = 1000000, XMLNAME = "businessArrangement", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Type of services covered.
/// <p>
/// any FHIR3 code may be used; 
/// benefit-category shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property benefitCategory As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "benefitCategory", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Detailed services covered within the type.
/// <p>
/// any FHIR3 code may be used; 
/// benefit-subcategory shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property benefitSubCategory As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "benefitSubCategory", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "EligibilityRequest";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "EligibilityRequest";

}
