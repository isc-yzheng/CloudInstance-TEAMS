/// Allergy or Intolerance (generally: Risk Of Adverse reaction to a substance)
Class HS.FHIR.DTL.vDSTU2.Model.Resource.AllergyIntolerance Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// External ids for this item.
Property identifier As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// Date(/time) when manifestations showed.
Property onset As %String(MAXLEN = 1000000, XMLNAME = "onset", XMLPROJECTION = "ATTRIBUTE");

/// dateTime
/// <p>
/// When recorded.
Property recordedDate As %String(MAXLEN = 1000000, XMLNAME = "recordedDate", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Who recorded the sensitivity.
/// <p>
/// Practitioner | Patient
Property recorder As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "recorder", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Who the sensitivity is for.
/// <p>
/// Patient
Property patient As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "patient", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Source of the information about the allergy.
/// <p>
/// Patient | RelatedPerson | Practitioner
Property reporter As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "reporter", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Substance, 
/// (or class) considered to be responsible for risk.
/// <p>
/// any FHIR2 code may be used; 
/// allergyintolerance-substance-code shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property substance As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "substance", XMLPROJECTION = "ELEMENT") [ Required ];

/// code
/// <p>
/// active | unconfirmed | confirmed | inactive | resolved | refuted | entered-in-error
/// <p>
/// allergy-intolerance-status is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend allergy-intolerance-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// CRITL | CRITH | CRITU
/// <p>
/// allergy-intolerance-criticality is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend allergy-intolerance-criticality and you may NOT use codes from other ValueSets.
Property criticality As %String(MAXLEN = 1000000, XMLNAME = "criticality", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// allergy | intolerance - Underlying mechanism (if known)
/// <p>
/// allergy-intolerance-type is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend allergy-intolerance-type and you may NOT use codes from other ValueSets.
Property type As %String(MAXLEN = 1000000, XMLNAME = "type", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// food | medication | environment | other - Category of Substance
/// <p>
/// allergy-intolerance-category is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend allergy-intolerance-category and you may NOT use codes from other ValueSets.
Property category As %String(MAXLEN = 1000000, XMLNAME = "category", XMLPROJECTION = "ATTRIBUTE");

/// dateTime
/// <p>
/// Date(/time) of last known occurrence of a reaction.
Property lastOccurence As %String(MAXLEN = 1000000, XMLNAME = "lastOccurence", XMLPROJECTION = "ATTRIBUTE");

/// Annotation
/// <p>
/// Additional text not captured in other fields.
Property note As HS.FHIR.DTL.vDSTU2.Model.Datatype.Annotation(XMLNAME = "note", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Adverse Reaction Events linked to exposure to substance.
Property reaction As list Of HS.FHIR.DTL.vDSTU2.Model.Element.AllergyIntolerance.reaction(XMLNAME = "reaction", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "AllergyIntolerance";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "AllergyIntolerance";

}
