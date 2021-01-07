/// Vaccine administration recommendations.
Class HS.FHIR.DTL.vSTU3.Model.Element.ImmunizationRecommendation.recommendation Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// dateTime
/// <p>
/// Date recommendation created.
Property date As %String(MAXLEN = 1000000, XMLNAME = "date", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// CodeableConcept
/// <p>
/// Vaccine recommendation applies to.
/// <p>
/// any FHIR3 code may be used; 
/// vaccine-code shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property vaccineCode As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "vaccineCode", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Disease to be immunized against.
/// <p>
/// any FHIR3 code may be used; 
/// immunization-recommendation-target-disease shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property targetDisease As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "targetDisease", XMLPROJECTION = "ELEMENT");

/// positiveInt
/// <p>
/// Recommended dose number.
Property doseNumber As %Integer(XMLNAME = "doseNumber", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Vaccine administration status.
/// <p>
/// any FHIR3 code may be used; 
/// immunization-recommendation-status shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property forecastStatus As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "forecastStatus", XMLPROJECTION = "ELEMENT") [ Required ];

/// BackboneElement
/// <p>
/// Dates governing proposed immunization.
Property dateCriterion As list Of HS.FHIR.DTL.vSTU3.Model.Element.ImmunizationRecommendation.recommendation.dateCriterion(XMLNAME = "dateCriterion", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Protocol used by recommendation.
Property protocol As HS.FHIR.DTL.vSTU3.Model.Element.ImmunizationRecommendation.recommendation.protocol(XMLNAME = "protocol", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Past immunizations supporting recommendation.
/// <p>
/// Immunization
Property supportingImmunization As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "supportingImmunization", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Patient observations supporting recommendation.
/// <p>
/// Observation | AllergyIntolerance
Property supportingPatientInformation As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "supportingPatientInformation", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ImmunizationRecommendation.recommendation";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ImmunizationRecommendation.recommendation";

}
