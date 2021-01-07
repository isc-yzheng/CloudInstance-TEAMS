/// Defines an expected trigger for a module.
Class HS.FHIR.DTL.vR4.Model.Datatype.TriggerDefinition Extends HS.FHIR.DTL.vR4.Model.Base.Element [ Not ProcedureBlock ]
{

/// code
/// <p>
/// named-event | periodic | data-changed | data-added | data-modified | data-removed | data-accessed | data-access-ended
/// <p>
/// trigger-type|4.0.1 is the REQUIRED FHIR4 ValueSet for codes; 
/// you may NOT extend trigger-type|4.0.1 and you may NOT use codes from other ValueSets.
Property type As %String(MAXLEN = 1000000, XMLNAME = "type", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// string
/// <p>
/// Name or URI that identifies the event.
Property name As %String(MAXLEN = 1000000, XMLNAME = "name", XMLPROJECTION = "ATTRIBUTE");

/// date
/// <p>
/// Timing of the event.
Property timingDate As %String(MAXLEN = 1000000, XMLNAME = "timingDate", XMLPROJECTION = "ATTRIBUTE");

/// dateTime
/// <p>
/// Timing of the event.
Property timingDateTime As %String(MAXLEN = 1000000, XMLNAME = "timingDateTime", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Timing of the event.
/// <p>
/// Schedule.
Property timingReference As HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "timingReference", XMLPROJECTION = "ELEMENT");

/// Timing
/// <p>
/// Timing of the event.
Property timingTiming As HS.FHIR.DTL.vR4.Model.Datatype.Timing(XMLNAME = "timingTiming", XMLPROJECTION = "ELEMENT");

/// DataRequirement
/// <p>
/// Triggering data of the event (multiple = 'and')
Property data As list Of HS.FHIR.DTL.vR4.Model.Datatype.DataRequirement(XMLNAME = "data", XMLPROJECTION = "ELEMENT");

/// Expression
/// <p>
/// Whether the event triggers (boolean expression)
Property condition As HS.FHIR.DTL.vR4.Model.Datatype.Expression(XMLNAME = "condition", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "TriggerDefinition";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "TriggerDefinition";

}
