/// Questions and sections within the Questionnaire.
Class HS.FHIR.DTL.vSTU3.Model.Element.Questionnaire.item Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// string
/// <p>
/// Unique id for item in questionnaire.
Property linkId As %String(MAXLEN = 1000000, XMLNAME = "linkId", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// uri
/// <p>
/// ElementDefinition - details for the item.
Property definition As %String(MAXLEN = 1000000, XMLNAME = "definition", XMLPROJECTION = "ATTRIBUTE");

/// Coding
/// <p>
/// Corresponding concept for this item in a terminology.
/// <p>
/// any FHIR3 code may be used; 
/// questionnaire-questions shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property code As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Coding(XMLNAME = "code", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// E.g. 
/// "1(a)", 
/// "2.5.3" 
Property prefix As %String(MAXLEN = 1000000, XMLNAME = "prefix", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Primary text for the item.
Property text As %String(MAXLEN = 1000000, XMLNAME = "text", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// group | display | boolean | decimal | integer | date | dateTime +
/// <p>
/// item-type is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend item-type and you may NOT use codes from other ValueSets.
Property type As %String(MAXLEN = 1000000, XMLNAME = "type", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// BackboneElement
/// <p>
/// Only allow data when.
Property enableWhen As list Of HS.FHIR.DTL.vSTU3.Model.Element.Questionnaire.item.enableWhen(XMLNAME = "enableWhen", XMLPROJECTION = "ELEMENT");

/// boolean
/// <p>
/// Whether the item must be included in data results.
Property required As %Boolean(XMLNAME = "required", XMLPROJECTION = "ATTRIBUTE");

/// boolean
/// <p>
/// Whether the item may repeat.
Property repeats As %Boolean(XMLNAME = "repeats", XMLPROJECTION = "ATTRIBUTE");

/// boolean
/// <p>
/// Don't allow human editing.
Property readOnly As %Boolean(XMLNAME = "readOnly", XMLPROJECTION = "ATTRIBUTE");

/// integer
/// <p>
/// No more than this many characters.
Property maxLength As %Integer(XMLNAME = "maxLength", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Valueset containing permitted answers.
/// <p>
/// ValueSet
Property options As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "options", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Permitted answer.
Property option As list Of HS.FHIR.DTL.vSTU3.Model.Element.Questionnaire.item.option(XMLNAME = "option", XMLPROJECTION = "ELEMENT");

/// Attachment
/// <p>
/// Default value when item is first rendered.
Property initialAttachment As HS.FHIR.DTL.vSTU3.Model.Datatype.Attachment(XMLNAME = "initialAttachment", XMLPROJECTION = "ELEMENT");

/// boolean
/// <p>
/// Default value when item is first rendered.
Property initialBoolean As %Boolean(XMLNAME = "initialBoolean", XMLPROJECTION = "ATTRIBUTE");

/// Coding
/// <p>
/// Default value when item is first rendered.
/// <p>
/// any FHIR3 code may be used; 
/// questionnaire-answers shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property initialCoding As HS.FHIR.DTL.vSTU3.Model.Datatype.Coding(XMLNAME = "initialCoding", XMLPROJECTION = "ELEMENT");

/// date
/// <p>
/// Default value when item is first rendered.
Property initialDate As %String(MAXLEN = 1000000, XMLNAME = "initialDate", XMLPROJECTION = "ATTRIBUTE");

/// dateTime
/// <p>
/// Default value when item is first rendered.
Property initialDateTime As %String(MAXLEN = 1000000, XMLNAME = "initialDateTime", XMLPROJECTION = "ATTRIBUTE");

/// decimal
/// <p>
/// Default value when item is first rendered.
Property initialDecimal As %Decimal(XMLNAME = "initialDecimal", XMLPROJECTION = "ATTRIBUTE");

/// integer
/// <p>
/// Default value when item is first rendered.
Property initialInteger As %Integer(XMLNAME = "initialInteger", XMLPROJECTION = "ATTRIBUTE");

/// Quantity
/// <p>
/// Default value when item is first rendered.
Property initialQuantity As HS.FHIR.DTL.vSTU3.Model.Datatype.Quantity(XMLNAME = "initialQuantity", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Default value when item is first rendered.
/// <p>
/// Any FHIR3 Resource may be indicated by this Reference.
Property initialReference As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "initialReference", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Default value when item is first rendered.
Property initialString As %String(MAXLEN = 1000000, XMLNAME = "initialString", XMLPROJECTION = "ATTRIBUTE");

/// time
/// <p>
/// Default value when item is first rendered.
Property initialTime As %String(MAXLEN = 1000000, XMLNAME = "initialTime", XMLPROJECTION = "ATTRIBUTE");

/// uri
/// <p>
/// Default value when item is first rendered.
Property initialUri As %String(MAXLEN = 1000000, XMLNAME = "initialUri", XMLPROJECTION = "ATTRIBUTE");

/// Questionnaire:item
/// <p>
/// Nested questionnaire items.
Property item As list Of HS.FHIR.DTL.vSTU3.Model.Element.Questionnaire.item(XMLNAME = "item", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Questionnaire.item";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Questionnaire.item";

}
