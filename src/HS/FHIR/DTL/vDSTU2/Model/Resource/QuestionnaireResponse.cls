/// A structured set of questions and their answers.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.QuestionnaireResponse Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Unique id for this set of answers.
Property identifier As HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Form being answered.
/// <p>
/// Questionnaire
Property questionnaire As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "questionnaire", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// in-progress | completed | amended
/// <p>
/// questionnaire-answers-status is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend questionnaire-answers-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Reference
/// <p>
/// The subject of the questions.
/// <p>
/// Any FHIR2 Resource may be indicated by this Reference
Property subject As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "subject", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Person who received and recorded the answers.
/// <p>
/// Device | Practitioner | Patient | RelatedPerson
Property author As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "author", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// Date this version was authored.
Property authored As %String(MAXLEN = 1000000, XMLNAME = "authored", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// The person who answered the questions.
/// <p>
/// Patient | Practitioner | RelatedPerson
Property source As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "source", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Primary encounter during which the answers were collected.
/// <p>
/// Encounter
Property encounter As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "encounter", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Grouped questions.
Property group As HS.FHIR.DTL.vDSTU2.Model.Element.QuestionnaireResponse.group(XMLNAME = "group", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "QuestionnaireResponse";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "QuestionnaireResponse";

}
