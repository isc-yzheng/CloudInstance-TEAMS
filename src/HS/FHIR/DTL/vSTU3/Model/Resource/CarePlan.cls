/// Describes the intention of how one or more practitioners intend to deliver care for a particular patient, 
/// group or community for a period of time, 
/// possibly limited to care for a specific condition or set of conditions.
Class HS.FHIR.DTL.vSTU3.Model.Resource.CarePlan Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// External Ids for this plan.
Property identifier As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Protocol or definition.
/// <p>
/// PlanDefinition | Questionnaire
Property definition As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "definition", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Fulfills care plan.
/// <p>
/// CarePlan
Property basedOn As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "basedOn", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// CarePlan replaced by this CarePlan.
/// <p>
/// CarePlan
Property replaces As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "replaces", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Part of referenced CarePlan.
/// <p>
/// CarePlan
Property partOf As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "partOf", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// draft | active | suspended | completed | entered-in-error | cancelled | unknown
/// <p>
/// care-plan-status is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend care-plan-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// code
/// <p>
/// Indicates the level of authority/intentionality associated with the care plan and where the care plan fits into the workflow chain.
/// <p>
/// care-plan-intent is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend care-plan-intent and you may NOT use codes from other ValueSets.
Property intent As %String(MAXLEN = 1000000, XMLNAME = "intent", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// CodeableConcept
/// <p>
/// Type of plan.
/// <p>
/// any FHIR3 code may be used; 
/// care-plan-category shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property category As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "category", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Human-friendly name for the CarePlan.
Property title As %String(MAXLEN = 1000000, XMLNAME = "title", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Summary of nature of plan.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Who care plan is for.
/// <p>
/// Patient | Group
Property subject As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "subject", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Created in context of.
/// <p>
/// Encounter | EpisodeOfCare
Property context As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "context", XMLPROJECTION = "ELEMENT");

/// Period
/// <p>
/// Time period plan covers.
Property period As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "period", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Who is responsible for contents of the plan.
/// <p>
/// Patient | Practitioner | RelatedPerson | Organization | CareTeam
Property author As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "author", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Who's involved in plan?
/// <p>
/// CareTeam
Property careTeam As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "careTeam", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Health issues this plan addresses.
/// <p>
/// Condition
Property addresses As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "addresses", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Information considered as part of plan.
/// <p>
/// Any FHIR3 Resource may be indicated by this Reference
Property supportingInfo As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "supportingInfo", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Desired outcome of plan.
/// <p>
/// Goal
Property goal As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "goal", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Action to occur as part of plan.
Property activity As list Of HS.FHIR.DTL.vSTU3.Model.Element.CarePlan.activity(XMLNAME = "activity", XMLPROJECTION = "ELEMENT");

/// Annotation
/// <p>
/// Comments about the plan.
Property note As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Annotation(XMLNAME = "note", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "CarePlan";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "CarePlan";

}
