/// A structured set of questions.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.Questionnaire Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// External identifiers for this questionnaire.
Property identifier As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Logical identifier for this version of Questionnaire.
Property version As %String(MAXLEN = 1000000, XMLNAME = "version", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// draft | published | retired
/// <p>
/// questionnaire-status is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend questionnaire-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// dateTime
/// <p>
/// Date this version was authored.
Property date As %String(MAXLEN = 1000000, XMLNAME = "date", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Organization/individual who designed the questionnaire.
Property publisher As %String(MAXLEN = 1000000, XMLNAME = "publisher", XMLPROJECTION = "ATTRIBUTE");

/// ContactPoint
/// <p>
/// Contact information of the publisher.
Property telecom As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.ContactPoint(XMLNAME = "telecom", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// Resource that can be subject of QuestionnaireResponse.
/// <p>
/// resource-types is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend resource-types and you may NOT use codes from other ValueSets.
Property subjectType As list Of %String(MAXLEN = 1000000, XMLNAME = "subjectType", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Grouped questions.
Property group As HS.FHIR.DTL.vDSTU2.Model.Element.Questionnaire.group(XMLNAME = "group", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Questionnaire";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Questionnaire";

}
