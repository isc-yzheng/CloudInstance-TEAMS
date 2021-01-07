/// A binary resource can contain any content, 
/// whether text, 
/// image, 
/// pdf, 
/// zip archive, 
/// etc.
Class HS.FHIR.DTL.vSTU3.Model.Resource.Binary Extends HS.FHIR.DTL.vSTU3.Model.Base.Resource [ Not ProcedureBlock ]
{

/// code
/// <p>
/// MimeType of the binary content.
/// <p>
/// MimeType RFC 4289 is the REQUIRED IETF specification for the FHIR3 code values that may be used.
Property contentType As %String(MAXLEN = 1000000, XMLNAME = "contentType", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Reference
/// <p>
/// Access Control Management.
/// <p>
/// Any FHIR3 Resource may be indicated by this Reference
Property securityContext As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "securityContext", XMLPROJECTION = "ELEMENT");

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
