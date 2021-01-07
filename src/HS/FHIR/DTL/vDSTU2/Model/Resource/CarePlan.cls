/// Healthcare plan for patient or group.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.CarePlan Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// External Ids for this plan.
Property identifier As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Who care plan is for.
/// <p>
/// Patient | Group
Property subject As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "subject", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// proposed | draft | active | completed | cancelled
/// <p>
/// care-plan-status is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend care-plan-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Reference
/// <p>
/// Created in context of.
/// <p>
/// Encounter | EpisodeOfCare
Property context As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "context", XMLPROJECTION = "ELEMENT");

/// Period
/// <p>
/// Time period plan covers.
Property period As HS.FHIR.DTL.vDSTU2.Model.Datatype.Period(XMLNAME = "period", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Who is responsible for contents of the plan.
/// <p>
/// Patient | Practitioner | RelatedPerson | Organization
Property author As list Of HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "author", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// When last updated.
Property modified As %String(MAXLEN = 1000000, XMLNAME = "modified", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Type of plan.
/// <p>
/// any FHIR2 code may be used; 
/// care-plan-category shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property category As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "category", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Summary of nature of plan.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Health issues this plan addresses.
/// <p>
/// Condition
Property addresses As list Of HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "addresses", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Information considered as part of plan.
/// <p>
/// Any FHIR2 Resource may be indicated by this Reference
Property support As list Of HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "support", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Plans related to this one.
Property relatedPlan As list Of HS.FHIR.DTL.vDSTU2.Model.Element.CarePlan.relatedPlan(XMLNAME = "relatedPlan", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Who's involved in plan?
Property participant As list Of HS.FHIR.DTL.vDSTU2.Model.Element.CarePlan.participant(XMLNAME = "participant", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Desired outcome of plan.
/// <p>
/// Goal
Property goal As list Of HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "goal", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Action to occur as part of plan.
Property activity As list Of HS.FHIR.DTL.vDSTU2.Model.Element.CarePlan.activity(XMLNAME = "activity", XMLPROJECTION = "ELEMENT");

/// Annotation
/// <p>
/// Comments about the plan.
Property note As HS.FHIR.DTL.vDSTU2.Model.Datatype.Annotation(XMLNAME = "note", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "CarePlan";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "CarePlan";

}
