/// A CodeableConcept represents a value that is usually supplied by providing a reference to one or more terminologies or ontologies, 
/// but may also be defined by the provision of text. 
/// This is a common pattern in healthcare data.
Class HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept Extends HS.FHIR.DTL.vSTU3.Model.Base.Element [ Not ProcedureBlock ]
{

/// Coding
/// <p>
/// Code defined by a terminology system.
/// <p>
/// any FHIR3 code from any ValueSet may be used.
Property coding As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Coding(XMLNAME = "coding", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Plain text representation of the concept.
Property text As %String(MAXLEN = 1000000, XMLNAME = "text", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "CodeableConcept";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "CodeableConcept";

}
