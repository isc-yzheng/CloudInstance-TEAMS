/// A reply to an appointment request for a patient and/or practitioner(s), 
/// such as a confirmation or rejection.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.AppointmentResponse Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// External Ids for this item.
Property identifier As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Appointment this response relates to.
/// <p>
/// Appointment
Property appointment As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "appointment", XMLPROJECTION = "ELEMENT") [ Required ];

/// instant
/// <p>
/// Time from appointment, 
/// or requested new start time.
Property start As %String(MAXLEN = 1000000, XMLNAME = "start", XMLPROJECTION = "ATTRIBUTE");

/// instant
/// <p>
/// Time from appointment, 
/// or requested new end time.
Property end As %String(MAXLEN = 1000000, XMLNAME = "end", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Role of participant in the appointment.
/// <p>
/// encounter-participant-type is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend encounter-participant-type and you may NOT use codes from other ValueSets.
Property participantType As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "participantType", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Person, 
/// Location/HealthcareService or Device.
/// <p>
/// Patient | Practitioner | RelatedPerson | Device | HealthcareService | Location
Property actor As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "actor", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// accepted | declined | tentative | in-process | completed | needs-action
/// <p>
/// participantstatus is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend participantstatus and you may NOT use codes from other ValueSets.
Property participantStatus As %String(MAXLEN = 1000000, XMLNAME = "participantStatus", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// string
/// <p>
/// Additional comments.
Property comment As %String(MAXLEN = 1000000, XMLNAME = "comment", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "AppointmentResponse";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "AppointmentResponse";

}
