/// Processing notes.
Class HS.FHIR.DTL.vSTU3.Model.Element.ClaimResponse.processNote Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// positiveInt
/// <p>
/// Sequence Number for this note.
Property number As %Integer(XMLNAME = "number", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// display | print | printoper
/// <p>
/// note-type is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend note-type and you may NOT use codes from other ValueSets.
Property type As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Note explanatory text.
Property text As %String(MAXLEN = 1000000, XMLNAME = "text", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Language if different from the resource.
/// <p>
/// languages+ is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend languages+ and you may NOT use codes from other ValueSets.
Property language As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "language", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ClaimResponse.processNote";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ClaimResponse.processNote";

}
