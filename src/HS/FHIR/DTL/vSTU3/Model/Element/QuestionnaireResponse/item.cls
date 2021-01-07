/// Groups and questions - Nested item can't be beneath both item and answer.
Class HS.FHIR.DTL.vSTU3.Model.Element.QuestionnaireResponse.item Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// string
/// <p>
/// Pointer to specific item from Questionnaire.
Property linkId As %String(MAXLEN = 1000000, XMLNAME = "linkId", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// uri
/// <p>
/// ElementDefinition - details for the item.
Property definition As %String(MAXLEN = 1000000, XMLNAME = "definition", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Name for group or question text.
Property text As %String(MAXLEN = 1000000, XMLNAME = "text", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// The subject this group's answers are about.
/// <p>
/// Any FHIR3 Resource may be indicated by this Reference
Property subject As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "subject", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// The response(s) to the question.
Property answer As list Of HS.FHIR.DTL.vSTU3.Model.Element.QuestionnaireResponse.item.answer(XMLNAME = "answer", XMLPROJECTION = "ELEMENT");

/// QuestionnaireResponse:item
/// <p>
/// Nested questionnaire response items - Nested item can't be beneath both item and answer.
Property item As list Of HS.FHIR.DTL.vSTU3.Model.Element.QuestionnaireResponse.item(XMLNAME = "item", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "QuestionnaireResponse.item";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "QuestionnaireResponse.item";

}
