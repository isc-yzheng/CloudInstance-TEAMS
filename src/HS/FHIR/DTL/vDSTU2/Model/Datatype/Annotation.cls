/// A text note which also contains information about who made the statement and when.
Class HS.FHIR.DTL.vDSTU2.Model.Datatype.Annotation Extends HS.FHIR.DTL.vDSTU2.Model.Base.Element [ Not ProcedureBlock ]
{

/// Reference
/// <p>
/// Individual responsible for the Annotation: 
/// <p>
/// Practitioner | Patient | RelatedPerson
Property authorReference As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "authorReference", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Individual responsible for the Annotation: 
Property authorString As %String(MAXLEN = 1000000, XMLNAME = "authorString", XMLPROJECTION = "ATTRIBUTE");

/// dateTime
/// <p>
/// When the annotation was made.
Property time As %String(MAXLEN = 1000000, XMLNAME = "time", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// The annotation  - text content.
Property text As %String(MAXLEN = 1000000, XMLNAME = "text", XMLPROJECTION = "ATTRIBUTE") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Annotation";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Annotation";

}
