/// Grouped questions.
Class HS.FHIR.DTL.vDSTU2.Model.Element.QuestionnaireResponse.group Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// string
/// <p>
/// Corresponding group within Questionnaire.
Property linkId As %String(MAXLEN = 1000000, XMLNAME = "linkId", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Name for this group.
Property title As %String(MAXLEN = 1000000, XMLNAME = "title", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Additional text for the group.
Property text As %String(MAXLEN = 1000000, XMLNAME = "text", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// The subject this group's answers are about.
/// <p>
/// Any FHIR2 Resource may be indicated by this Reference
Property subject As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "subject", XMLPROJECTION = "ELEMENT");

/// QuestionnaireResponse:group
/// <p>
/// Nested questionnaire response group.
Property group As list Of HS.FHIR.DTL.vDSTU2.Model.Element.QuestionnaireResponse.group(XMLNAME = "group", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Questions in this group.
Property question As list Of HS.FHIR.DTL.vDSTU2.Model.Element.QuestionnaireResponse.group.question(XMLNAME = "question", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "QuestionnaireResponse.group";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "QuestionnaireResponse.group";

}
