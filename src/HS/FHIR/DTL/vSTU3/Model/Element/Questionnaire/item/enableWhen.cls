/// Only allow data when.
Class HS.FHIR.DTL.vSTU3.Model.Element.Questionnaire.item.enableWhen Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// string
/// <p>
/// Question that determines whether item is enabled.
Property question As %String(MAXLEN = 1000000, XMLNAME = "question", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// boolean
/// <p>
/// Enable when answered or not.
Property hasAnswer As %Boolean(XMLNAME = "hasAnswer", XMLPROJECTION = "ATTRIBUTE");

/// Attachment
/// <p>
/// Value question must have.
Property answerAttachment As HS.FHIR.DTL.vSTU3.Model.Datatype.Attachment(XMLNAME = "answerAttachment", XMLPROJECTION = "ELEMENT");

/// boolean
/// <p>
/// Value question must have.
Property answerBoolean As %Boolean(XMLNAME = "answerBoolean", XMLPROJECTION = "ATTRIBUTE");

/// Coding
/// <p>
/// Value question must have.
/// <p>
/// any FHIR3 code may be used; 
/// questionnaire-answers shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property answerCoding As HS.FHIR.DTL.vSTU3.Model.Datatype.Coding(XMLNAME = "answerCoding", XMLPROJECTION = "ELEMENT");

/// date
/// <p>
/// Value question must have.
Property answerDate As %String(MAXLEN = 1000000, XMLNAME = "answerDate", XMLPROJECTION = "ATTRIBUTE");

/// dateTime
/// <p>
/// Value question must have.
Property answerDateTime As %String(MAXLEN = 1000000, XMLNAME = "answerDateTime", XMLPROJECTION = "ATTRIBUTE");

/// decimal
/// <p>
/// Value question must have.
Property answerDecimal As %Decimal(XMLNAME = "answerDecimal", XMLPROJECTION = "ATTRIBUTE");

/// integer
/// <p>
/// Value question must have.
Property answerInteger As %Integer(XMLNAME = "answerInteger", XMLPROJECTION = "ATTRIBUTE");

/// Quantity
/// <p>
/// Value question must have.
Property answerQuantity As HS.FHIR.DTL.vSTU3.Model.Datatype.Quantity(XMLNAME = "answerQuantity", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Value question must have.
/// <p>
/// Any FHIR3 Resource may be indicated by this Reference.
Property answerReference As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "answerReference", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Value question must have.
Property answerString As %String(MAXLEN = 1000000, XMLNAME = "answerString", XMLPROJECTION = "ATTRIBUTE");

/// time
/// <p>
/// Value question must have.
Property answerTime As %String(MAXLEN = 1000000, XMLNAME = "answerTime", XMLPROJECTION = "ATTRIBUTE");

/// uri
/// <p>
/// Value question must have.
Property answerUri As %String(MAXLEN = 1000000, XMLNAME = "answerUri", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Questionnaire.item.enableWhen";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Questionnaire.item.enableWhen";

}
