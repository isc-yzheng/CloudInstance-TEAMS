/// A list of events of interest in the lifecycle.
Class HS.FHIR.DTL.vDSTU2.Model.Element.DiagnosticOrder.event Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// code
/// <p>
/// proposed | draft | planned | requested | received | accepted | in-progress | review | completed | cancelled | suspended | rejected | failed
/// <p>
/// diagnostic-order-status is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend diagnostic-order-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// CodeableConcept
/// <p>
/// More information about the event and its context.
/// <p>
/// any FHIR2 code may be used; 
/// diagnostic-order-event shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property description As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "description", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// The date at which the event happened.
Property dateTime As %String(MAXLEN = 1000000, XMLNAME = "dateTime", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Reference
/// <p>
/// Who recorded or did this.
/// <p>
/// Practitioner | Device
Property actor As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "actor", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "DiagnosticOrder.event";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "DiagnosticOrder.event";

}
