/// The Measure resource provides the definition of a quality measure. 
/// NOTE: This resource is a definition resource from a FHIR workflow perspective - see Workflow, 
/// specifically Definition.
Class HS.FHIR.DTL.vSTU3.Model.Resource.Measure Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// uri
/// <p>
/// Logical URI to reference this measure (globally unique)
Property url As %String(MAXLEN = 1000000, XMLNAME = "url", XMLPROJECTION = "ATTRIBUTE");

/// Identifier
/// <p>
/// Additional identifier for the measure.
Property identifier As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Business version of the measure.
Property version As %String(MAXLEN = 1000000, XMLNAME = "version", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Name for this measure (computer friendly)
Property name As %String(MAXLEN = 1000000, XMLNAME = "name", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Name for this measure (human friendly)
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

/// markdown
/// <p>
/// Natural language description of the measure.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

/// markdown
/// <p>
/// Why this measure is defined.
Property purpose As %String(MAXLEN = 1000000, XMLNAME = "purpose", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Describes the clinical usage of the measure.
Property usage As %String(MAXLEN = 1000000, XMLNAME = "usage", XMLPROJECTION = "ATTRIBUTE");

/// date
/// <p>
/// When the measure was approved by publisher.
Property approvalDate As %String(MAXLEN = 1000000, XMLNAME = "approvalDate", XMLPROJECTION = "ATTRIBUTE");

/// date
/// <p>
/// When the measure was last reviewed.
Property lastReviewDate As %String(MAXLEN = 1000000, XMLNAME = "lastReviewDate", XMLPROJECTION = "ATTRIBUTE");

/// Period
/// <p>
/// When the measure is expected to be used.
Property effectivePeriod As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "effectivePeriod", XMLPROJECTION = "ELEMENT");

/// UsageContext
/// <p>
/// Context the content is intended to support.
Property useContext As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.UsageContext(XMLNAME = "useContext", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Intended jurisdiction for measure (if applicable)
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

/// Reference
/// <p>
/// Logic used by the measure.
/// <p>
/// Library
Property library As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "library", XMLPROJECTION = "ELEMENT");

/// markdown
/// <p>
/// Disclaimer for use of the measure or its referenced content.
Property disclaimer As %String(MAXLEN = 1000000, XMLNAME = "disclaimer", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// proportion | ratio | continuous-variable | cohort
/// <p>
/// measure-scoring is the REQUIRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in measure-scoring, 
/// you may formally EXTEND measure-scoring to add codes to it.
Property scoring As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "scoring", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// opportunity | all-or-nothing | linear | weighted
/// <p>
/// composite-measure-scoring is the REQUIRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in composite-measure-scoring, 
/// you may formally EXTEND composite-measure-scoring to add codes to it.
Property compositeScoring As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "compositeScoring", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// process | outcome | structure | patient-reported-outcome | composite
/// <p>
/// measure-type is the REQUIRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in measure-type, 
/// you may formally EXTEND measure-type to add codes to it.
Property type As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// How is risk adjustment applied for this measure.
Property riskAdjustment As %String(MAXLEN = 1000000, XMLNAME = "riskAdjustment", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// How is rate aggregation performed for this measure.
Property rateAggregation As %String(MAXLEN = 1000000, XMLNAME = "rateAggregation", XMLPROJECTION = "ATTRIBUTE");

/// markdown
/// <p>
/// Why does this measure exist.
Property rationale As %String(MAXLEN = 1000000, XMLNAME = "rationale", XMLPROJECTION = "ATTRIBUTE");

/// markdown
/// <p>
/// Summary of clinical guidelines.
Property clinicalRecommendationStatement As %String(MAXLEN = 1000000, XMLNAME = "clinicalRecommendationStatement", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Improvement notation for the measure, 
/// e.g. 
/// higher score indicates better quality.
Property improvementNotation As %String(MAXLEN = 1000000, XMLNAME = "improvementNotation", XMLPROJECTION = "ATTRIBUTE");

/// markdown
/// <p>
/// Defined terms used in the measure documentation.
Property definition As list Of %String(MAXLEN = 1000000, XMLNAME = "definition", XMLPROJECTION = "ELEMENT");

/// markdown
/// <p>
/// Additional guidance for implementers.
Property guidance As %String(MAXLEN = 1000000, XMLNAME = "guidance", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// The measure set, 
/// e.g. 
/// Preventive Care and Screening.
Property set As %String(MAXLEN = 1000000, XMLNAME = "set", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Population criteria group.
Property group As list Of HS.FHIR.DTL.vSTU3.Model.Element.Measure.group(XMLNAME = "group", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// What other data should be reported with the measure.
Property supplementalData As list Of HS.FHIR.DTL.vSTU3.Model.Element.Measure.supplementalData(XMLNAME = "supplementalData", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Measure";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Measure";

}
