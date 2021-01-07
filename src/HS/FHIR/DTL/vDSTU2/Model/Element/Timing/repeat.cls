/// When the event is to occur.
Class HS.FHIR.DTL.vDSTU2.Model.Element.Timing.repeat Extends HS.FHIR.DTL.vDSTU2.Model.Base.Element [ Not ProcedureBlock ]
{

/// Period
/// <p>
/// Length/Range of lengths, 
/// or (Start and/or end) limits.
Property boundsPeriod As HS.FHIR.DTL.vDSTU2.Model.Datatype.Period(XMLNAME = "boundsPeriod", XMLPROJECTION = "ELEMENT");

/// Duration
/// <p>
/// Length/Range of lengths, 
/// or (Start and/or end) limits.
Property boundsQuantity As HS.FHIR.DTL.vDSTU2.Model.Datatype.Duration(XMLNAME = "boundsQuantity", XMLPROJECTION = "ELEMENT");

/// Range
/// <p>
/// Length/Range of lengths, 
/// or (Start and/or end) limits.
Property boundsRange As HS.FHIR.DTL.vDSTU2.Model.Datatype.Range(XMLNAME = "boundsRange", XMLPROJECTION = "ELEMENT");

/// integer
/// <p>
/// Number of times to repeat.
Property count As %Integer(XMLNAME = "count", XMLPROJECTION = "ATTRIBUTE");

/// decimal
/// <p>
/// How long when it happens.
Property duration As %Decimal(XMLNAME = "duration", XMLPROJECTION = "ATTRIBUTE");

/// decimal
/// <p>
/// How long when it happens (Max)
Property durationMax As %Decimal(XMLNAME = "durationMax", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// s | min | h | d | wk | mo | a - unit of time (UCUM)
/// <p>
/// units-of-time is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend units-of-time and you may NOT use codes from other ValueSets.
Property durationUnits As %String(MAXLEN = 1000000, XMLNAME = "durationUnits", XMLPROJECTION = "ATTRIBUTE");

/// integer
/// <p>
/// Event occurs frequency times per period.
Property frequency As %Integer(XMLNAME = "frequency", XMLPROJECTION = "ATTRIBUTE");

/// integer
/// <p>
/// Event occurs up to frequencyMax times per period.
Property frequencyMax As %Integer(XMLNAME = "frequencyMax", XMLPROJECTION = "ATTRIBUTE");

/// decimal
/// <p>
/// Event occurs frequency times per period.
Property period As %Decimal(XMLNAME = "period", XMLPROJECTION = "ATTRIBUTE");

/// decimal
/// <p>
/// Upper limit of period (3-4 hours)
Property periodMax As %Decimal(XMLNAME = "periodMax", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// s | min | h | d | wk | mo | a - unit of time (UCUM)
/// <p>
/// units-of-time is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend units-of-time and you may NOT use codes from other ValueSets.
Property periodUnits As %String(MAXLEN = 1000000, XMLNAME = "periodUnits", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// Regular life events the event is tied to.
/// <p>
/// event-timing is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend event-timing and you may NOT use codes from other ValueSets.
Property when As %String(MAXLEN = 1000000, XMLNAME = "when", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "repeat";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "repeat";

}
