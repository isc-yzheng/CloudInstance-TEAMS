/// A reference to a document.
Class HS.FHIR.DTL.vSTU3.Model.Resource.DocumentReference Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Master Version Specific Identifier.
Property masterIdentifier As HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "masterIdentifier", XMLPROJECTION = "ELEMENT");

/// Identifier
/// <p>
/// Other identifiers for the document.
Property identifier As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// current | superseded | entered-in-error
/// <p>
/// document-reference-status is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend document-reference-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// code
/// <p>
/// preliminary | final | appended | amended | entered-in-error
/// <p>
/// composition-status is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend composition-status and you may NOT use codes from other ValueSets.
Property docStatus As %String(MAXLEN = 1000000, XMLNAME = "docStatus", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Kind of document (LOINC if possible)
/// <p>
/// c80-doc-typecodes is the PREFERRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in c80-doc-typecodes, 
/// you may use codes from any ValueSet.
Property type As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT") [ Required ];

/// CodeableConcept
/// <p>
/// Categorization of document.
/// <p>
/// any FHIR3 code may be used; 
/// c80-doc-classcodes shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property class As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "class", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Who/what is the subject of the document.
/// <p>
/// Patient | Practitioner | Group | Device
Property subject As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "subject", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// Document creation time.
Property created As %String(MAXLEN = 1000000, XMLNAME = "created", XMLPROJECTION = "ATTRIBUTE");

/// instant
/// <p>
/// When this document reference was created.
Property indexed As %String(MAXLEN = 1000000, XMLNAME = "indexed", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Reference
/// <p>
/// Who and/or what authored the document.
/// <p>
/// Practitioner | Organization | Device | Patient | RelatedPerson
Property author As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "author", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Who/what authenticated the document.
/// <p>
/// Practitioner | Organization
Property authenticator As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "authenticator", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Organization which maintains the document.
/// <p>
/// Organization
Property custodian As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "custodian", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Relationships to other documents.
Property relatesTo As list Of HS.FHIR.DTL.vSTU3.Model.Element.DocumentReference.relatesTo(XMLNAME = "relatesTo", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Human-readable description (title)
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Document security-tags.
/// <p>
/// security-labels is the REQUIRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in security-labels, 
/// you may formally EXTEND security-labels to add codes to it.
Property securityLabel As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "securityLabel", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Document referenced.
Property content As list Of HS.FHIR.DTL.vSTU3.Model.Element.DocumentReference.content(XMLNAME = "content", XMLPROJECTION = "ELEMENT") [ Required ];

/// BackboneElement
/// <p>
/// Clinical context of document.
Property context As HS.FHIR.DTL.vSTU3.Model.Element.DocumentReference.context(XMLNAME = "context", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "DocumentReference";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "DocumentReference";

}
