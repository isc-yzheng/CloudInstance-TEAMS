/// A structured set of questions and their answers. 
/// The questions are ordered and grouped into coherent subsets, 
/// corresponding to the structure of the grouping of the questionnaire being responded to.
Class HS.FHIR.DTL.vSTU3.Model.Resource.QuestionnaireResponse Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Unique id for this set of answers.
Property identifier As HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Request fulfilled by this QuestionnaireResponse.
/// <p>
/// ReferralRequest | CarePlan | ProcedureRequest
Property basedOn As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "basedOn", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Part of this action.
/// <p>
/// Observation | Procedure
Property parent As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "parent", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Form being answered.
/// <p>
/// Questionnaire
Property questionnaire As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "questionnaire", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// in-progress | completed | amended | entered-in-error | stopped
/// <p>
/// questionnaire-answers-status is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend questionnaire-answers-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Reference
/// <p>
/// The subject of the questions.
/// <p>
/// Any FHIR3 Resource may be indicated by this Reference
Property subject As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "subject", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Encounter or Episode during which questionnaire was completed.
/// <p>
/// Encounter | EpisodeOfCare
Property context As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "context", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// Date the answers were gathered.
Property authored As %String(MAXLEN = 1000000, XMLNAME = "authored", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Person who received and recorded the answers.
/// <p>
/// Device | Practitioner | Patient | RelatedPerson
Property author As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "author", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// The person who answered the questions.
/// <p>
/// Patient | Practitioner | RelatedPerson
Property source As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "source", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Groups and questions - Nested item can't be beneath both item and answer.
Property item As list Of HS.FHIR.DTL.vSTU3.Model.Element.QuestionnaireResponse.item(XMLNAME = "item", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "QuestionnaireResponse";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "QuestionnaireResponse";

}
