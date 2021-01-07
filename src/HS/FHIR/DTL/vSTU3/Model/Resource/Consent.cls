/// A record of a healthcare consumer's policy choices, 
/// which permits or denies identified recipient(s) or recipient role(s) to perform one or more actions within a given policy context, 
/// for specific purposes and periods of time.
Class HS.FHIR.DTL.vSTU3.Model.Resource.Consent Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Identifier for this record (external references)
Property identifier As HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// draft | proposed | active | rejected | inactive | entered-in-error
/// <p>
/// consent-state-codes is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend consent-state-codes and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// CodeableConcept
/// <p>
/// Classification of the consent statement - for indexing/retrieval.
/// <p>
/// any FHIR3 code may be used; 
/// consent-category shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property category As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "category", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Who the consent applies to.
/// <p>
/// Patient
Property patient As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "patient", XMLPROJECTION = "ELEMENT") [ Required ];

/// Period
/// <p>
/// Period that this consent applies.
Property period As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "period", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// When this Consent was created or indexed.
Property dateTime As %String(MAXLEN = 1000000, XMLNAME = "dateTime", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Who is agreeing to the policy and exceptions.
/// <p>
/// Organization | Patient | Practitioner | RelatedPerson
Property consentingParty As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "consentingParty", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Who | what controlled by this consent (or group, 
/// by role)
Property actor As list Of HS.FHIR.DTL.vSTU3.Model.Element.Consent.actor(XMLNAME = "actor", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Actions controlled by this consent.
/// <p>
/// any FHIR3 code may be used; 
/// consent-action shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property action As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "action", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Custodian of the consent.
/// <p>
/// Organization
Property organization As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "organization", XMLPROJECTION = "ELEMENT");

/// Attachment
/// <p>
/// Source from which this consent is taken.
Property sourceAttachment As HS.FHIR.DTL.vSTU3.Model.Datatype.Attachment(XMLNAME = "sourceAttachment", XMLPROJECTION = "ELEMENT");

/// Identifier
/// <p>
/// Source from which this consent is taken.
Property sourceIdentifier As HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "sourceIdentifier", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Source from which this consent is taken.
/// <p>
/// Consent | DocumentReference | Contract | QuestionnaireResponse
Property sourceReference As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "sourceReference", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Policies covered by this consent.
Property policy As list Of HS.FHIR.DTL.vSTU3.Model.Element.Consent.policy(XMLNAME = "policy", XMLPROJECTION = "ELEMENT");

/// uri
/// <p>
/// Policy that this consents to.
Property policyRule As %String(MAXLEN = 1000000, XMLNAME = "policyRule", XMLPROJECTION = "ATTRIBUTE");

/// Coding
/// <p>
/// Security Labels that define affected resources.
/// <p>
/// security-labels is the REQUIRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in security-labels, 
/// you may formally EXTEND security-labels to add codes to it.
Property securityLabel As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Coding(XMLNAME = "securityLabel", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// Context of activities for which the agreement is made.
/// <p>
/// v3-PurposeOfUse is the REQUIRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in v3-PurposeOfUse, 
/// you may formally EXTEND v3-PurposeOfUse to add codes to it.
Property purpose As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Coding(XMLNAME = "purpose", XMLPROJECTION = "ELEMENT");

/// Period
/// <p>
/// Timeframe for data controlled by this consent.
Property dataPeriod As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "dataPeriod", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Data controlled by this consent.
Property data As list Of HS.FHIR.DTL.vSTU3.Model.Element.Consent.data(XMLNAME = "data", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Additional rule -  addition or removal of permissions.
Property except As list Of HS.FHIR.DTL.vSTU3.Model.Element.Consent.except(XMLNAME = "except", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Consent";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Consent";

}
