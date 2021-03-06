/// A slot of time on a schedule that may be available for booking appointments.
Class HS.FHIR.DTL.vSTU3.Model.Resource.Slot Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// External Ids for this item.
Property identifier As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

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
/// The type of appointments that can be booked into this slot (ideally this would be an identifiable service - which is at a location, 
/// rather than the location itself). 
/// If provided then this overrides the value provided on the availability resource.
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

/// CodeableConcept
/// <p>
/// The style of appointment or patient that may be booked in the slot (not service type)
/// <p>
/// v2-0276 is the PREFERRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in v2-0276, 
/// you may use codes from any ValueSet.
Property appointmentType As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "appointmentType", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// The schedule resource that this slot defines an interval of status information.
/// <p>
/// Schedule
Property schedule As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "schedule", XMLPROJECTION = "ELEMENT") [ Required ];

/// code
/// <p>
/// busy | free | busy-unavailable | busy-tentative | entered-in-error
/// <p>
/// slotstatus is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend slotstatus and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// instant
/// <p>
/// Date/Time that the slot is to begin.
Property start As %String(MAXLEN = 1000000, XMLNAME = "start", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// instant
/// <p>
/// Date/Time that the slot is to conclude.
Property end As %String(MAXLEN = 1000000, XMLNAME = "end", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// boolean
/// <p>
/// This slot has already been overbooked, 
/// appointments are unlikely to be accepted for this time.
Property overbooked As %Boolean(XMLNAME = "overbooked", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Comments on the slot to describe any extended information. 
/// Such as custom constraints on the slot.
Property comment As %String(MAXLEN = 1000000, XMLNAME = "comment", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Slot";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Slot";

}
