/// Participants involved in appointment.
Class HS.FHIR.DTL.vSTU3.Model.Element.Appointment.participant Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// Role of participant in the appointment.
/// <p>
/// encounter-participant-type is the REQUIRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in encounter-participant-type, 
/// you may formally EXTEND encounter-participant-type to add codes to it.
Property type As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Person, 
/// Location/HealthcareService or Device.
/// <p>
/// Patient | Practitioner | RelatedPerson | Device | HealthcareService | Location
Property actor As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "actor", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// required | optional | information-only
/// <p>
/// participantrequired is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend participantrequired and you may NOT use codes from other ValueSets.
Property required As %String(MAXLEN = 1000000, XMLNAME = "required", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// accepted | declined | tentative | needs-action
/// <p>
/// participationstatus is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend participationstatus and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Appointment.participant";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Appointment.participant";

}
