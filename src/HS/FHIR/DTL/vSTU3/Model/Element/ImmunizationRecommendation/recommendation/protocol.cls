/// Protocol used by recommendation.
Class HS.FHIR.DTL.vSTU3.Model.Element.ImmunizationRecommendation.recommendation.protocol Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// positiveInt
/// <p>
/// Dose number within sequence.
Property doseSequence As %Integer(XMLNAME = "doseSequence", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Protocol details.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Who is responsible for protocol.
/// <p>
/// Organization
Property authority As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "authority", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Name of vaccination series.
Property series As %String(MAXLEN = 1000000, XMLNAME = "series", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ImmunizationRecommendation.recommendation.protocol";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ImmunizationRecommendation.recommendation.protocol";

}
