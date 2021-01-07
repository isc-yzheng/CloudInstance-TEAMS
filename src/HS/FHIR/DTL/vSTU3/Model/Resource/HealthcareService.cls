/// The details of a healthcare service available at a location.
Class HS.FHIR.DTL.vSTU3.Model.Resource.HealthcareService Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// External identifiers for this item.
Property identifier As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// boolean
/// <p>
/// Whether this healthcareservice is in active use.
Property active As %Boolean(XMLNAME = "active", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Organization that provides this service.
/// <p>
/// Organization
Property providedBy As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "providedBy", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Broad category of service being performed or delivered.
/// <p>
/// any FHIR3 code may be used; 
/// service-category shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property category As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "category", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Type of service that may be delivered or performed.
/// <p>
/// any FHIR3 code may be used; 
/// service-type shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property type As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Specialties handled by the HealthcareService.
/// <p>
/// c80-practice-codes is the PREFERRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in c80-practice-codes, 
/// you may use codes from any ValueSet.
Property specialty As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "specialty", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Location(s) where service may be provided.
/// <p>
/// Location
Property location As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "location", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Description of service as presented to a consumer while searching.
Property name As %String(MAXLEN = 1000000, XMLNAME = "name", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Additional description and/or any specific issues not covered elsewhere.
Property comment As %String(MAXLEN = 1000000, XMLNAME = "comment", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Extra details about the service that can't be placed in the other fields.
Property extraDetails As %String(MAXLEN = 1000000, XMLNAME = "extraDetails", XMLPROJECTION = "ATTRIBUTE");

/// Attachment
/// <p>
/// Facilitates quick identification of the service.
Property photo As HS.FHIR.DTL.vSTU3.Model.Datatype.Attachment(XMLNAME = "photo", XMLPROJECTION = "ELEMENT");

/// ContactPoint
/// <p>
/// Contacts related to the healthcare service.
Property telecom As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.ContactPoint(XMLNAME = "telecom", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Location(s) service is inteded for/available to.
/// <p>
/// Location
Property coverageArea As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "coverageArea", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Conditions under which service is available/offered.
/// <p>
/// any FHIR3 code may be used; 
/// service-provision-conditions shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property serviceProvisionCode As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "serviceProvisionCode", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Specific eligibility requirements required to use the service.
/// <p>
/// any FHIR3 code from any ValueSet may be used.
Property eligibility As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "eligibility", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Describes the eligibility conditions for the service.
Property eligibilityNote As %String(MAXLEN = 1000000, XMLNAME = "eligibilityNote", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Program Names that categorize the service.
Property programName As list Of %String(MAXLEN = 1000000, XMLNAME = "programName", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Collection of characteristics (attributes)
/// <p>
/// any FHIR3 code from any ValueSet may be used.
Property characteristic As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "characteristic", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Ways that the service accepts referrals.
/// <p>
/// any FHIR3 code may be used; 
/// service-referral-method shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property referralMethod As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "referralMethod", XMLPROJECTION = "ELEMENT");

/// boolean
/// <p>
/// If an appointment is required for access to this service.
Property appointmentRequired As %Boolean(XMLNAME = "appointmentRequired", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Times the Service Site is available.
Property availableTime As list Of HS.FHIR.DTL.vSTU3.Model.Element.HealthcareService.availableTime(XMLNAME = "availableTime", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Not available during this time due to provided reason.
Property notAvailable As list Of HS.FHIR.DTL.vSTU3.Model.Element.HealthcareService.notAvailable(XMLNAME = "notAvailable", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Description of availability exceptions.
Property availabilityExceptions As %String(MAXLEN = 1000000, XMLNAME = "availabilityExceptions", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Technical endpoints providing access to services operated for the location.
/// <p>
/// Endpoint
Property endpoint As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "endpoint", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "HealthcareService";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "HealthcareService";

}
