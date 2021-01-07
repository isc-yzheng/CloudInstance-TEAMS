/// Questions in this group. 
/// A question must use either option or options, 
/// not both.
Class HS.FHIR.DTL.vDSTU2.Model.Element.Questionnaire.group.question Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// string
/// <p>
/// To link questionnaire with questionnaire response.
Property linkId As %String(MAXLEN = 1000000, XMLNAME = "linkId", XMLPROJECTION = "ATTRIBUTE");

/// Coding
/// <p>
/// Concept that represents this question on a questionnaire.
/// <p>
/// any FHIR2 code may be used; 
/// questionnaire-questions shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property concept As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "concept", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Text of the question as it is shown to the user.
Property text As %String(MAXLEN = 1000000, XMLNAME = "text", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// boolean | decimal | integer | date | dateTime +
/// <p>
/// answer-format is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend answer-format and you may NOT use codes from other ValueSets.
Property type As %String(MAXLEN = 1000000, XMLNAME = "type", XMLPROJECTION = "ATTRIBUTE");

/// boolean
/// <p>
/// Whether the question must be answered in data results.
Property required As %Boolean(XMLNAME = "required", XMLPROJECTION = "ATTRIBUTE");

/// boolean
/// <p>
/// Whether the question  can have multiple answers.
Property repeats As %Boolean(XMLNAME = "repeats", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Valueset containing permitted answers.
/// <p>
/// ValueSet
Property options As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "options", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// Permitted answer.
/// <p>
/// any FHIR2 code may be used; 
/// questionnaire-answers shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property option As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "option", XMLPROJECTION = "ELEMENT");

/// Questionnaire:group
/// <p>
/// Nested questionnaire group.
Property group As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Questionnaire.group(XMLNAME = "group", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Questionnaire.group.question";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Questionnaire.group.question";

}
