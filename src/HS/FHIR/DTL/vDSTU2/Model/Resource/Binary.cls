/// Pure binary content defined by some other format than FHIR.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.Binary Extends HS.FHIR.DTL.vDSTU2.Model.Base.Resource [ Not ProcedureBlock ]
{

/// code
/// <p>
/// MimeType of the binary content.
/// <p>
/// MimeType RFC 4289 is the REQUIRED IETF specification for the FHIR2 code values that may be used.
Property contentType As %String(MAXLEN = 1000000, XMLNAME = "contentType", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// base64Binary
/// <p>
/// The actual content.
Property content As %Binary(XMLNAME = "content", XMLPROJECTION = "ATTRIBUTE") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Binary";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Binary";

}
