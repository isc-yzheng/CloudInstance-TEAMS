/// Grouped questions.
Class HS.FHIR.DTL.vDSTU2.Model.Element.Questionnaire.group Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// string
/// <p>
/// To link questionnaire with questionnaire response.
Property linkId As %String(MAXLEN = 1000000, XMLNAME = "linkId", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Name to be displayed for group.
Property title As %String(MAXLEN = 1000000, XMLNAME = "title", XMLPROJECTION = "ATTRIBUTE");

/// Coding
/// <p>
/// Concept that represents this section in a questionnaire.
/// <p>
/// any FHIR2 code may be used; 
/// questionnaire-questions shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property concept As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "concept", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Additional text for the group.
Property text As %String(MAXLEN = 1000000, XMLNAME = "text", XMLPROJECTION = "ATTRIBUTE");

/// boolean
/// <p>
/// Whether the group must be included in data results.
Property required As %Boolean(XMLNAME = "required", XMLPROJECTION = "ATTRIBUTE");

/// boolean
/// <p>
/// Whether the group may repeat.
Property repeats As %Boolean(XMLNAME = "repeats", XMLPROJECTION = "ATTRIBUTE");

/// Questionnaire:group
/// <p>
/// Nested questionnaire group.
Property group As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Questionnaire.group(XMLNAME = "group", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Questions in this group. 
/// A question must use either option or options, 
/// not both.
Property question As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Questionnaire.group.question(XMLNAME = "question", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Questionnaire.group";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Questionnaire.group";

}
