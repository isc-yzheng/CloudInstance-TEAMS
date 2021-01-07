/// A record of a request for diagnostic investigations, 
/// treatments, 
/// or operations to be performed.
Class HS.FHIR.DTL.vSTU3.Model.Resource.ProcedureRequest Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Identifiers assigned to this order.
Property identifier As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Protocol or definition.
/// <p>
/// ActivityDefinition | PlanDefinition
Property definition As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "definition", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// What request fulfills.
/// <p>
/// Any FHIR3 Resource may be indicated by this Reference
Property basedOn As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "basedOn", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// What request replaces.
/// <p>
/// Any FHIR3 Resource may be indicated by this Reference
Property replaces As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "replaces", XMLPROJECTION = "ELEMENT");

/// Identifier
/// <p>
/// Composite Request ID.
Property requisition As HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "requisition", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// draft | active | suspended | completed | entered-in-error | cancelled
/// <p>
/// request-status is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend request-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// code
/// <p>
/// Whether the request is a proposal, 
/// plan, 
/// an original order or a reflex order.
/// <p>
/// request-intent is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend request-intent and you may NOT use codes from other ValueSets.
Property intent As %String(MAXLEN = 1000000, XMLNAME = "intent", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// code
/// <p>
/// routine | urgent | asap | stat
/// <p>
/// request-priority is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend request-priority and you may NOT use codes from other ValueSets.
Property priority As %String(MAXLEN = 1000000, XMLNAME = "priority", XMLPROJECTION = "ATTRIBUTE");

/// boolean
/// <p>
/// True if procedure should not be performed.
Property doNotPerform As %Boolean(XMLNAME = "doNotPerform", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Classification of procedure.
/// <p>
/// any FHIR3 code may be used; 
/// procedure-category shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property category As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "category", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// What is being requested/ordered.
/// <p>
/// any FHIR3 code may be used; 
/// procedure-code shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property code As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "code", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Individual the service is ordered for.
/// <p>
/// Patient | Group | Location | Device
Property subject As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "subject", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Encounter or Episode during which request was created.
/// <p>
/// Encounter | EpisodeOfCare
Property context As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "context", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// When procedure should occur. 
/// 
Property occurrenceDateTime As %String(MAXLEN = 1000000, XMLNAME = "occurrenceDateTime", XMLPROJECTION = "ATTRIBUTE");

/// Period
/// <p>
/// When procedure should occur. 
/// 
Property occurrencePeriod As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "occurrencePeriod", XMLPROJECTION = "ELEMENT");

/// Timing
/// <p>
/// When procedure should occur. 
/// 
Property occurrenceTiming As HS.FHIR.DTL.vSTU3.Model.Datatype.Timing(XMLNAME = "occurrenceTiming", XMLPROJECTION = "ELEMENT");

/// boolean
/// <p>
/// Preconditions for procedure or diagnostic.
Property asNeededBoolean As %Boolean(XMLNAME = "asNeededBoolean", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Preconditions for procedure or diagnostic.
/// <p>
/// any FHIR3 code may be used; 
/// medication-as-needed-reason shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property asNeededCodeableConcept As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "asNeededCodeableConcept", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// Date request signed.
Property authoredOn As %String(MAXLEN = 1000000, XMLNAME = "authoredOn", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Who/what is requesting procedure or diagnostic.
Property requester As HS.FHIR.DTL.vSTU3.Model.Element.ProcedureRequest.requester(XMLNAME = "requester", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Performer role.
/// <p>
/// any FHIR3 code may be used; 
/// participant-role shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property performerType As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "performerType", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Requested perfomer.
/// <p>
/// Practitioner | Organization | Patient | Device | RelatedPerson | HealthcareService
Property performer As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "performer", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Explanation/Justification for test.
/// <p>
/// any FHIR3 code may be used; 
/// procedure-reason shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property reasonCode As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "reasonCode", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Explanation/Justification for test.
/// <p>
/// Condition | Observation
Property reasonReference As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "reasonReference", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Additional clinical information.
/// <p>
/// Any FHIR3 Resource may be indicated by this Reference
Property supportingInfo As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "supportingInfo", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Procedure Samples.
/// <p>
/// Specimen
Property specimen As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "specimen", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Location on Body.
/// <p>
/// any FHIR3 code may be used; 
/// body-site shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property bodySite As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "bodySite", XMLPROJECTION = "ELEMENT");

/// Annotation
/// <p>
/// Comments.
Property note As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Annotation(XMLNAME = "note", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Request provenance.
/// <p>
/// Provenance
Property relevantHistory As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "relevantHistory", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ProcedureRequest";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ProcedureRequest";

}
