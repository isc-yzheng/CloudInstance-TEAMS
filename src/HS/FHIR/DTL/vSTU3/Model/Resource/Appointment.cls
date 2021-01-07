/// A booking of a healthcare event among patient(s), 
/// practitioner(s), 
/// related person(s) and/or device(s) for a specific date/time. 
/// This may result in one or more Encounter(s).
Class HS.FHIR.DTL.vSTU3.Model.Resource.Appointment Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// External Ids for this item.
Property identifier As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// proposed | pending | booked | arrived | fulfilled | cancelled | noshow | entered-in-error
/// <p>
/// appointmentstatus is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend appointmentstatus and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

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

/// CodeableConcept
/// <p>
/// The style of appointment or patient that has been booked in the slot (not service type)
/// <p>
/// v2-0276 is the PREFERRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in v2-0276, 
/// you may use codes from any ValueSet.
Property appointmentType As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "appointmentType", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Reason this appointment is scheduled.
/// <p>
/// encounter-reason is the PREFERRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in encounter-reason, 
/// you may use codes from any ValueSet.
Property reason As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "reason", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Reason the appointment is to takes place (resource)
/// <p>
/// Condition | Procedure
Property indication As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "indication", XMLPROJECTION = "ELEMENT");

/// unsignedInt
/// <p>
/// Used to make informed decisions if needing to re-prioritize.
Property priority As %Integer(XMLNAME = "priority", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Shown on a subject line in a meeting request, 
/// or appointment list.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Additional information to support the appointment.
/// <p>
/// Any FHIR3 Resource may be indicated by this Reference
Property supportingInformation As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "supportingInformation", XMLPROJECTION = "ELEMENT");

/// instant
/// <p>
/// When appointment is to take place.
Property start As %String(MAXLEN = 1000000, XMLNAME = "start", XMLPROJECTION = "ATTRIBUTE");

/// instant
/// <p>
/// When appointment is to conclude.
Property end As %String(MAXLEN = 1000000, XMLNAME = "end", XMLPROJECTION = "ATTRIBUTE");

/// positiveInt
/// <p>
/// Can be less than start/end (e.g. 
/// estimate)
Property minutesDuration As %Integer(XMLNAME = "minutesDuration", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// The slots that this appointment is filling.
/// <p>
/// Slot
Property slot As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "slot", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// The date that this appointment was initially created.
Property created As %String(MAXLEN = 1000000, XMLNAME = "created", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Additional comments.
Property comment As %String(MAXLEN = 1000000, XMLNAME = "comment", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// The ReferralRequest provided as information to allocate to the Encounter.
/// <p>
/// ReferralRequest
Property incomingReferral As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "incomingReferral", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Participants involved in appointment.
Property participant As list Of HS.FHIR.DTL.vSTU3.Model.Element.Appointment.participant(XMLNAME = "participant", XMLPROJECTION = "ELEMENT") [ Required ];

/// Period
/// <p>
/// Potential date/time interval(s) requested to allocate the appointment within.
Property requestedPeriod As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "requestedPeriod", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Appointment";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Appointment";

}
