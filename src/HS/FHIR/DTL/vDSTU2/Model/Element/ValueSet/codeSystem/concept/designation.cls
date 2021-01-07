/// Additional representations for the concept.
Class HS.FHIR.DTL.vDSTU2.Model.Element.ValueSet.codeSystem.concept.designation Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// code
/// <p>
/// Human language of the designation.
/// <p>
/// Language RFC 5646 is the REQUIRED IETF specification for the FHIR2 code values that may be used.
Property language As %String(MAXLEN = 1000000, XMLNAME = "language", XMLPROJECTION = "ATTRIBUTE");

/// Coding
/// <p>
/// Details how this designation would be used.
/// <p>
/// designation-use is the REQUIRED FHIR2 ValueSet for codes, 
/// but if you need to express meanings not found in designation-use, 
/// you may formally EXTEND designation-use to add codes to it.
Property use As HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "use", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// The text value for this designation.
Property value As %String(MAXLEN = 1000000, XMLNAME = "value", XMLPROJECTION = "ATTRIBUTE") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ValueSet.codeSystem.concept.designation";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ValueSet.codeSystem.concept.designation";

}
