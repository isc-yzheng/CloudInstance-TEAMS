/// Not available during this time due to provided reason.
Class HS.FHIR.DTL.vR4.Model.Element.HealthcareService.notAvailable Extends HS.FHIR.DTL.vR4.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// string
/// <p>
/// Reason presented to the user explaining why time not available.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Period
/// <p>
/// Service not available from this date.
Property during As HS.FHIR.DTL.vR4.Model.Datatype.Period(XMLNAME = "during", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "HealthcareService.notAvailable";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "HealthcareService.notAvailable";

}
