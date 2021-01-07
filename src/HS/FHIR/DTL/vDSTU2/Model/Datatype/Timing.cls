/// Specifies an event that may occur multiple times. 
/// Timing schedules are used for specifying when events are expected or requested to occur, 
/// and may also be used to represent a schedule that was followed for past events. 
/// A Timing schedule can be a list of events and/or criteria for when the event happens, 
/// which can be expressed in a structured form and/or as a code. 
/// When both event and a repeating specification are provided, 
/// the list of events should be understood as an interpretation of the information in the repeat structure.
Class HS.FHIR.DTL.vDSTU2.Model.Datatype.Timing Extends HS.FHIR.DTL.vDSTU2.Model.Base.Element [ Not ProcedureBlock ]
{

/// dateTime
/// <p>
/// When the event occurs.
Property event As list Of %String(MAXLEN = 1000000, XMLNAME = "event", XMLPROJECTION = "ELEMENT");

/// Element
/// <p>
/// When the event is to occur.
Property repeat As HS.FHIR.DTL.vDSTU2.Model.Element.Timing.repeat(XMLNAME = "repeat", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// QD | QOD | Q4H | Q6H | BID | TID | QID | AM | PM +
/// <p>
/// timing-abbreviation is the PREFERRED FHIR2 ValueSet for codes, 
/// but if you need to express meanings not found in timing-abbreviation, 
/// you may use codes from any ValueSet.
Property code As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "code", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Timing";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Timing";

}
