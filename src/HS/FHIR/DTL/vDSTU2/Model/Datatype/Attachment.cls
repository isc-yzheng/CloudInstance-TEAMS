/// This type is for containing or referencing attachments - additional data content defined in other formats. 
/// The most common use of this type is to include images or reports in some report format such as PDF. 
/// However it can be used for any data that has a MIME type.
Class HS.FHIR.DTL.vDSTU2.Model.Datatype.Attachment Extends HS.FHIR.DTL.vDSTU2.Model.Base.Element [ Not ProcedureBlock ]
{

/// code
/// <p>
/// Mime type of the content, 
/// with charset etc.
/// <p>
/// MimeType RFC 4289 is the REQUIRED IETF specification for the FHIR2 code values that may be used.
Property contentType As %String(MAXLEN = 1000000, XMLNAME = "contentType", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// Human language of the content (BCP-47)
/// <p>
/// Language RFC 5646 is the REQUIRED IETF specification for the FHIR2 code values that may be used.
Property language As %String(MAXLEN = 1000000, XMLNAME = "language", XMLPROJECTION = "ATTRIBUTE");

/// base64Binary
/// <p>
/// Data inline, 
/// base64ed.
Property data As %Binary(XMLNAME = "data", XMLPROJECTION = "ATTRIBUTE");

/// uri
/// <p>
/// Uri where the data can be found.
Property url As %String(MAXLEN = 1000000, XMLNAME = "url", XMLPROJECTION = "ATTRIBUTE");

/// unsignedInt
/// <p>
/// Number of bytes of content (if url provided)
Property size As %Integer(XMLNAME = "size", XMLPROJECTION = "ATTRIBUTE");

/// base64Binary
/// <p>
/// Hash of the data (sha-1, 
/// base64ed)
Property hash As %Binary(XMLNAME = "hash", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Label to display in place of the data.
Property title As %String(MAXLEN = 1000000, XMLNAME = "title", XMLPROJECTION = "ATTRIBUTE");

/// dateTime
/// <p>
/// Date attachment was first created.
Property creation As %String(MAXLEN = 1000000, XMLNAME = "creation", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Attachment";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Attachment";

}
