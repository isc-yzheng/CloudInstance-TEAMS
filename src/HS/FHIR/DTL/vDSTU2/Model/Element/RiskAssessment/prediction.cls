/// Outcome predicted.
Class HS.FHIR.DTL.vDSTU2.Model.Element.RiskAssessment.prediction Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// Possible outcome for the subject.
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property outcome As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "outcome", XMLPROJECTION = "ELEMENT") [ Required ];

/// CodeableConcept
/// <p>
/// Likelihood of specified outcome.
/// <p>
/// any FHIR2 code may be used; 
/// risk-probability shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property probabilityCodeableConcept As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "probabilityCodeableConcept", XMLPROJECTION = "ELEMENT");

/// decimal
/// <p>
/// Likelihood of specified outcome.
Property probabilityDecimal As %Decimal(XMLNAME = "probabilityDecimal", XMLPROJECTION = "ATTRIBUTE");

/// Range
/// <p>
/// Likelihood of specified outcome.
Property probabilityRange As HS.FHIR.DTL.vDSTU2.Model.Datatype.Range(XMLNAME = "probabilityRange", XMLPROJECTION = "ELEMENT");

/// decimal
/// <p>
/// Relative likelihood.
Property relativeRisk As %Decimal(XMLNAME = "relativeRisk", XMLPROJECTION = "ATTRIBUTE");

/// Period
/// <p>
/// Timeframe or age range.
Property whenPeriod As HS.FHIR.DTL.vDSTU2.Model.Datatype.Period(XMLNAME = "whenPeriod", XMLPROJECTION = "ELEMENT");

/// Range
/// <p>
/// Timeframe or age range.
Property whenRange As HS.FHIR.DTL.vDSTU2.Model.Datatype.Range(XMLNAME = "whenRange", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Explanation of prediction.
Property rationale As %String(MAXLEN = 1000000, XMLNAME = "rationale", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "RiskAssessment.prediction";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "RiskAssessment.prediction";

}
