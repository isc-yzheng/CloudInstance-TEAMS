/// A request for a procedure to be performed.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.ProcedureRequest Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Unique identifier for the request.
Property identifier As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Who the procedure should be done to.
/// <p>
/// Patient | Group
Property subject As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "subject", XMLPROJECTION = "ELEMENT") [ Required ];

/// CodeableConcept
/// <p>
/// What procedure to perform.
/// <p>
/// any FHIR2 code may be used; 
/// procedure-code shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property code As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "code", XMLPROJECTION = "ELEMENT") [ Required ];

/// CodeableConcept
/// <p>
/// What part of body to perform on.
/// <p>
/// any FHIR2 code may be used; 
/// body-site shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property bodySite As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "bodySite", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Why procedure should occur.
/// <p>
/// any FHIR2 code may be used; 
/// procedure-reason shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property reasonCodeableConcept As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "reasonCodeableConcept", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Why procedure should occur.
/// <p>
/// Condition.
Property reasonReference As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "reasonReference", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// When procedure should occur.
Property scheduledDateTime As %String(MAXLEN = 1000000, XMLNAME = "scheduledDateTime", XMLPROJECTION = "ATTRIBUTE");

/// Period
/// <p>
/// When procedure should occur.
Property scheduledPeriod As HS.FHIR.DTL.vDSTU2.Model.Datatype.Period(XMLNAME = "scheduledPeriod", XMLPROJECTION = "ELEMENT");

/// Timing
/// <p>
/// When procedure should occur.
Property scheduledTiming As HS.FHIR.DTL.vDSTU2.Model.Datatype.Timing(XMLNAME = "scheduledTiming", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Encounter request created during.
/// <p>
/// Encounter
Property encounter As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "encounter", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Who should perform the procedure.
/// <p>
/// Practitioner | Organization | Patient | RelatedPerson
Property performer As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "performer", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// proposed | draft | requested | received | accepted | in-progress | completed | suspended | rejected | aborted
/// <p>
/// procedure-request-status is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend procedure-request-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE");

/// Annotation
/// <p>
/// Additional information about desired procedure.
Property notes As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Annotation(XMLNAME = "notes", XMLPROJECTION = "ELEMENT");

/// boolean
/// <p>
/// Preconditions for procedure.
Property asNeededBoolean As %Boolean(XMLNAME = "asNeededBoolean", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Preconditions for procedure.
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property asNeededCodeableConcept As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "asNeededCodeableConcept", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// When request was created.
Property orderedOn As %String(MAXLEN = 1000000, XMLNAME = "orderedOn", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Who made request.
/// <p>
/// Practitioner | Patient | RelatedPerson | Device
Property orderer As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "orderer", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// routine | urgent | stat | asap
/// <p>
/// procedure-request-priority is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend procedure-request-priority and you may NOT use codes from other ValueSets.
Property priority As %String(MAXLEN = 1000000, XMLNAME = "priority", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ProcedureRequest";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ProcedureRequest";

}
