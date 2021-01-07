/// The Library resource is a general-purpose container for knowledge asset definitions. 
/// It can be used to describe and expose existing knowledge assets such as logic libraries and information model descriptions, 
/// as well as to describe a collection of knowledge assets.
Class HS.FHIR.DTL.vSTU3.Model.Resource.Library Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// uri
/// <p>
/// Logical URI to reference this library (globally unique)
Property url As %String(MAXLEN = 1000000, XMLNAME = "url", XMLPROJECTION = "ATTRIBUTE");

/// Identifier
/// <p>
/// Additional identifier for the library.
Property identifier As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Business version of the library.
Property version As %String(MAXLEN = 1000000, XMLNAME = "version", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Name for this library (computer friendly)
Property name As %String(MAXLEN = 1000000, XMLNAME = "name", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Name for this library (human friendly)
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

/// CodeableConcept
/// <p>
/// logic-library | model-definition | asset-collection | module-definition
/// <p>
/// library-type is the REQUIRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in library-type, 
/// you may formally EXTEND library-type to add codes to it.
Property type As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT") [ Required ];

/// dateTime
/// <p>
/// Date this was last changed.
Property date As %String(MAXLEN = 1000000, XMLNAME = "date", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Name of the publisher (organization or individual)
Property publisher As %String(MAXLEN = 1000000, XMLNAME = "publisher", XMLPROJECTION = "ATTRIBUTE");

/// markdown
/// <p>
/// Natural language description of the library.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

/// markdown
/// <p>
/// Why this library is defined.
Property purpose As %String(MAXLEN = 1000000, XMLNAME = "purpose", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Describes the clinical usage of the library.
Property usage As %String(MAXLEN = 1000000, XMLNAME = "usage", XMLPROJECTION = "ATTRIBUTE");

/// date
/// <p>
/// When the library was approved by publisher.
Property approvalDate As %String(MAXLEN = 1000000, XMLNAME = "approvalDate", XMLPROJECTION = "ATTRIBUTE");

/// date
/// <p>
/// When the library was last reviewed.
Property lastReviewDate As %String(MAXLEN = 1000000, XMLNAME = "lastReviewDate", XMLPROJECTION = "ATTRIBUTE");

/// Period
/// <p>
/// When the library is expected to be used.
Property effectivePeriod As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "effectivePeriod", XMLPROJECTION = "ELEMENT");

/// UsageContext
/// <p>
/// Context the content is intended to support.
Property useContext As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.UsageContext(XMLNAME = "useContext", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Intended jurisdiction for library (if applicable)
/// <p>
/// jurisdiction is the REQUIRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in jurisdiction, 
/// you may formally EXTEND jurisdiction to add codes to it.
Property jurisdiction As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "jurisdiction", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// E.g. 
/// Education, 
/// Treatment, 
/// Assessment, 
/// etc.
/// <p>
/// any FHIR3 code may be used; 
/// definition-topic shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property topic As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "topic", XMLPROJECTION = "ELEMENT");

/// Contributor
/// <p>
/// A content contributor.
Property contributor As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Contributor(XMLNAME = "contributor", XMLPROJECTION = "ELEMENT");

/// ContactDetail
/// <p>
/// Contact details for the publisher.
Property contact As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.ContactDetail(XMLNAME = "contact", XMLPROJECTION = "ELEMENT");

/// markdown
/// <p>
/// Use and/or publishing restrictions.
Property copyright As %String(MAXLEN = 1000000, XMLNAME = "copyright", XMLPROJECTION = "ATTRIBUTE");

/// RelatedArtifact
/// <p>
/// Additional documentation, 
/// citations, 
/// etc.
Property relatedArtifact As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.RelatedArtifact(XMLNAME = "relatedArtifact", XMLPROJECTION = "ELEMENT");

/// ParameterDefinition
/// <p>
/// Parameters defined by the library.
Property parameter As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.ParameterDefinition(XMLNAME = "parameter", XMLPROJECTION = "ELEMENT");

/// DataRequirement
/// <p>
/// What data is referenced by this library.
Property dataRequirement As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.DataRequirement(XMLNAME = "dataRequirement", XMLPROJECTION = "ELEMENT");

/// Attachment
/// <p>
/// Contents of the library, 
/// either embedded or referenced.
Property content As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Attachment(XMLNAME = "content", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Library";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Library";

}
