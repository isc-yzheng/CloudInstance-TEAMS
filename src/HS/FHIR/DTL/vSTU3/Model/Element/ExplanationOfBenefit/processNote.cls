/// Processing notes.
Class HS.FHIR.DTL.vSTU3.Model.Element.ExplanationOfBenefit.processNote Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// positiveInt
/// <p>
/// Sequence number for this note.
Property number As %Integer(XMLNAME = "number", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// display | print | printoper
/// <p>
/// forms is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend forms and you may NOT use codes from other ValueSets.
Property type As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Note explanitory text.
Property text As %String(MAXLEN = 1000000, XMLNAME = "text", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Language if different from the resource.
/// <p>
/// languages is the REQUIRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in languages, 
/// you may formally EXTEND languages to add codes to it.
Property language As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "language", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ExplanationOfBenefit.processNote";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ExplanationOfBenefit.processNote";

}
