/// A task to be performed.
Class HS.FHIR.DTL.vSTU3.Model.Resource.Task Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Task Instance Identifier.
Property identifier As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
///  Formal definition of task.
/// <p>
/// ActivityDefinition.
Property definitionReference As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "definitionReference", XMLPROJECTION = "ELEMENT");

/// uri
/// <p>
///  Formal definition of task.
Property definitionUri As %String(MAXLEN = 1000000, XMLNAME = "definitionUri", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Request fulfilled by this task.
/// <p>
/// Any FHIR3 Resource may be indicated by this Reference
Property basedOn As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "basedOn", XMLPROJECTION = "ELEMENT");

/// Identifier
/// <p>
/// Requisition or grouper id.
Property groupIdentifier As HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "groupIdentifier", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Composite task.
/// <p>
/// Task
Property partOf As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "partOf", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// draft | requested | received | accepted | +
/// <p>
/// task-status is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend task-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// CodeableConcept
/// <p>
/// Reason for current status.
/// <p>
/// any FHIR3 code from any ValueSet may be used.
Property statusReason As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "statusReason", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// E.g. 
/// "Specimen collected", 
/// "IV prepped"
/// <p>
/// any FHIR3 code from any ValueSet may be used.
Property businessStatus As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "businessStatus", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// proposal | plan | order +
/// <p>
/// request-intent is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend request-intent and you may NOT use codes from other ValueSets.
Property intent As %String(MAXLEN = 1000000, XMLNAME = "intent", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// code
/// <p>
/// normal | urgent | asap | stat
/// <p>
/// request-priority is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend request-priority and you may NOT use codes from other ValueSets.
Property priority As %String(MAXLEN = 1000000, XMLNAME = "priority", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Task Type.
/// <p>
/// any FHIR3 code from any ValueSet may be used.
Property code As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "code", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Human-readable explanation of task.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// What task is acting on.
/// <p>
/// Any FHIR3 Resource may be indicated by this Reference
Property focus As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "focus", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Beneficiary of the Task.
/// <p>
/// Any FHIR3 Resource may be indicated by this Reference
Property for As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "for", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Healthcare event during which this task originated.
/// <p>
/// Encounter | EpisodeOfCare
Property context As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "context", XMLPROJECTION = "ELEMENT");

/// Period
/// <p>
/// Start and end time of execution.
Property executionPeriod As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "executionPeriod", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// Task Creation Date.
Property authoredOn As %String(MAXLEN = 1000000, XMLNAME = "authoredOn", XMLPROJECTION = "ATTRIBUTE");

/// dateTime
/// <p>
/// Task Last Modified Date.
Property lastModified As %String(MAXLEN = 1000000, XMLNAME = "lastModified", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Who is asking for task to be done.
Property requester As HS.FHIR.DTL.vSTU3.Model.Element.Task.requester(XMLNAME = "requester", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// requester | dispatcher | scheduler | performer | monitor | manager | acquirer | reviewer
/// <p>
/// task-performer-type is the PREFERRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in task-performer-type, 
/// you may use codes from any ValueSet.
Property performerType As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "performerType", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Responsible individual.
/// <p>
/// Device | Organization | Patient | Practitioner | RelatedPerson
Property owner As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "owner", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Why task is needed.
/// <p>
/// any FHIR3 code from any ValueSet may be used.
Property reason As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "reason", XMLPROJECTION = "ELEMENT");

/// Annotation
/// <p>
/// Comments made about the task.
Property note As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Annotation(XMLNAME = "note", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Key events in history of the Task.
/// <p>
/// Provenance
Property relevantHistory As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "relevantHistory", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Constraints on fulfillment tasks.
Property restriction As HS.FHIR.DTL.vSTU3.Model.Element.Task.restriction(XMLNAME = "restriction", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Information used to perform task.
Property input As list Of HS.FHIR.DTL.vSTU3.Model.Element.Task.input(XMLNAME = "input", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Information produced as part of task.
Property output As list Of HS.FHIR.DTL.vSTU3.Model.Element.Task.output(XMLNAME = "output", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Task";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Task";

}
