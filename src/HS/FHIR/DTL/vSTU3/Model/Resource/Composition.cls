/// A set of healthcare-related information that is assembled together into a single logical document that provides a single coherent statement of meaning, 
/// establishes its own context and that has clinical attestation with regard to who is making the statement. 
/// While a Composition defines the structure, 
/// it does not actually contain the content: rather the full content of a document is contained in a Bundle, 
/// of which the Composition is the first resource contained.
Class HS.FHIR.DTL.vSTU3.Model.Resource.Composition Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Logical identifier of composition (version-independent)
Property identifier As HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// preliminary | final | amended | entered-in-error
/// <p>
/// composition-status is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend composition-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// CodeableConcept
/// <p>
/// Kind of composition (LOINC if possible)
/// <p>
/// doc-typecodes is the PREFERRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in doc-typecodes, 
/// you may use codes from any ValueSet.
Property type As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT") [ Required ];

/// CodeableConcept
/// <p>
/// Categorization of Composition.
/// <p>
/// any FHIR3 code may be used; 
/// doc-classcodes shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property class As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "class", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Who and/or what the composition is about.
/// <p>
/// Any FHIR3 Resource may be indicated by this Reference
Property subject As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "subject", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Context of the Composition.
/// <p>
/// Encounter
Property encounter As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "encounter", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// Composition editing time.
Property date As %String(MAXLEN = 1000000, XMLNAME = "date", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Reference
/// <p>
/// Who and/or what authored the composition.
/// <p>
/// Practitioner | Device | Patient | RelatedPerson
Property author As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "author", XMLPROJECTION = "ELEMENT") [ Required ];

/// string
/// <p>
/// Human Readable name/title.
Property title As %String(MAXLEN = 1000000, XMLNAME = "title", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// code
/// <p>
/// As defined by affinity domain.
/// <p>
/// v3-ConfidentialityClassification is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend v3-ConfidentialityClassification and you may NOT use codes from other ValueSets.
Property confidentiality As %String(MAXLEN = 1000000, XMLNAME = "confidentiality", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Attests to accuracy of composition.
Property attester As list Of HS.FHIR.DTL.vSTU3.Model.Element.Composition.attester(XMLNAME = "attester", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Organization which maintains the composition.
/// <p>
/// Organization
Property custodian As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "custodian", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Relationships to other compositions/documents.
Property relatesTo As list Of HS.FHIR.DTL.vSTU3.Model.Element.Composition.relatesTo(XMLNAME = "relatesTo", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// The clinical service(s) being documented.
Property event As list Of HS.FHIR.DTL.vSTU3.Model.Element.Composition.event(XMLNAME = "event", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Composition is broken into sections.
Property section As list Of HS.FHIR.DTL.vSTU3.Model.Element.Composition.section(XMLNAME = "section", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Composition";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Composition";

}
