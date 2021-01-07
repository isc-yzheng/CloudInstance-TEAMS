/// A time period defined by a start and end date/time. 
/// A period specifies a range of times. 
/// The context of use will specify whether the entire range applies (e.g. 
/// "the patient was an inpatient of the hospital for this time range") or one value from the period applies (e.g. 
/// "give to the patient between 2 and 4 pm on 24-Jun 2013").
Class HS.FHIR.DTL.vDSTU2.Model.Datatype.Period Extends HS.FHIR.DTL.vDSTU2.Model.Base.Element [ Not ProcedureBlock ]
{

/// dateTime
/// <p>
/// Starting time with inclusive boundary.
Property start As %String(MAXLEN = 1000000, XMLNAME = "start", XMLPROJECTION = "ATTRIBUTE");

/// dateTime
/// <p>
/// End time with inclusive boundary, 
/// if not ongoing.
Property end As %String(MAXLEN = 1000000, XMLNAME = "end", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Period";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Period";

}
