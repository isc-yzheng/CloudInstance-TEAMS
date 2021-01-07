/// Represents a request for a patient to employ a medical device. 
/// The device may be an implantable device, 
/// or an external assistive device, 
/// such as a walker.
Class HS.FHIR.DTL.vSTU3.Model.Resource.DeviceRequest Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// External Request identifier.
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
Property priorRequest As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "priorRequest", XMLPROJECTION = "ELEMENT");

/// Identifier
/// <p>
/// Identifier of composite request.
Property groupIdentifier As HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "groupIdentifier", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// draft | active | suspended | completed | entered-in-error | cancelled
/// <p>
/// request-status is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend request-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// proposal | plan | original-order | encoded | reflex-order
/// <p>
/// request-intent is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend request-intent and you may NOT use codes from other ValueSets.
Property intent As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "intent", XMLPROJECTION = "ELEMENT") [ Required ];

/// code
/// <p>
/// Indicates how quickly the {{title}} should be addressed with respect to other requests.
/// <p>
/// request-priority is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend request-priority and you may NOT use codes from other ValueSets.
Property priority As %String(MAXLEN = 1000000, XMLNAME = "priority", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
///  Device requested.
/// <p>
/// any FHIR3 code may be used; 
/// device-kind shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property codeCodeableConcept As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "codeCodeableConcept", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
///  Device requested.
/// <p>
/// Device.
Property codeReference As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "codeReference", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Focus of request.
/// <p>
/// Patient | Group | Location | Device
Property subject As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "subject", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Encounter or Episode motivating request.
/// <p>
/// Encounter | EpisodeOfCare
Property context As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "context", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
///  Desired time or schedule for use.
Property occurrenceDateTime As %String(MAXLEN = 1000000, XMLNAME = "occurrenceDateTime", XMLPROJECTION = "ATTRIBUTE");

/// Period
/// <p>
///  Desired time or schedule for use.
Property occurrencePeriod As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "occurrencePeriod", XMLPROJECTION = "ELEMENT");

/// Timing
/// <p>
///  Desired time or schedule for use.
Property occurrenceTiming As HS.FHIR.DTL.vSTU3.Model.Datatype.Timing(XMLNAME = "occurrenceTiming", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// When recorded.
Property authoredOn As %String(MAXLEN = 1000000, XMLNAME = "authoredOn", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Who/what is requesting diagnostics.
Property requester As HS.FHIR.DTL.vSTU3.Model.Element.DeviceRequest.requester(XMLNAME = "requester", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Fille role.
/// <p>
/// any FHIR3 code may be used; 
/// participant-role shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property performerType As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "performerType", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Requested Filler.
/// <p>
/// Practitioner | Organization | Patient | Device | RelatedPerson | HealthcareService
Property performer As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "performer", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Coded Reason for request.
/// <p>
/// any FHIR3 code may be used; 
/// condition-code shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property reasonCode As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "reasonCode", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Linked Reason for request.
/// <p>
/// Any FHIR3 Resource may be indicated by this Reference
Property reasonReference As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "reasonReference", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Additional clinical information.
/// <p>
/// Any FHIR3 Resource may be indicated by this Reference
Property supportingInfo As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "supportingInfo", XMLPROJECTION = "ELEMENT");

/// Annotation
/// <p>
/// Notes or comments.
Property note As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Annotation(XMLNAME = "note", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Request provenance.
/// <p>
/// Provenance
Property relevantHistory As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "relevantHistory", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "DeviceRequest";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "DeviceRequest";

}
