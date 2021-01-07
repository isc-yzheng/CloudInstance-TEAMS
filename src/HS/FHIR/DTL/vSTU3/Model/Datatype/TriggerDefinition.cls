/// The TriggerDefinition structure defines when a knowledge artifact is expected to be evaluated. 
/// The structure can represent three main kinds of triggering events: Named Event, 
/// Scheduled Event, 
/// Data Event. 
/// A named event is an event identified by the implementation environment. 
/// This allows any event generated within the implementation environment to be used as a trigger, 
/// but it requires pre-coordination of the names involved with the consuming environments. 
/// A scheduled event occurs on a fixed or periodic schedule. 
/// And finally, 
/// a data event occurs in response to some data-related event in the integrated environment such as a record being added or updated. 
/// The data-of-interest for a data event is described using a DataRequirement. 
/// This allows for systems to automatically invoke based on data activity occurring within the system.
Class HS.FHIR.DTL.vSTU3.Model.Datatype.TriggerDefinition Extends HS.FHIR.DTL.vSTU3.Model.Base.Element [ Not ProcedureBlock ]
{

/// code
/// <p>
/// named-event | periodic | data-added | data-modified | data-removed | data-accessed | data-access-ended
/// <p>
/// trigger-type is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend trigger-type and you may NOT use codes from other ValueSets.
Property type As %String(MAXLEN = 1000000, XMLNAME = "type", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// string
/// <p>
/// Triggering event name.
Property eventName As %String(MAXLEN = 1000000, XMLNAME = "eventName", XMLPROJECTION = "ATTRIBUTE");

/// date
/// <p>
/// Timing of the event.
Property eventTimingDate As %String(MAXLEN = 1000000, XMLNAME = "eventTimingDate", XMLPROJECTION = "ATTRIBUTE");

/// dateTime
/// <p>
/// Timing of the event.
Property eventTimingDateTime As %String(MAXLEN = 1000000, XMLNAME = "eventTimingDateTime", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Timing of the event.
/// <p>
/// Schedule.
Property eventTimingReference As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "eventTimingReference", XMLPROJECTION = "ELEMENT");

/// Timing
/// <p>
/// Timing of the event.
Property eventTimingTiming As HS.FHIR.DTL.vSTU3.Model.Datatype.Timing(XMLNAME = "eventTimingTiming", XMLPROJECTION = "ELEMENT");

/// DataRequirement
/// <p>
/// Triggering data of the event.
Property eventData As HS.FHIR.DTL.vSTU3.Model.Datatype.DataRequirement(XMLNAME = "eventData", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "TriggerDefinition";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "TriggerDefinition";

}
