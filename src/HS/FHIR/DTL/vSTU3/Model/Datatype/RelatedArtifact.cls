/// The RelatedArtifact structure defines resources related to a module such as previous and next versions of documents, 
/// documentation, 
/// citations, 
/// etc. 
/// Note that the name resource here is being used in a more general sense than the FHIR-specific Resource. 
/// The related resource may be a FHIR resource, 
/// or it may be another type of resource, 
/// represented using the Attachment data type.
Class HS.FHIR.DTL.vSTU3.Model.Datatype.RelatedArtifact Extends HS.FHIR.DTL.vSTU3.Model.Base.Element [ Not ProcedureBlock ]
{

/// code
/// <p>
/// documentation | justification | citation | predecessor | successor | derived-from | depends-on | composed-of
/// <p>
/// related-artifact-type is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend related-artifact-type and you may NOT use codes from other ValueSets.
Property type As %String(MAXLEN = 1000000, XMLNAME = "type", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// string
/// <p>
/// Brief description of the related artifact.
Property display As %String(MAXLEN = 1000000, XMLNAME = "display", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Bibliographic citation for the artifact.
Property citation As %String(MAXLEN = 1000000, XMLNAME = "citation", XMLPROJECTION = "ATTRIBUTE");

/// uri
/// <p>
/// Where the artifact can be accessed.
Property url As %String(MAXLEN = 1000000, XMLNAME = "url", XMLPROJECTION = "ATTRIBUTE");

/// Attachment
/// <p>
/// What document is being referenced.
Property document As HS.FHIR.DTL.vSTU3.Model.Datatype.Attachment(XMLNAME = "document", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// What resource is being referenced.
/// <p>
/// Any FHIR3 Resource may be indicated by this Reference
Property resource As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "resource", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "RelatedArtifact";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "RelatedArtifact";

}
