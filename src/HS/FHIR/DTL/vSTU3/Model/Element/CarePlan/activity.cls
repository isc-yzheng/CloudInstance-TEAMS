/// Action to occur as part of plan.
Class HS.FHIR.DTL.vSTU3.Model.Element.CarePlan.activity Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// Results of the activity.
/// <p>
/// any FHIR3 code may be used; 
/// care-plan-activity-outcome shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property outcomeCodeableConcept As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "outcomeCodeableConcept", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Appointment, 
/// Encounter, 
/// Procedure, 
/// etc.
/// <p>
/// Any FHIR3 Resource may be indicated by this Reference
Property outcomeReference As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "outcomeReference", XMLPROJECTION = "ELEMENT");

/// Annotation
/// <p>
/// Comments about the activity status/progress.
Property progress As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Annotation(XMLNAME = "progress", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Activity details defined in specific resource.
/// <p>
/// Appointment | CommunicationRequest | DeviceRequest | MedicationRequest | NutritionOrder | Task | ProcedureRequest | ReferralRequest | VisionPrescription | RequestGroup
Property reference As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "reference", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// In-line definition of activity.
Property detail As HS.FHIR.DTL.vSTU3.Model.Element.CarePlan.activity.detail(XMLNAME = "detail", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "CarePlan.activity";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "CarePlan.activity";

}
