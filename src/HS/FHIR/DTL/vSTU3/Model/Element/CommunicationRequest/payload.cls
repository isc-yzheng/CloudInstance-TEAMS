/// Message payload.
Class HS.FHIR.DTL.vSTU3.Model.Element.CommunicationRequest.payload Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Attachment
/// <p>
///  Message part content.
Property contentAttachment As HS.FHIR.DTL.vSTU3.Model.Datatype.Attachment(XMLNAME = "contentAttachment", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
///  Message part content.
/// <p>
/// Any FHIR3 Resource may be indicated by this Reference.
Property contentReference As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "contentReference", XMLPROJECTION = "ELEMENT") [ Required ];

/// string
/// <p>
///  Message part content.
Property contentString As %String(MAXLEN = 1000000, XMLNAME = "contentString", XMLPROJECTION = "ATTRIBUTE") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "CommunicationRequest.payload";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "CommunicationRequest.payload";

}
