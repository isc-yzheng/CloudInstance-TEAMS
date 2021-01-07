/// A collection of documents compiled for a purpose together with metadata that applies to the collection.
Class HS.FHIR.DTL.vSTU3.Model.Resource.DocumentManifest Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Unique Identifier for the set of documents.
Property masterIdentifier As HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "masterIdentifier", XMLPROJECTION = "ELEMENT");

/// Identifier
/// <p>
/// Other identifiers for the manifest.
Property identifier As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// current | superseded | entered-in-error
/// <p>
/// document-reference-status is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend document-reference-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// CodeableConcept
/// <p>
/// Kind of document set.
/// <p>
/// c80-doc-typecodes is the PREFERRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in c80-doc-typecodes, 
/// you may use codes from any ValueSet.
Property type As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// The subject of the set of documents.
/// <p>
/// Patient | Practitioner | Group | Device
Property subject As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "subject", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// When this document manifest created.
Property created As %String(MAXLEN = 1000000, XMLNAME = "created", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Who and/or what authored the manifest.
/// <p>
/// Practitioner | Organization | Device | Patient | RelatedPerson
Property author As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "author", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Intended to get notified about this set of documents.
/// <p>
/// Patient | Practitioner | RelatedPerson | Organization
Property recipient As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "recipient", XMLPROJECTION = "ELEMENT");

/// uri
/// <p>
/// The source system/application/software.
Property source As %String(MAXLEN = 1000000, XMLNAME = "source", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Human-readable description (title)
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// The items included.
Property content As list Of HS.FHIR.DTL.vSTU3.Model.Element.DocumentManifest.content(XMLNAME = "content", XMLPROJECTION = "ELEMENT") [ Required ];

/// BackboneElement
/// <p>
/// Related things.
Property related As list Of HS.FHIR.DTL.vSTU3.Model.Element.DocumentManifest.related(XMLNAME = "related", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "DocumentManifest";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "DocumentManifest";

}
