/// Risk of harmful or undesirable, 
/// physiological response which is unique to an individual and associated with exposure to a substance.
Class HS.FHIR.DTL.vSTU3.Model.Resource.AllergyIntolerance Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// External ids for this item.
Property identifier As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// active | inactive | resolved
/// <p>
/// allergy-clinical-status is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend allergy-clinical-status and you may NOT use codes from other ValueSets.
Property clinicalStatus As %String(MAXLEN = 1000000, XMLNAME = "clinicalStatus", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// unconfirmed | confirmed | refuted | entered-in-error
/// <p>
/// allergy-verification-status is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend allergy-verification-status and you may NOT use codes from other ValueSets.
Property verificationStatus As %String(MAXLEN = 1000000, XMLNAME = "verificationStatus", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// code
/// <p>
/// allergy | intolerance - Underlying mechanism (if known)
/// <p>
/// allergy-intolerance-type is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend allergy-intolerance-type and you may NOT use codes from other ValueSets.
Property type As %String(MAXLEN = 1000000, XMLNAME = "type", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// food | medication | environment | biologic
/// <p>
/// allergy-intolerance-category is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend allergy-intolerance-category and you may NOT use codes from other ValueSets.
Property category As list Of %String(MAXLEN = 1000000, XMLNAME = "category", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// low | high | unable-to-assess
/// <p>
/// allergy-intolerance-criticality is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend allergy-intolerance-criticality and you may NOT use codes from other ValueSets.
Property criticality As %String(MAXLEN = 1000000, XMLNAME = "criticality", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Code that identifies the allergy or intolerance.
/// <p>
/// any FHIR3 code may be used; 
/// allergyintolerance-code shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property code As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "code", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Who the sensitivity is for.
/// <p>
/// Patient
Property patient As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "patient", XMLPROJECTION = "ELEMENT") [ Required ];

/// Age
/// <p>
/// When allergy or intolerance was identified.
Property onsetAge As HS.FHIR.DTL.vSTU3.Model.Datatype.Age(XMLNAME = "onsetAge", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// When allergy or intolerance was identified.
Property onsetDateTime As %String(MAXLEN = 1000000, XMLNAME = "onsetDateTime", XMLPROJECTION = "ATTRIBUTE");

/// Period
/// <p>
/// When allergy or intolerance was identified.
Property onsetPeriod As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "onsetPeriod", XMLPROJECTION = "ELEMENT");

/// Range
/// <p>
/// When allergy or intolerance was identified.
Property onsetRange As HS.FHIR.DTL.vSTU3.Model.Datatype.Range(XMLNAME = "onsetRange", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// When allergy or intolerance was identified.
Property onsetString As %String(MAXLEN = 1000000, XMLNAME = "onsetString", XMLPROJECTION = "ATTRIBUTE");

/// dateTime
/// <p>
/// Date record was believed accurate.
Property assertedDate As %String(MAXLEN = 1000000, XMLNAME = "assertedDate", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Who recorded the sensitivity.
/// <p>
/// Practitioner | Patient
Property recorder As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "recorder", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Source of the information about the allergy.
/// <p>
/// Patient | RelatedPerson | Practitioner
Property asserter As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "asserter", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// Date(/time) of last known occurrence of a reaction.
Property lastOccurrence As %String(MAXLEN = 1000000, XMLNAME = "lastOccurrence", XMLPROJECTION = "ATTRIBUTE");

/// Annotation
/// <p>
/// Additional text not captured in other fields.
Property note As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Annotation(XMLNAME = "note", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Adverse Reaction Events linked to exposure to substance.
Property reaction As list Of HS.FHIR.DTL.vSTU3.Model.Element.AllergyIntolerance.reaction(XMLNAME = "reaction", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "AllergyIntolerance";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "AllergyIntolerance";

}
