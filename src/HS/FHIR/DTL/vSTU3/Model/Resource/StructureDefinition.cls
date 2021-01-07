/// A definition of a FHIR structure. 
/// This resource is used to describe the underlying resources, 
/// data types defined in FHIR, 
/// and also for describing extensions and constraints on resources and data types.
Class HS.FHIR.DTL.vSTU3.Model.Resource.StructureDefinition Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// uri
/// <p>
/// Logical URI to reference this structure definition (globally unique)
Property url As %String(MAXLEN = 1000000, XMLNAME = "url", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Identifier
/// <p>
/// Additional identifier for the structure definition.
Property identifier As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Business version of the structure definition.
Property version As %String(MAXLEN = 1000000, XMLNAME = "version", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Name for this structure definition (computer friendly)
Property name As %String(MAXLEN = 1000000, XMLNAME = "name", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// string
/// <p>
/// Name for this structure definition (human friendly)
Property title As %String(MAXLEN = 1000000, XMLNAME = "title", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// draft | active | retired | unknown
/// <p>
/// publication-status is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend publication-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// boolean
/// <p>
/// For testing purposes, 
/// not real usage.
Property experimental As %Boolean(XMLNAME = "experimental", XMLPROJECTION = "ATTRIBUTE");

/// dateTime
/// <p>
/// Date this was last changed.
Property date As %String(MAXLEN = 1000000, XMLNAME = "date", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Name of the publisher (organization or individual)
Property publisher As %String(MAXLEN = 1000000, XMLNAME = "publisher", XMLPROJECTION = "ATTRIBUTE");

/// ContactDetail
/// <p>
/// Contact details for the publisher.
Property contact As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.ContactDetail(XMLNAME = "contact", XMLPROJECTION = "ELEMENT");

/// markdown
/// <p>
/// Natural language description of the structure definition.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

/// UsageContext
/// <p>
/// Context the content is intended to support.
Property useContext As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.UsageContext(XMLNAME = "useContext", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Intended jurisdiction for structure definition (if applicable)
/// <p>
/// jurisdiction is the REQUIRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in jurisdiction, 
/// you may formally EXTEND jurisdiction to add codes to it.
Property jurisdiction As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "jurisdiction", XMLPROJECTION = "ELEMENT");

/// markdown
/// <p>
/// Why this structure definition is defined.
Property purpose As %String(MAXLEN = 1000000, XMLNAME = "purpose", XMLPROJECTION = "ATTRIBUTE");

/// markdown
/// <p>
/// Use and/or publishing restrictions.
Property copyright As %String(MAXLEN = 1000000, XMLNAME = "copyright", XMLPROJECTION = "ATTRIBUTE");

/// Coding
/// <p>
/// Assist with indexing and finding.
/// <p>
/// any FHIR3 code may be used; 
/// profile-code shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property keyword As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Coding(XMLNAME = "keyword", XMLPROJECTION = "ELEMENT");

/// id
/// <p>
/// FHIR Version this StructureDefinition targets.
Property fhirVersion As %String(MAXLEN = 1000000, XMLNAME = "fhirVersion", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// External specification that the content is mapped to.
Property mapping As list Of HS.FHIR.DTL.vSTU3.Model.Element.StructureDefinition.mapping(XMLNAME = "mapping", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// primitive-type | complex-type | resource | logical
/// <p>
/// structure-definition-kind is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend structure-definition-kind and you may NOT use codes from other ValueSets.
Property kind As %String(MAXLEN = 1000000, XMLNAME = "kind", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// boolean
/// <p>
/// Whether the structure is abstract.
Property abstract As %Boolean(XMLNAME = "abstract", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// code
/// <p>
/// resource | datatype | extension
/// <p>
/// extension-context is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend extension-context and you may NOT use codes from other ValueSets.
Property contextType As %String(MAXLEN = 1000000, XMLNAME = "contextType", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Where the extension can be used in instances.
Property context As list Of %String(MAXLEN = 1000000, XMLNAME = "context", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// FHIRPath invariants - when the extension can be used.
Property contextInvariant As list Of %String(MAXLEN = 1000000, XMLNAME = "contextInvariant", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// Type defined or constrained by this structure.
/// <p>
/// defined-types is the REQUIRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in defined-types, 
/// you may formally EXTEND defined-types to add codes to it.
Property type As %String(MAXLEN = 1000000, XMLNAME = "type", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// uri
/// <p>
/// Definition that this type is constrained/specialized from.
Property baseDefinition As %String(MAXLEN = 1000000, XMLNAME = "baseDefinition", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// specialization | constraint - How relates to base definition
/// <p>
/// type-derivation-rule is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend type-derivation-rule and you may NOT use codes from other ValueSets.
Property derivation As %String(MAXLEN = 1000000, XMLNAME = "derivation", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Snapshot view of the structure.
Property snapshot As HS.FHIR.DTL.vSTU3.Model.Element.StructureDefinition.snapshot(XMLNAME = "snapshot", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Differential view of the structure.
Property differential As HS.FHIR.DTL.vSTU3.Model.Element.StructureDefinition.differential(XMLNAME = "differential", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "StructureDefinition";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "StructureDefinition";

}
