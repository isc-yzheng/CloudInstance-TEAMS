/// Concept - reference to a terminology or just  text.
Class HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept Extends HS.FHIR.DTL.vR4.Model.Base.Element [ Not ProcedureBlock ]
{

/// Coding
/// <p>
/// Code defined by a terminology system.
/// <p>
/// any FHIR4 code from any ValueSet may be used.
Property coding As list Of HS.FHIR.DTL.vR4.Model.Datatype.Coding(XMLNAME = "coding", XMLPROJECTION = "ELEMENT");

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
