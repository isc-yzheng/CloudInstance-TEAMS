/// Notes.
Class HS.FHIR.DTL.vDSTU2.Model.Element.ProcessResponse.notes Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Coding
/// <p>
/// display | print | printoper
/// <p>
/// note-type is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend note-type and you may NOT use codes from other ValueSets.
Property type As HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Notes text.
Property text As %String(MAXLEN = 1000000, XMLNAME = "text", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ProcessResponse.notes";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ProcessResponse.notes";

}
