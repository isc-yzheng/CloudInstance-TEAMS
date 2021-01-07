/// Certificates associated with security profiles.
Class HS.FHIR.DTL.vSTU3.Model.Element.CapabilityStatement.rest.security.certificate Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// code
/// <p>
/// Mime type for certificates.
/// <p>
/// MimeType RFC 4289 is the REQUIRED IETF specification for the FHIR3 code values that may be used.
Property type As %String(MAXLEN = 1000000, XMLNAME = "type", XMLPROJECTION = "ATTRIBUTE");

/// base64Binary
/// <p>
/// Actual certificate.
Property blob As %Binary(XMLNAME = "blob", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "CapabilityStatement.rest.security.certificate";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "CapabilityStatement.rest.security.certificate";

}
