/// A guidance response is the formal response to a guidance request, 
/// including any output parameters returned by the evaluation, 
/// as well as the description of any proposed actions to be taken.
Class HS.FHIR.DTL.vSTU3.Model.Resource.GuidanceResponse Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// id
/// <p>
/// The id of the request associated with this response, 
/// if any.
Property requestId As %String(MAXLEN = 1000000, XMLNAME = "requestId", XMLPROJECTION = "ATTRIBUTE");

/// Identifier
/// <p>
/// Business identifier.
Property identifier As HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// A reference to a knowledge module.
/// <p>
/// ServiceDefinition
Property module As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "module", XMLPROJECTION = "ELEMENT") [ Required ];

/// code
/// <p>
/// success | data-requested | data-required | in-progress | failure | entered-in-error
/// <p>
/// guidance-response-status is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend guidance-response-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Reference
/// <p>
/// Patient the request was performed for.
/// <p>
/// Patient | Group
Property subject As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "subject", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Encounter or Episode during which the response was returned.
/// <p>
/// Encounter | EpisodeOfCare
Property context As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "context", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// When the guidance response was processed.
Property occurrenceDateTime As %String(MAXLEN = 1000000, XMLNAME = "occurrenceDateTime", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Device returning the guidance.
/// <p>
/// Device
Property performer As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "performer", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Reason for the response.
/// <p>
/// any FHIR3 code from any ValueSet may be used.
Property reasonCodeableConcept As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "reasonCodeableConcept", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Reason for the response.
/// <p>
/// Any FHIR3 Resource may be indicated by this Reference.
Property reasonReference As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "reasonReference", XMLPROJECTION = "ELEMENT");

/// Annotation
/// <p>
/// Additional notes about the response.
Property note As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Annotation(XMLNAME = "note", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Messages resulting from the evaluation of the artifact or artifacts.
/// <p>
/// OperationOutcome
Property evaluationMessage As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "evaluationMessage", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// The output parameters of the evaluation, 
/// if any.
/// <p>
/// Parameters
Property outputParameters As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "outputParameters", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Proposed actions, 
/// if any.
/// <p>
/// CarePlan | RequestGroup
Property result As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "result", XMLPROJECTION = "ELEMENT");

/// DataRequirement
/// <p>
/// Additional required data.
Property dataRequirement As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.DataRequirement(XMLNAME = "dataRequirement", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "GuidanceResponse";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "GuidanceResponse";

}
