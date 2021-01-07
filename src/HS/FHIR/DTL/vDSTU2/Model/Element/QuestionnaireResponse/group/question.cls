/// Questions in this group.
Class HS.FHIR.DTL.vDSTU2.Model.Element.QuestionnaireResponse.group.question Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// string
/// <p>
/// Corresponding question within Questionnaire.
Property linkId As %String(MAXLEN = 1000000, XMLNAME = "linkId", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Text of the question as it is shown to the user.
Property text As %String(MAXLEN = 1000000, XMLNAME = "text", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// The response(s) to the question.
Property answer As list Of HS.FHIR.DTL.vDSTU2.Model.Element.QuestionnaireResponse.group.question.answer(XMLNAME = "answer", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "QuestionnaireResponse.group.question";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "QuestionnaireResponse.group.question";

}
