/// What was the result per exposure?
Class HS.FHIR.DTL.vR4.Model.Element.EffectEvidenceSynthesis.resultsByExposure Extends HS.FHIR.DTL.vR4.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// string
/// <p>
/// Description of results by exposure.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// exposure | exposure-alternative
/// <p>
/// exposure-state|4.0.1 is the REQUIRED FHIR4 ValueSet for codes; 
/// you may NOT extend exposure-state|4.0.1 and you may NOT use codes from other ValueSets.
Property exposureState As %String(MAXLEN = 1000000, XMLNAME = "exposureState", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Variant exposure states.
/// <p>
/// evidence-variant-state is the REQUIRED FHIR4 ValueSet for codes, 
/// but if you need to express meanings not found in evidence-variant-state, 
/// you may formally EXTEND evidence-variant-state to add codes to it.
Property variantState As HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "variantState", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Risk evidence synthesis.
/// <p>
/// RiskEvidenceSynthesis
Property riskEvidenceSynthesis As HS.FHIR.DTL.vR4.Model.Base.Reference(XMLNAME = "riskEvidenceSynthesis", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "EffectEvidenceSynthesis.resultsByExposure";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "EffectEvidenceSynthesis.resultsByExposure";

}
