/// A container for slots of time that may be available for booking appointments.
Class HS.FHIR.DTL.vSTU3.Model.Resource.Schedule Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// External Ids for this item.
Property identifier As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// boolean
/// <p>
/// Whether this schedule is in active use.
Property active As %Boolean(XMLNAME = "active", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// A broad categorisation of the service that is to be performed during this appointment.
/// <p>
/// any FHIR3 code may be used; 
/// service-category shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property serviceCategory As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "serviceCategory", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// The specific service that is to be performed during this appointment.
/// <p>
/// any FHIR3 code may be used; 
/// service-type shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property serviceType As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "serviceType", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// The specialty of a practitioner that would be required to perform the service requested in this appointment.
/// <p>
/// c80-practice-codes is the PREFERRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in c80-practice-codes, 
/// you may use codes from any ValueSet.
Property specialty As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "specialty", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// The resource this Schedule resource is providing availability information for. 
/// These are expected to usually be one of HealthcareService, 
/// Location, 
/// Practitioner, 
/// PractitionerRole, 
/// Device, 
/// Patient or RelatedPerson.
/// <p>
/// Patient | Practitioner | PractitionerRole | RelatedPerson | Device | HealthcareService | Location
Property actor As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "actor", XMLPROJECTION = "ELEMENT") [ Required ];

/// Period
/// <p>
/// The period of time that the slots that are attached to this Schedule resource cover (even if none exist). 
/// These  cover the amount of time that an organization's planning horizon; 
/// the interval for which they are currently accepting appointments. 
/// This does not define a 
Property planningHorizon As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "planningHorizon", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Comments on the availability to describe any extended information. 
/// Such as custom constraints on the slots that may be associated.
Property comment As %String(MAXLEN = 1000000, XMLNAME = "comment", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Schedule";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Schedule";

}
