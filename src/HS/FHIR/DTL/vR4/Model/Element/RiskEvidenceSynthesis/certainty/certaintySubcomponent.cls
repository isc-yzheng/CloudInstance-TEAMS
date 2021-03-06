/// A component that contributes to the overall certainty.
Class HS.FHIR.DTL.vR4.Model.Element.RiskEvidenceSynthesis.certainty.certaintySubcomponent Extends HS.FHIR.DTL.vR4.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// Type of subcomponent of certainty rating.
/// <p>
/// certainty-subcomponent-type is the REQUIRED FHIR4 ValueSet for codes, 
/// but if you need to express meanings not found in certainty-subcomponent-type, 
/// you may formally EXTEND certainty-subcomponent-type to add codes to it.
Property type As HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Subcomponent certainty rating.
/// <p>
/// certainty-subcomponent-rating is the REQUIRED FHIR4 ValueSet for codes, 
/// but if you need to express meanings not found in certainty-subcomponent-rating, 
/// you may formally EXTEND certainty-subcomponent-rating to add codes to it.
Property rating As list Of HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "rating", XMLPROJECTION = "ELEMENT");

/// Annotation
/// <p>
/// Used for footnotes or explanatory notes.
Property note As list Of HS.FHIR.DTL.vR4.Model.Datatype.Annotation(XMLNAME = "note", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "RiskEvidenceSynthesis.certainty.certaintySubcomponent";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "RiskEvidenceSynthesis.certainty.certaintySubcomponent";

}
