/// A booking of a healthcare event among patient(s), 
/// practitioner(s), 
/// related person(s) and/or device(s) for a specific date/time. 
/// This may result in one or more Encounter(s)
Class HS.FHIR.DTL.vDSTU2.Model.Resource.Appointment Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// External Ids for this item.
Property identifier As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// proposed | pending | booked | arrived | fulfilled | cancelled | noshow
/// <p>
/// appointmentstatus is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend appointmentstatus and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// CodeableConcept
/// <p>
/// The type of appointment that is being booked.
/// <p>
/// c80-practice-codes is the PREFERRED FHIR2 ValueSet for codes, 
/// but if you need to express meanings not found in c80-practice-codes, 
/// you may use codes from any ValueSet.
Property type As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Reason this appointment is scheduled.
/// <p>
/// encounter-reason is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend encounter-reason and you may NOT use codes from other ValueSets.
Property reason As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "reason", XMLPROJECTION = "ELEMENT");

/// unsignedInt
/// <p>
/// Used to make informed decisions if needing to re-prioritize.
Property priority As %Integer(XMLNAME = "priority", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Shown on a subject line in a meeting request, 
/// or appointment list.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

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
/// If provided, 
/// then no schedule and start/end values MUST match slot.
/// <p>
/// Slot
Property slot As list Of HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "slot", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Additional comments.
Property comment As %String(MAXLEN = 1000000, XMLNAME = "comment", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Participants involved in appointment.
Property participant As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Appointment.participant(XMLNAME = "participant", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Appointment";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Appointment";

}
