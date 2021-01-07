/// A patient's point-in-time immunization and recommendation (i.e. 
/// forecasting a patient's immunization eligibility according to a published schedule) with optional supporting justification.
Class HS.FHIR.DTL.vSTU3.Model.Resource.ImmunizationRecommendation Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Business identifier.
Property identifier As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Who this profile is for.
/// <p>
/// Patient
Property patient As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "patient", XMLPROJECTION = "ELEMENT") [ Required ];

/// BackboneElement
/// <p>
/// Vaccine administration recommendations.
Property recommendation As list Of HS.FHIR.DTL.vSTU3.Model.Element.ImmunizationRecommendation.recommendation(XMLNAME = "recommendation", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ImmunizationRecommendation";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ImmunizationRecommendation";

}
