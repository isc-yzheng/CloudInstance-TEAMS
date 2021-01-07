/// An action that is being or was performed on a patient.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.Procedure Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// External Identifiers for this procedure.
Property identifier As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Who the procedure was performed on.
/// <p>
/// Patient | Group
Property subject As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "subject", XMLPROJECTION = "ELEMENT") [ Required ];

/// code
/// <p>
/// in-progress | aborted | completed | entered-in-error
/// <p>
/// procedure-status is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend procedure-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// CodeableConcept
/// <p>
/// Classification of the procedure.
/// <p>
/// any FHIR2 code may be used; 
/// procedure-category shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property category As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "category", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Identification of the procedure.
/// <p>
/// any FHIR2 code may be used; 
/// procedure-code shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property code As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "code", XMLPROJECTION = "ELEMENT") [ Required ];

/// boolean
/// <p>
/// True if procedure was not performed as scheduled.
Property notPerformed As %Boolean(XMLNAME = "notPerformed", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Reason procedure was not performed.
/// <p>
/// any FHIR2 code may be used; 
/// procedure-not-performed-reason shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property reasonNotPerformed As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "reasonNotPerformed", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Target body sites.
/// <p>
/// any FHIR2 code may be used; 
/// body-site shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property bodySite As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "bodySite", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Reason procedure performed.
/// <p>
/// any FHIR2 code may be used; 
/// procedure-reason shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property reasonCodeableConcept As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "reasonCodeableConcept", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Reason procedure performed.
/// <p>
/// Condition.
Property reasonReference As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "reasonReference", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// The people who performed the procedure.
Property performer As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Procedure.performer(XMLNAME = "performer", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// Date/Period the procedure was performed.
Property performedDateTime As %String(MAXLEN = 1000000, XMLNAME = "performedDateTime", XMLPROJECTION = "ATTRIBUTE");

/// Period
/// <p>
/// Date/Period the procedure was performed.
Property performedPeriod As HS.FHIR.DTL.vDSTU2.Model.Datatype.Period(XMLNAME = "performedPeriod", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// The encounter associated with the procedure.
/// <p>
/// Encounter
Property encounter As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "encounter", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Where the procedure happened.
/// <p>
/// Location
Property location As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "location", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// The result of procedure.
/// <p>
/// any FHIR2 code may be used; 
/// procedure-outcome shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property outcome As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "outcome", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Any report resulting from the procedure.
/// <p>
/// DiagnosticReport
Property report As list Of HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "report", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Complication following the procedure.
/// <p>
/// any FHIR2 code may be used; 
/// condition-code shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property complication As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "complication", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Instructions for follow up.
/// <p>
/// any FHIR2 code may be used; 
/// procedure-followup shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property followUp As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "followUp", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// A request for this procedure.
/// <p>
/// CarePlan | DiagnosticOrder | ProcedureRequest | ReferralRequest
Property request As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "request", XMLPROJECTION = "ELEMENT");

/// Annotation
/// <p>
/// Additional information about the procedure.
Property notes As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Annotation(XMLNAME = "notes", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Device changed in procedure.
Property focalDevice As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Procedure.focalDevice(XMLNAME = "focalDevice", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Items used during procedure.
/// <p>
/// Device | Medication | Substance
Property used As list Of HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "used", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Procedure";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Procedure";

}
