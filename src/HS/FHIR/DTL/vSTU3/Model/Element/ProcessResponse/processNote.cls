/// Processing comments or additional requirements.
Class HS.FHIR.DTL.vSTU3.Model.Element.ProcessResponse.processNote Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// display | print | printoper
/// <p>
/// note-type is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend note-type and you may NOT use codes from other ValueSets.
Property type As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Comment on the processing.
Property text As %String(MAXLEN = 1000000, XMLNAME = "text", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ProcessResponse.processNote";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ProcessResponse.processNote";

}
