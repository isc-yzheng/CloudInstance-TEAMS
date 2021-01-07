/// The items included.
Class HS.FHIR.DTL.vDSTU2.Model.Element.DocumentManifest.content Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Attachment
/// <p>
/// Contents of this set of documents.
Property pAttachment As HS.FHIR.DTL.vDSTU2.Model.Datatype.Attachment(XMLNAME = "pAttachment", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Contents of this set of documents.
/// <p>
/// Any FHIR2 Resource may be indicated by this Reference.
Property pReference As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "pReference", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "DocumentManifest.content";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "DocumentManifest.content";

}
