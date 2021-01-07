/// Additional representations for this concept.
Class HS.FHIR.DTL.vSTU3.Model.Element.ValueSet.compose.include.concept.designation Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// code
/// <p>
/// Human language of the designation.
/// <p>
/// languages is the REQUIRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in languages, 
/// you may formally EXTEND languages to add codes to it.
Property language As %String(MAXLEN = 1000000, XMLNAME = "language", XMLPROJECTION = "ATTRIBUTE");

/// Coding
/// <p>
/// Details how this designation would be used.
/// <p>
/// designation-use is the REQUIRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in designation-use, 
/// you may formally EXTEND designation-use to add codes to it.
Property use As HS.FHIR.DTL.vSTU3.Model.Datatype.Coding(XMLNAME = "use", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// The text value for this designation.
Property value As %String(MAXLEN = 1000000, XMLNAME = "value", XMLPROJECTION = "ATTRIBUTE") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ValueSet.compose.include.concept.designation";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ValueSet.compose.include.concept.designation";

}
