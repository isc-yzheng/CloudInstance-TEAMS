/// What dates/date ranges are expected.
Class HS.FHIR.DTL.vSTU3.Model.Element.DataRequirement.dateFilter Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// string
/// <p>
/// The date-valued attribute of the filter.
Property path As %String(MAXLEN = 1000000, XMLNAME = "path", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// dateTime
/// <p>
/// The value of the filter, 
/// as a Period, 
/// DateTime, 
/// or Duration value.
Property valueDateTime As %String(MAXLEN = 1000000, XMLNAME = "valueDateTime", XMLPROJECTION = "ATTRIBUTE");

/// Duration
/// <p>
/// The value of the filter, 
/// as a Period, 
/// DateTime, 
/// or Duration value.
Property valueDuration As HS.FHIR.DTL.vSTU3.Model.Datatype.Duration(XMLNAME = "valueDuration", XMLPROJECTION = "ELEMENT");

/// Period
/// <p>
/// The value of the filter, 
/// as a Period, 
/// DateTime, 
/// or Duration value.
Property valuePeriod As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "valuePeriod", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "DataRequirement.dateFilter";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "DataRequirement.dateFilter";

}
