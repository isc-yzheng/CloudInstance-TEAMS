/// A Signature holds an electronic representation of a signature and its supporting context in a FHIR accessible form. 
/// The signature may either be a cryptographic type (XML DigSig or a JWT), 
/// which is able to provide non-repudiation proof, 
/// or it may be a graphical image that represents a signature or a signature process.
Class HS.FHIR.DTL.vSTU3.Model.Datatype.Signature Extends HS.FHIR.DTL.vSTU3.Model.Base.Element [ Not ProcedureBlock ]
{

/// Coding
/// <p>
/// Indication of the reason the entity signed the object(s)
/// <p>
/// signature-type is the PREFERRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in signature-type, 
/// you may use codes from any ValueSet.
Property type As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Coding(XMLNAME = "type", XMLPROJECTION = "ELEMENT") [ Required ];

/// instant
/// <p>
/// When the signature was created.
Property when As %String(MAXLEN = 1000000, XMLNAME = "when", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Reference
/// <p>
/// Who signed.
/// <p>
/// Practitioner | RelatedPerson | Patient | Device | Organization
Property whoReference As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "whoReference", XMLPROJECTION = "ELEMENT") [ Required ];

/// uri
/// <p>
/// Who signed.
Property whoUri As %String(MAXLEN = 1000000, XMLNAME = "whoUri", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Reference
/// <p>
/// The party represented.
/// <p>
/// Practitioner | RelatedPerson | Patient | Device | Organization
Property onBehalfOfReference As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "onBehalfOfReference", XMLPROJECTION = "ELEMENT");

/// uri
/// <p>
/// The party represented.
Property onBehalfOfUri As %String(MAXLEN = 1000000, XMLNAME = "onBehalfOfUri", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// The technical format of the signature.
/// <p>
/// MimeType RFC 4289 is the REQUIRED IETF specification for the FHIR3 code values that may be used.
Property contentType As %String(MAXLEN = 1000000, XMLNAME = "contentType", XMLPROJECTION = "ATTRIBUTE");

/// base64Binary
/// <p>
/// The actual signature content (XML DigSig. 
/// JWT, 
/// picture, 
/// etc.)
Property blob As %Binary(XMLNAME = "blob", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Signature";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Signature";

}
