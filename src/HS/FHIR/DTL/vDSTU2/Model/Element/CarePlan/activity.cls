/// Action to occur as part of plan.
Class HS.FHIR.DTL.vDSTU2.Model.Element.CarePlan.activity Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Reference
/// <p>
/// Appointments, 
/// orders, 
/// etc.
/// <p>
/// Any FHIR2 Resource may be indicated by this Reference
Property actionResulting As list Of HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "actionResulting", XMLPROJECTION = "ELEMENT");

/// Annotation
/// <p>
/// Comments about the activity status/progress.
Property progress As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Annotation(XMLNAME = "progress", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Activity details defined in specific resource.
/// <p>
/// Appointment | CommunicationRequest | DeviceUseRequest | DiagnosticOrder | MedicationOrder | NutritionOrder | Order | ProcedureRequest | ProcessRequest | ReferralRequest | SupplyRequest | VisionPrescription
Property reference As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "reference", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// In-line definition of activity.
Property detail As HS.FHIR.DTL.vDSTU2.Model.Element.CarePlan.activity.detail(XMLNAME = "detail", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "CarePlan.activity";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "CarePlan.activity";

}
