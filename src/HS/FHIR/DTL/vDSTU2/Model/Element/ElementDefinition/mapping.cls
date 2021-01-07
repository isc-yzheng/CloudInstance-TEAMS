/// Map element to another set of definitions.
Class HS.FHIR.DTL.vDSTU2.Model.Element.ElementDefinition.mapping Extends HS.FHIR.DTL.vDSTU2.Model.Base.Element [ Not ProcedureBlock ]
{

/// id
/// <p>
/// Reference to mapping declaration.
Property identity As %String(MAXLEN = 1000000, XMLNAME = "identity", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// code
/// <p>
/// Computable language of mapping.
/// <p>
/// MimeType RFC 4289 is the REQUIRED IETF specification for the FHIR2 code values that may be used.
Property language As %String(MAXLEN = 1000000, XMLNAME = "language", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Details of the mapping.
Property map As %String(MAXLEN = 1000000, XMLNAME = "map", XMLPROJECTION = "ATTRIBUTE") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "mapping";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "mapping";

}
